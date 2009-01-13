module Caching
  # This expects the including class to have:
  #   self#update_frequency
  #   self#create_from_lighthouse(project, original)
  #   self#retrieve(project, number)
  #   #update_from_lighthouse(project, original)
  module ClassMethods
    def optional_refresh(cached, project, number, original=nil)
      if cached
        if (cached.updated_at < update_frequency)
          original = retrieve(project, number) if original.nil?
          cached.update_from_lighthouse(original)
        else
          YAML.load(cached.data)
        end
      else
        original = retrieve(project, number) if original.nil?
        create_from_lighthouse(project, original)
      end
    end

    def init_lighthouse(project)
      Lighthouse.account = project.api_key.subdomain
      Lighthouse.token = project.api_key.token
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
