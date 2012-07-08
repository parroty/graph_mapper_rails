require_dependency "graph_mapper_rails/application_controller"

require 'graph_mapper'
require 'graph_adapter/highchart'

module GraphMapperRails
  class GraphController < ApplicationController
    def index
      @klass = Initializer.config.mapper_klass
      @pie_charts, @line_charts = get_graph(@klass)
    end

    def setting
      @klass   = Initializer.config.mapper_klass
      @fields  = @klass.column_names

      base_methods = ActiveRecord::Base.methods
      @methods = @klass.methods.reject { | method | base_methods.include?(method) }

      @selected_items = {
        :date    => Setting.get_option(@klass, "date"),
        :value   => Setting.get_option(@klass, "value"),
        :keyword => Setting.get_option(@klass, "keyword"),
        :method  => Setting.get_option(@klass, "method"),
        :span    => Setting.get_option(@klass, "span"),
        :date_format => Setting.get_option(@klass, "date_format"),
        :moving_average_length => Setting.get_option(@klass, "moving_average_length")
      }

      @radio_options = [nil] * 2
      @radio_options[Setting.get_option(@klass, "type").to_i] = { :checked => true }

      @pie_charts, @line_charts = get_graph(@klass)
    end

    def update_setting
      klass = Initializer.config.mapper_klass
      Setting.set_option(klass, "date", params[:setting][:date])
      Setting.set_option(klass, "value", params[:setting][:value])
      Setting.set_option(klass, "keyword", params[:setting][:keyword])
      Setting.set_option(klass, "method", params[:setting][:method])
      Setting.set_option(klass, "type" , params[:type])

      Setting.set_option(klass, "span" , params[:date_setting][:span])
      Setting.set_option(klass, "date_format" , params[:date_format])
      Setting.set_option(klass, "moving_average_length" , params[:moving_average_length])

      flash[:notice] = "Settings are successfully updated."
      redirect_to graph_setting_path
    end

  private
    def get_graph(klass)
      config = Initializer.config

      case Setting.get_option(@klass, "span")
      when "Monthly"
        span_type = GraphMapper::SPAN_MONTHLY
      when "Weekly"
        span_type = GraphMapper::SPAN_WEEKLY
      when "Daily"
        span_type = GraphMapper::SPAN_DAILY
      end

      config.set_options do | options |
        options.span_type = span_type
        options.date_format = Setting.get_option(@klass, "date_format")
        options.moving_average_length = Setting.get_option(@klass, "moving_average_length").to_i
      end

      pie_charts  = get_pie_charts(config)
      line_charts = get_line_charts(config, klass)

      [pie_charts, line_charts]
    end

    def get_pie_charts(config)
      charts = []

      m = config.grouping.get_mapper
      hc = GraphAdapter::Highchart.new({:title => "Pie Chart"})
      c = hc.get_charts

      c.chart(:defaultSeriesType => "pie", :height => 250, :borderRadius => 1)
      c.plotOptions(:series => {:animation => false})
      c.plotOptions(:pie => {
         :animation => false,
         :allowPointSelect => false,
         :cursor => "pointer",
         :dataLabels => {
            :enabled => true,
            :color => "black",
            :style => { :font => "13px Trebuchet MS, Verdana, sans-serif" }
          }
      })
      c.series(:name => "pie", :yAxis => 0, :data => m.hash.to_a)
      charts << c

      charts
    end

    def get_line_charts(config, klass)
      charts = []

      if klass.respond_to?(:from_graph_mapper_keywords)
        klass.from_graph_mapper_keywords.each do | keyword |
          m  = config.date.get_mapper(keyword)
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
