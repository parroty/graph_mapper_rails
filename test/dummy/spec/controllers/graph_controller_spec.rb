require 'spec_helper'
require 'date'

module GraphMapperRails

describe GraphController do
  describe "show pages" do
    before(:each) { @routes = GraphMapperRails::Engine.routes }

    before do
      class << Sample
        def from_graph_mapper_keywords
          ["aaa", "title", "hoge"]
        end

        def from_graph_mapper_series(keyword, length)
          {:name => "estimate", :data => [[0, 3],[length - 1, 3]], :color => "green"}
        end
      end
    end

    # todo : rewrite spec file
    # it "should show index page" do
    #   get :index
    #
    #   response.should be_success
    #   assigns(:pie_charts).size.should == 1
    #   assigns(:line_charts).size.should == Sample.from_graph_mapper_keywords.size
    # end
    #
    # it "should show index page - [from_graph_mapper_keywords method] is not defined" do
    #   class << Sample
    #     undef_method :from_graph_mapper_keywords
    #   end
    #
    #   get :index
    #
    #   response.should be_success
    #   assigns(:line_charts).size.should == 0
    # end
    #
    # it "should show index page - [from_graph_mapper_series] method is not defined" do
    #   class << Sample
    #     undef_method :from_graph_mapper_series
    #   end
    #
    #   get :index
    #
    #   response.should be_success
    #   assigns(:line_charts).size.should == Sample.from_graph_mapper_keywords.size
    # end

  end
end

end
