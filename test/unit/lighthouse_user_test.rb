require 'test_helper'

class LighthouseUserTest < ActiveSupport::TestCase
  test "Loading a normal user works" do
    lu = LighthouseUser.get(13969)
    assert_equal "forum.jbidwatcher.com", lu.website
  end

  test "Loading an out of date user updates them" do
    original = lighthouse_users(:random)
    assert_equal "Random User", original.name
    lu = LighthouseUser.get(1337)
    assert_equal "Morgan Schweers", lu.name
    assert lu.updated_at > 1.second.ago

    original.reload
    assert_equal original, lu
  end

  test "Loading an uncached user retrieves it from the API" do
    assert_difference "LighthouseUser.count" do
      lu = LighthouseUser.get(7331)
      assert_equal "Morgan Schweers", lu.name
    end
  end

  test "Loading a user that doesn't exist returns nil" do
    assert_no_difference "LighthouseUser.count" do
      lu = LighthouseUser.get(2989)
      assert_nil lu
    end
  end
end
