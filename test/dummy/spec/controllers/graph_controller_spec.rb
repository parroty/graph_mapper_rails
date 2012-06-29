require 'spec_helper'
require 'date'

module GraphMapperRails

describe GraphController do
  describe "show pages" do
    before(:each) { @routes = GraphMapperRails::Engine.routes }

    it "should show index page" do
      get :index

      response.should be_success
      assigns(:charts).size.should == Sample.from_graph_mapper_keywords.size
    end
  end
end

end
