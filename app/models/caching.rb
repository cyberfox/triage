module Caching
  module ClassMethods
    def optional_refresh(cached, project, number)
      if cached
        if (cached.updated_at < update_frequency)
          cached.refresh
        else
          YAML.load(cached.data)
        end
      else
        create_from_lighthouse(project, number)
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
