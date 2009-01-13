require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  context "Getting the ticket list for a project" do
    context "when not logged in" do
      setup do
        get :index
      end

      should_respond_with :redirect

      should "redirect to new session (login)" do
        assert_redirected_to :controller => 'sessions', :action => 'new'
      end
    end

    context "when logged in as quentin" do
      setup do
        login_as(:quentin)
        get :index, :project_id => 8037, :bin_id => 5933
      end

      should "retrieve a list of tickets" do
        assert_response :success
        assert_equal 30, assigns(:tickets).length
      end
    end
  end

  context "Retrieving a specific ticket" do
    setup do
      login_as(:quentin)
      get :show, :project_id => 8037, :bin_id => 5933, :ticket_id => 254
    end

    should_respond_with :success

    should "assign @ticket" do
      assert_equal "Snipe error", assigns(:ticket).title
    end

    should "have a user map that includes Morgan Schweers as user id 27881" do
      assert_equal "Morgan Schweers", assigns(:user_map)[27881].name
    end
  end
end
