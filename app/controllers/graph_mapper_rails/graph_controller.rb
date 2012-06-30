require_dependency "graph_mapper_rails/application_controller"

require 'graph_mapper'
require 'graph_adapter/highchart'

module GraphMapperRails
  class GraphController < ApplicationController
    def index
      config = Initializer.config

      @highcharts_js_path = config.highcharts_js_path
      @klass  = config.mapper_klass

      @pie_charts  = get_pie_charts(config)
      @line_charts = get_line_charts(config, @klass)
    end

  private
    def get_pie_charts(config)
      charts = []

      m = config.grouping.get_mapper
      hc = GraphAdapter::Highchart.new({:title => "Pie Chart"})
      c = hc.get_charts

      c.chart(:defaultSeriesType => "pie", :height => 250, :borderRadius => 1)
      c.plotOptions(:series => {:animation => false})
      c.series(:name => "pie", :yAxis => 0, :data => m.hash.to_a)
      charts << c

      charts
    end

    def get_line_charts(config, klass)
      charts = []

      if klass.respond_to?(:from_graph_mapper_keywords)
        klass.from_graph_mapper_keywords.each do | keyword |
          m  = config.get_mapper(keyword)
          hc = GraphAdapter::Highchart.new({:title => keyword})
          c  = hc.get_charts

          c.chart(:defaultSeriesType => "line", :height => 250, :borderRadius => 1)
          c.plotOptions(:series => {:animation => false})
          c.xAxis(:categories => m.keys, :tickInterval => 2)

          c.series(:name => keyword, :yAxis => 0, :data => m.values, :color => config.colors[:line])

          if config.use_average
            c.series(:name => "average", :yAxis => 0, :data => [[0, m.average],[m.keys.size - 1, m.average]],
                     :color => config.colors[:average])
          end

          if config.get_options[:moving_average_length]
            c.series(:name => "moving average", :yAxis => 0, :data => m.moving_average,
                     :dashStyle => 'ShortDash', :color => config.colors[:moving_average])
          end

          if klass.respond_to?(:from_graph_mapper_series)
            if series = klass.from_graph_mapper_series(keyword, m.keys.size)
              c.series(:name => series[:name], :yAxis => 0, :data => series[:data], :color => series[:color])
            end
          end

          charts << c
        end
      end

      charts
    end
  end
end
