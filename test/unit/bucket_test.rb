require 'test_helper'

class BucketTest < ActiveSupport::TestCase
  test "Applying the feature bucket to a ticket should add a 'featurerequest' tag" do
    @ticket = tickets(:bad_sort)
    deny @ticket.lighthouse.tags.include?('featurerequest'), "Ticket's tags should not include 'featurerequest' initially"
    buckets(:feature).apply_one(@ticket)
    assert @ticket.lighthouse.tags.include?('featurerequest'), "Ticket's tags should include 'featurerequest'"
  end

  test "Applying the feature bucket to a ticket should set the milestone" do
    @ticket = tickets(:bad_sort)
    assert_equal milestones(:full_release).lighthouse_id, @ticket.lighthouse.milestone_id, "Ticket should be in the milestone 'full_release' before bucketing."
    buckets(:feature).apply_one(@ticket)
    assert_equal milestones(:features).lighthouse_id, @ticket.lighthouse.milestone_id, "Ticket should have its milestone set to 'features'"
  end

  test "Applying the feature butcket to a ticket should set the state to 'open'" do
    @ticket = tickets(:bad_sort)
    assert_equal "new", @ticket.lighthouse.state, "Ticket should be in 'new' state before bucketing."
    buckets(:feature).apply_one(@ticket)
    assert_equal "open", @ticket.lighthouse.state, "Ticket should be 'open' after bucketing."
  end
end
