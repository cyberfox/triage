class Milestone < ActiveRecord::Base
  include Caching

  belongs_to :project

  def self.find_by_project_and_milestone(project, milestone_number, original=nil)
    cached = project.milestones.find_by_lighthouse_id(milestone_number)
    cached.updated_at = Time.at(0) if cached && original && original.updated_at > cached.updated_at
    optional_refresh(cached, project, milestone_number, original)
  end

  def self.all_lighthouse(project)
    init_lighthouse(project)
    milestones = Lighthouse::Milestone.find(:all, :params => { :project_id => project.lighthouse_id })
    milestones.each { |milestone| find_by_project_and_milestone(project, milestone.id, milestone) }
    return milestones
  end

  def update_from_lighthouse(original)
    update_attributes(:title => original.title,
                      :data => original.to_yaml)
    return original
  end

  private
  def self.create_from_lighthouse(project, original)
    project.milestones.create(:title => original.title,
                              :lighthouse_id => original.id,
                              :data => original.to_yaml)
    return original
  end

  def self.update_frequency
    1.day.ago
  end

  def self.retrieve(project, milestone_number)
    init_lighthouse(project)
    Lighthouse::Milestone.find(milestone_number, :params => { :project_id => project.lighthouse_id })
  end
end
