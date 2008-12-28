require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  test "Getting the ticket list for a project fails if not logged in" do
    get :index
    assert_response :redirect
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  test "Get a list of tickets" do
    login_as(:quentin)
    get :index, :project_id => 8037, :bin_id => 5933
    assert_response :success
    assert_equal 30, assigns(:tickets).length
  end

  test "Get a specific ticket" do
    login_as(:quentin)
    get :show, :project_id => 8037, :bin_id => 5933, :ticket_id => 254
    assert_response :success
    assert_equal "Snipe error", assigns(:ticket).title
    assert_equal "Morgan Schweers", assigns(:user_map)[27881].name
  end
end
