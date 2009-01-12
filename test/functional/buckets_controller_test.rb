require 'test_helper'

class BucketsControllerTest < ActionController::TestCase
  def setup
    login_as :quentin
  end

  context "Index" do
    setup do
      get :index
    end

    should "be successful" do
      assert_response :success
    end

    should "get list of buckets" do
      assert_not_nil assigns(:buckets)
    end
  end

  context "Constructing a new bucket" do
    setup do
      get :new
    end

    should "be successful" do
      assert_response :success
    end

    should "assign a bucket variable that is a new record" do
      assert_not_nil assigns(:bucket)
      assert assigns(:bucket).new_record?
    end

    should "assign milestones appropriate for the project" do
      assert_not_nil assigns(:milestones)
      assert_equal 3, assigns(:milestones).length
    end

    should "assign states that include all the open and closed states for the project" do
      assert_not_nil assigns(:states)
      assert_same_elements ["-do not change"] + ["open", "resolved", "invalid", "reopened", "duplicate", "hold", "closed", "new"], assigns(:states)
    end
  end

  should "create a bucket" do
    assert_difference('Bucket.count') do
      post :create, :bucket => { :tag => 'frippery' }
    end

    assert_redirected_to bucket_path(assigns(:bucket))
  end

  should "show bucket" do
    get :show, :id => buckets(:details).id
    assert_response :success
  end

  should "get the edit page for the 'acknowledged' bucket" do
    get :edit, :id => buckets(:acknowledged).id
    assert_response :success
  end

  should "update the feature bucket to assign the state to 'feature'" do
    put :update, :id => buckets(:feature).id, :bucket => { :state => 'feature' }
    assert_redirected_to bucket_path(assigns(:bucket))
  end

  should "be able to destroy a bucket" do
    assert_difference('Bucket.count', -1) do
      delete :destroy, :id => buckets(:invalid).id
    end

    assert_redirected_to buckets_path
  end
end
