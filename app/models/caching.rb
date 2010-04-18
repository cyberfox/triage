module Caching
  # This expects the including class to have:
  #   self#update_frequency
  #   self#create_from_lighthouse(db_project, original)
  #   self#retrieve(db_project, number)
  #   #update_from_lighthouse(original)
  module ClassMethods
    def optional_refresh(db_object, db_project, number, klass, original=nil)
      if db_object
        if (db_object.updated_at < update_frequency)
          original = retrieve(db_project, number) if original.nil?
          db_object.update_from_lighthouse(original)
        else
          klass.new.from_xml(db_object.data)
        end
      else
        original = retrieve(db_project, number) if original.nil?
        create_from_lighthouse(db_project, original)
      end
    end

    def init_lighthouse(db_project)
      Lighthouse.account = db_project.user.subdomain
      Lighthouse.token = db_project.user.api_key
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
