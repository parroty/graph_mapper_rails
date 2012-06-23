require_dependency "graph_mapper_rails/application_controller"

require 'graph_mapper'
require 'graph_adapter/highchart'

module GraphMapperRails
  class GraphController < ApplicationController
    def index
      m = Initializer.mapper
      h = GraphAdapter::Highchart.new({:title => "Monthly Graph"})
      h.data({:name => "Graph", :key => m.keys, :value => m.values, :color => '#4572A7'})
      @chart = h.get_charts
    end
  end
end
