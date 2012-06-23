require 'test_helper'

module GraphMapperRails
  class GraphControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success
    end
  
  end
end
