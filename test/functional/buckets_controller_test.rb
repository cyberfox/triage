require 'test_helper'

class BucketsControllerTest < ActionController::TestCase
  def setup
    login_as :quentin
  end

  context "Getting the list of buckets" do
    setup do
      get :index
    end

    should_respond_with :success

    should "provide a non-empty array" do
      assert_not_nil assigns(:buckets)
      assert assigns(:buckets).length > 0
    end
  end

  context "Constructing a new bucket" do
    setup do
      get :new
    end

    should_respond_with :success

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
      assert_same_elements ["open", "resolved", "invalid", "reopened", "duplicate", "hold", "closed", "new"], assigns(:states)
    end
  end

  context "Creating a bad bucket" do
    should "not increase the number of buckets" do
      assert_no_difference('Bucket.count') do
        post :create
      end
    end
  end

  context "Creating a bucket" do
    should "increase the number of buckets by one" do
      assert_difference('Bucket.count') do
        post :create, :bucket => { :tag => 'frippery' }
      end
    end

    should "redirect to the 'show' action for the new bucket" do
      post :create, :bucket => { :tag => 'frippery' }
      assert_redirected_to bucket_path(assigns(:bucket))
    end

    should "set the state correctly" do
      post :create, :bucket => { :tag => 'frippery', :state => 'open' }
      assert_equal 'open', assigns(:bucket).state
    end

    should "leave the state nil if 'do not change' is selected" do
      post :create, :bucket => { :tag => 'frippery', :state => '' }
      assert_nil assigns(:bucket).state
    end

    should "set the milestone correctly" do
      post :create, :bucket => { :tag => 'frippery', :milestone_id => milestones(:features).id }
      assert_equal milestones(:features).id, assigns(:bucket).milestone_id
    end

    should "leave the milestone nil if 'do not change' is selected" do
      post :create, { :bucket => { :tag => 'frippery' }, :milestone => { :id => '' } }
      assert_nil assigns(:bucket).milestone_id
    end
  end

  context "Creating a bucket through XMLHttpRequest" do
    setup do
      @request.session[:ticket_number] = tickets(:bad_sort).number
      assert_difference('Bucket.count') do
        xhr :post, :create, :bucket => { :tag => 'frappe', :description => 'An icy cold coffee drink' }
      end
    end

    should "use topblock partial" do
      assert_template 'buckets/_topblock.html.erb'
    end

    should "create a new bucket with 'frappe' as its tag" do
      frappe = Bucket.find_by_tag('frappe')
      assert_not_nil frappe
      assert_equal 'An icy cold coffee drink', frappe.description
    end
  end

  context "Editing a bucket through XMLHttpRequest" do
    setup do
      @request.session[:ticket_number] = tickets(:bad_sort).number

      assert_no_difference('Bucket.count') do
        xhr :post, :create, :bucket => { :id => buckets(:investigate).id, :tag => 'invest', :description => 'Give power to' }
      end
    end

    should "have updated the investigate ticket" do
      b = buckets(:investigate).reload
      assert_equal "invest", b.tag
      assert_equal 'Give power to', b.description
    end
  end

  should "show bucket" do
    get :show, :id => buckets(:details).id
    assert_response :success
  end

  should "successfully get the edit page for the 'acknowledged' bucket" do
    get :edit, :id => buckets(:acknowledged).id
    assert_response :success
  end

  context "Updating the feature bucket" do
    should "fail with bad data" do
      put :update, :id => buckets(:feature).id, :bucket => { :tag => nil }
    end

    should "not change anything when no bucket is submitted" do
      feature = buckets(:feature)
      updated = feature.updated_at
      put :update, :id => buckets(:feature).id
      feature.reload
      assert_equal feature.updated_at, updated
    end

    should "allow setting an empty state" do
      put :update, :id => buckets(:feature).id, :bucket => { :state => '' }
      assert_nil assigns(:bucket).state
    end

    should "allow setting an empty milestone" do
      put :update, :id => buckets(:feature).id, :bucket => { :milestone_id => '' }
      assert_nil assigns(:bucket).milestone_id
    end

    context "to a state of 'duplicate'" do
      setup do
        put :update, :id => buckets(:feature).id, :bucket => { :state => 'duplicate' }
      end

      should_respond_with :redirect

      should "redirect to the 'show bucket' page" do
        assert_redirected_to bucket_path(assigns(:bucket))
      end

      should "be able to set the state to 'duplicate'" do
        assert_equal 'duplicate', assigns(:bucket).state
      end
    end
  end

  should "be able to destroy a bucket" do
    assert_difference('Bucket.count', -1) do
      delete :destroy, :id => buckets(:invalid).id
    end

    assert_redirected_to buckets_path
  end
end
