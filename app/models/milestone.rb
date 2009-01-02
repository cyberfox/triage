class Milestone < ActiveRecord::Base
  include Caching

  belongs_to :project

  def self.find_by_project_and_milestone(project, milestone_number)
    cached = project.milestones.find_by_number(milestone_number)
    optonal_refresh(cached, project, milestone_number)
  end
end
