require 'test_helper'

class BinsControllerTest < ActionController::TestCase
  test "Getting the bin list for a project fails if not logged in" do
    get :index
    assert_response :redirect
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  test "Get a list of bins" do
    login_as(:quentin)
    get :index, :project_id => 8037
    assert_equal 3, assigns(:bins).length
    assert_equal "New tickets", assigns(:bins).first.name
  end
end
