require 'test_helper'

class BucketTest < ActiveSupport::TestCase
  test "Applying a bucket to a ticket updates that ticket" do
    buckets(:feature).apply(tickets(:snipe_error))
  end
end
