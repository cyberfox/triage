require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "Accessing projects without logging in should fail" do
    get :index
    assert_response :redirect
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  test "The first project should be JBidwatcher" do
    login_as(:quentin)
    get :index
    assert_response :success
    assert_equal "JBidwatcher", assigns(:projects).first.name
  end
end
