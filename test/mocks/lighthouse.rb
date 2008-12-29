require 'yaml'
require 'ostruct'

OpenStruct.class_eval do
  undef :id, :type
  def bins
    @@bins = Lighthouse.from_yaml(:bins)
  end
end

module Lighthouse
  mattr_accessor :token, :account

  def self.from_yaml(details)
    rval = YAML.load(open("#{Rails.root}/test/fixtures/yaml/#{details.to_s}.yml"))
    if rval.is_a? Array
      rval = rval.collect { |x| OpenStruct.new(x) }
    end
  end

  class User
    def self.find(condition)
      OpenStruct.new(:name => 'Morgan Schweers')
    end
  end

  class Ticket
    def self.find(condition, params)
      @@tickets ||= Lighthouse.from_yaml(:tickets)
      case condition
        when :all: return @@tickets
      else
        ticket = @@tickets.find { |ticket| ticket.number.to_s == condition.to_s }
        if ticket
          def ticket.versions
            @@versions ||= Lighthouse.from_yaml(:ticket_254)
          end if ticket.number.to_s == '254'
        end
        ticket
      end
    end
  end

  class Project
    def self.init
      throw Exception.new('Account is not set!') if Lighthouse::account.nil?
      throw Exception.new('Token is not set!') if Lighthouse::token.nil?
      @@projects ||= Lighthouse.from_yaml(:projects)
    end

    def self.find(condition)
      init
      case condition
      when :all:
          return [] if Lighthouse.account == 'empty'
          return @@projects
      else
        return nil if Lighthouse.account == 'empty'
        project = @@projects.find { |project| project.id.to_s == condition.to_s }
      end
    end
  end
end
