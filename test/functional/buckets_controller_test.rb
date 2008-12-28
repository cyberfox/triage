require 'test_helper'

class BucketsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buckets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bucket" do
    assert_difference('Bucket.count') do
      post :create, :bucket => { :tag => 'frippery', :user => users(:quentin) }
    end

    assert_redirected_to bucket_path(assigns(:bucket))
  end

  test "should show bucket" do
    get :show, :id => buckets(:details).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => buckets(:acknowledged).id
    assert_response :success
  end

  test "should update bucket" do
    put :update, :id => buckets(:feature).id, :bucket => { :state => 'feature' }
    assert_redirected_to bucket_path(assigns(:bucket))
  end

  test "should destroy bucket" do
    assert_difference('Bucket.count', -1) do
      delete :destroy, :id => buckets(:invalid).id
    end

    assert_redirected_to buckets_path
  end
end
