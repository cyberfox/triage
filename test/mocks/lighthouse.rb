require 'yaml'
require 'ostruct'

OpenStruct.class_eval { undef :id, :type }

module Lighthouse
  def self.token
    @@token
  end

  def self.token=(x)
    @@token = x
  end

  class Project
    def self.from_yaml(details)
      rval = YAML.load(open("#{Rails.root}/test/fixtures/yaml/#{details.to_s}.yml"))
      if rval.is_a? Array
        rval = rval.collect { |x| OpenStruct.new(x) }
      end
    end

    def self.init
      throw Exception.new('Token is not set!') if Lighthouse::token.nil?
      @@projects ||= from_yaml(:projects)
    end

    def self.find(condition)
      init
      case condition
      when :all: return @@projects
      else
        @@projects.find { |project| project.id.to_s == condition.to_s }
      end
    end
  end
end
