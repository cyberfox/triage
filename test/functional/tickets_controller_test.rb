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
        tickets(:snipe_error).updated_at = Time.at(0)
        tickets(:snipe_error).lighthouse
        get :index, :project_id => projects(:jbidwatcher).lighthouse_id, :bin_id => 5933
      end

      should "retrieve a list of tickets" do
        assert_response :success
        assert_equal 30, assigns(:lh_tickets).length
      end
    end
  end

  context "Retrieving a specific ticket" do
    setup do
      login_as(:quentin)
      get :show, :project_id => projects(:jbidwatcher).lighthouse_id, :id => 580
    end

    should_respond_with :success

    should "assign @ticket, @users and @user_map" do
      assert_equal "Sorting with columns 'Current' or 'Price' give unsorted result", assigns(:lh_ticket).title
      assert_not_nil assigns(:user_map)
    end

    should "have a user map that includes Morgan Schweers as user id 27881" do
      assert_equal "Morgan Schweers", assigns(:user_map)[13969].name
    end
  end

  def setup_search
    login_as(:quentin)
    tickets(:snipe_error).updated_at = Time.at(0)
    tickets(:snipe_error).lighthouse
    @search_results = Ticket.search(projects(:jbidwatcher), 'milestone:next state:new sort:oldest').collect(&:number)
    @request.session[:tickets] = @search_results
    @first_index = @search_results.index(278)
    @request.session[:ticket_index] = @first_index
    @request.session[:ticket_search] = 'milestone:next state:new sort:oldest'
  end

  context "After a search" do
    setup do
      setup_search
    end

    should "allow 'next' to go to the next found ticket" do
      get :next, :project_id => projects(:jbidwatcher).lighthouse_id
      assert_redirected_to :action => 'show', :project_id => projects(:jbidwatcher).lighthouse_id, :id => @search_results[@first_index + 1]
      assert_equal @first_index + 1, @response.session[:ticket_index]
    end
  end

  context "Searching a projects tickets" do
    setup do
      login_as(:quentin)
      tickets(:snipe_error).updated_at = Time.at(0)
      tickets(:snipe_error).lighthouse
      get :search, :q => 'my ebay', :project_id => projects(:jbidwatcher).lighthouse_id
    end

    should_respond_with :success

    should "assign search, lh_project, lh_tickets and query" do
      assert_not_nil assigns(:lh_project)
      assert_not_nil assigns(:lh_tickets)
      assert_not_nil assigns(:result)
      assert_not_nil assigns(:query)
    end
  end

  context "Applying a bucket to a ticket as part of a search" do
    setup do
      setup_search
      post :apply, :project_id => projects(:jbidwatcher).lighthouse_id, :ticket_number => @search_results[@first_index], :bucket_id => buckets(:feature).id
    end

    should "be redirected to the next ticket" do
      assert_redirected_to :action => 'show', :project_id => projects(:jbidwatcher).lighthouse_id, :id => @search_results[@first_index+1]
    end

    should "set flash to an appropriate message" do
      assert_equal "Applied 'featurerequest' to 'Selling tab empty with 2.0beta8 [OS X 10.5.4]' (ticket #278).", @response.flash[:notice]
    end
  end

  context "Applying a bucket to a ticket" do
    setup do
      login_as(:quentin)
      set_project(:jbidwatcher)
      post :apply, :project_id => projects(:jbidwatcher).lighthouse_id, :ticket_number => tickets(:bad_sort).number, :bucket_id => buckets(:feature).id
    end

    should "redirect to the ticket (to see the result) when not part of a search" do
      assert_redirected_to :action => 'show', :project_id => projects(:jbidwatcher).lighthouse_id, :id => tickets(:bad_sort).number
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
