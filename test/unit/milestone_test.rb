require 'test_helper'

class MilestoneTest < ActiveSupport::TestCase
  test "Can retrieve all milestones for a project" do
    milestones = Milestone.all_lighthouse(projects(:jbidwatcher))
    assert_not_equal 0, milestones.length, "There should be at least 1 milestone for the :jbidwatcher project."
  end

  test "Retrieving all milestones when one is missing adds it" do
    assert_difference("Milestone.count", 1) do
      milestones = Milestone.all_lighthouse(projects(:missing))
    end
  end

  test "Retrieving a milestone which hasn't changed leaves the record alone" do
    original = YAML.load(milestones(:full_release).data)
    milestone = Milestone.find_by_project_and_milestone(projects(:jbidwatcher), original.id)
    assert_equal original, milestone
  end

  test "Retrieving a milestone when it has changed on the server updates it" do
    original = YAML.load(milestones(:full_out_of_date).data)
    milestone = Milestone.find_by_project_and_milestone(projects(:out_of_date), original.id)
    assert_not_equal original, milestone
  end

  test "Retrieving a milestone over 1 day old updates it" do
    original = YAML.load(milestones(:beta_out_of_date).data)
    milestone = Milestone.find_by_project_and_milestone(projects(:out_of_date), original.id)
    assert_not_equal original, milestone
  end
end
