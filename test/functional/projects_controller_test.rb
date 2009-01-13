require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  context "Accessing projects without logging in" do
    setup do
      get :index
    end

    should_respond_with :redirect

    should "redirect to new session (login)" do
      assert_redirected_to :controller => 'sessions', :action => 'new'
    end
  end

  context "Project list" do
    setup do
      login_as(:quentin)
      get :index
    end

    should_respond_with :success

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
