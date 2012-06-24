require_dependency "graph_mapper_rails/application_controller"

require 'graph_mapper'
require 'graph_adapter/highchart'

module GraphMapperRails
  class GraphController < ApplicationController
    def index
      @charts = []
      config = Initializer.config
      config.klass.graph_keywords.each do | keyword |
        m = config.mapper(keyword)
        h = GraphAdapter::Highchart.new({:title => keyword})

        chart = h.get_charts

        chart.chart(:defaultSeriesType => "line", :height => 250, :borderRadius => 1)
        chart.xAxis(:categories => m.keys, :tickInterval => 2)
        chart.series(:name => keyword, :yAxis => 0, :data => m.values, :animation => false, :color => config.colors[:line])

        if config.use_average
          chart.series(:name => "average", :yAxis => 0, :data => [[0, m.average],[m.keys.size - 1, m.average]],
                       :animation => false, :color => config.colors[:average])
        end

        if config.moving_average_length
          graph_name = "moving average for #{config.moving_average_length} items"
          chart.series(:name => graph_name, :yAxis => 0, :data => m.moving_average.map,
                       :animation => false, :dashStyle => 'ShortDash', :color => config.colors[:moving_average])
        end

        @charts << h.get_charts
      end

      @charts
    end
  end
end
