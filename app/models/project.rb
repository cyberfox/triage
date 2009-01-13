class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :api_key
  has_many :tickets
  has_many :milestones

  def states
    @states ||= begin
                  ydata = YAML.load(data)
                  "#{ydata.open_states_list},#{ydata.closed_states_list}".split(',')
                end
  end

  def self.update_frequency
    7.days.ago
  end

  def self.all_lighthouse(user)
    projects = user.projects.find(:all)
    if projects.blank?
      keys = user.api_keys
      accum = []
      keys.each do |key|
        real = key.lighthouse.Project.find(:all)
        accum = accum + real
        real.each do |project|
          user.projects.create(:lighthouse_id => project.id,
                               :name => project.name,
                               :data => project.to_yaml,
                               :api_key => key)
        end
      end
      real = accum
    else
      first = true
      real = projects.collect do |project|
        if project.updated_at < update_frequency
          actual = project.api_key.lighthouse.Project.find(project.lighthouse_id)
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
    real = nil
    if project.blank? || project.updated_at < update_frequency
      if project.blank?
        user.api_keys.each do |key|
          begin
            real ||= key.lighthouse.Project.find(project_number)
          rescue ActiveResource::ResourceNotFound => rnf
            real = nil
          end
        end
      else
        real = project.api_key.lighthouse.Project.find(project_number)
      end

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
