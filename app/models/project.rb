class Project < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  belongs_to :user
  has_many :tickets
  has_many :milestones

  def lighthouse
    YAML.load(data)
  end
  memoize :lighthouse

  def bins
    lighthouse.bins
  end
  memoize :bins

  def states
    @states ||= "#{lighthouse.open_states_list},#{lighthouse.closed_states_list}".split(',')
  end

  def self.update_frequency
    7.days.ago
  end

  def self.init_lighthouse(user)
    Lighthouse.account = user.subdomain
    Lighthouse.token = user.api_key
  end

  def self.all_lighthouse(user)
    projects = user.projects.find(:all)
    if projects.blank?
      init_lighthouse(user)
      real = Lighthouse::Project.find(:all)
      real.each do |project|
        user.projects.create(:lighthouse_id => project.id,
                       :name => project.name,
                       :data => project.to_yaml)
      end
    else
      first = true
      real = projects.collect do |project|
        if project.updated_at < update_frequency
          if first
            init_lighthouse(user)
            first = false
          end
          actual = Lighthouse::Project.find(project.lighthouse_id)
          project.data = actual.to_yaml
          project.updated_at = Time.now
          project.save
          actual
        else
          YAML.load(project.data)
        end
      end
    end
    real
  end

  def self.find_by_lighthouse_project(user, project_number)
    project = find_by_user_id_and_lighthouse_id(user.id, project_number)
    if project.blank? || project.updated_at < update_frequency
      init_lighthouse(user)
      real = Lighthouse::Project.find(project_number)
      if real
        if project.blank?
          user.projects.create(:lighthouse_id => real.id,
                               :name => real.name,
                               :data => real.to_yaml)
        else
          project.data = real.to_yaml
          project.updated_at = Time.now
          project.save
        end
      end
      real
    else
      real = YAML.load(project.data)
    end
  end
end
