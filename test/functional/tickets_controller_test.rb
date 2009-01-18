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
        get :index, :project_id => projects(:jbidwatcher).lighthouse_id, :bin_id => 5933
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
      get :show, :project_id => projects(:jbidwatcher).lighthouse_id, :bin_id => 5933, :id => 254
    end

    should_respond_with :success

    should "assign @ticket and @buckets" do
      assert_equal "Snipe error", assigns(:ticket).title
      assert_not_nil assigns(:buckets)
    end

    should "have a user map that includes Morgan Schweers as user id 27881" do
      assert_equal "Morgan Schweers", assigns(:user_map)[27881].name
    end
  end

  context "Searching a projects tickets" do
    setup do
      login_as(:quentin)
      get :search, :q => 'my ebay', :project_id => projects(:jbidwatcher).lighthouse_id
    end

    should_respond_with :success

    should "assign search, project and tickets" do
      assert_not_nil assigns(:tickets)
      assert_not_nil assigns(:result)
      assert_not_nil assigns(:project)
    end
  end

  context "Applying a bucket to a ticket" do
    setup do
      login_as(:quentin)
      set_project(:jbidwatcher)
      post :apply, :project_id => projects(:jbidwatcher).lighthouse_id, :ticket_number => tickets(:bad_sort).number, :bucket_id => buckets(:feature).id
    end

    should "assign the feature request bucket to @bucket" do
      assert_not_nil assigns(:bucket)
      assert_equal buckets(:feature), assigns(:bucket)
    end

    should "assign the same ticket to @ticket" do
      assert_not_nil assigns(:ticket)
      assert_equal tickets(:bad_sort), assigns(:ticket)
    end

    should "have changed the ticket, to match the bucket" do
      assert_contains assigns(:ticket).lighthouse.tags, 'featurerequest'
      assert_equal milestones(:features).lighthouse_id, assigns(:ticket).lighthouse.milestone_id
      assert_equal 'open', assigns(:ticket).lighthouse.state
    end
  end
end
