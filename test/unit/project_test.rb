require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "All projects for a user without projects comes back empty" do
    projects = Project.all_lighthouse(users(:aaron))
    assert_not_nil projects
    assert_equal [], projects
  end

  test "All projects for a user with projects does not come back empty" do
    projects = Project.all_lighthouse(users(:quentin))
    assert_not_equal [], projects
    assert_equal "JBidwatcher", projects.first.name
  end

  test "All projects for a user with projects that are not yet in the database does not come back empty" do
    # Initialize the variable
    projects = nil
    assert_difference('users(:joe).projects.count') do
      projects = Project.all_lighthouse(users(:joe))
    end
    assert_not_nil projects
    assert_not_equal [], projects
    assert_equal "JBidwatcher", projects.first.name
  end

  test "All projects for a user with an outdated project reloads & updates it" do
    projects = Project.all_lighthouse(users(:jim))
    assert_not_equal [], projects
    assert_equal "JBidwatcher", projects.first.name

    # This presumes the above takes <1 second, a reasonable presumption.
    project = users(:jim).projects.first
    assert project.updated_at > 1.second.ago
  end

  test "Finding a specific lighthouse project that hasn't been loaded yet retrieves it" do
    project = nil
    assert_difference('users(:joe).projects.count') do
      project = Project.find_by_lighthouse_project(users(:joe), 8037)
    end
    assert_not_nil project
    assert_equal "JBidwatcher", project.name
  end

  test "Finding a specific lighthouse project that is out of date retrieves the latest version" do
    project = Project.find_by_lighthouse_project(users(:jim), 8037)
    assert_not_nil project
    assert_equal "JBidwatcher", project.name
    assert users(:jim).projects.first.updated_at > 2.seconds.ago
  end

  test "Finding a specific lighthouse project for a user that has none should return nil" do
    project = Project.find_by_lighthouse_project(users(:aaron), 8037)
    assert_nil project
  end

  test "Finding a specific lighthouse project for a user with current projects shouldn't change anything" do
    project = nil
    assert_no_difference("users(:quentin).projects.count") do
      project = Project.find_by_lighthouse_project(users(:quentin), 8037)
    end
    assert_not_nil project
    assert_equal "JBidwatcher", project.name
    assert users(:quentin).projects.first.updated_at < 1.second.ago
  end
end
