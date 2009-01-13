require 'test_helper'

class BinsControllerTest < ActionController::TestCase
  context "Accessing the list of bins for a project without logging in" do
    setup do
      get :index
    end

    should_respond_with :redirect

    should "redirect to new session (login)" do
      assert_redirected_to :controller => 'sessions', :action => 'new'
    end
  end

  context "Listing the bins for the JBidwatcher project" do
    setup do
      login_as(:quentin)
      get :index, :project_id => projects(:jbidwatcher).lighthouse_id
    end

    should "return three bins" do
      assert_equal 3, assigns(:bins).length
    end

    should "have 'New tickets' as the first bin" do
      assert_equal "New tickets", assigns(:bins).first.name
    end
  end
end
