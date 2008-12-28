require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "The first project should be JBidwatcher" do
    get :index
    assert_response :success
    assert_equal "JBidwatcher", assigns(:projects).first.name
  end

  test "Choosing a project sets @project correctly" do
    get :choose, :id => 8037
    assert_response :success
    assert_equal "JBidwatcher", assigns(:project).name
  end
end
