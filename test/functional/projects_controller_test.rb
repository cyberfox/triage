require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "Accessing projects without logging in should fail" do
    get :index
    assert_response :redirect
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  context "Project list" do
    setup do
      login_as(:quentin)
      get :index
      assert_response :success
    end

    should "have JBidwatcher as the first project" do
      assert_not_nil assigns(:projects)
      assert_equal "JBidwatcher", assigns(:projects).first.name
    end

    should "assign a set of buckets that are available" do
      assert_not_nil assigns(:buckets)
      assert_equal 6, assigns(:buckets).length
    end
  end
end
