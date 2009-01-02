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

  def self.require_account
    throw Exception.new('Account is not set!') if Lighthouse::account.nil?
  end

  def self.require_token
    throw Exception.new('Token is not set!') if Lighthouse::token.nil?
  end

  def self.from_yaml(details)
    body = open("#{Rails.root}/test/fixtures/yaml/#{details.to_s}.yml").read
    body = ERB.new(body).result
    rval = YAML.load(body)
    rval = rval.collect { |x| x.instance_of?(OpenStruct) ? x : OpenStruct.new(x) } if rval.is_a? Array
    return rval
  end

  class Milestone
    def self.find(condition, params)
      Lighthouse.require_account
      Lighthouse.require_token
      case(condition)
      when 7468: Lighthouse.from_yaml(:milestone_full)
      when 7919: Lighthouse.from_yaml(:milestone_beta)
      when :all: Lighthouse.from_yaml(:milestones)
      end
    end
  end

  class User
    def self.find(condition)
      Lighthouse.require_account
      if(condition != 2989)
        OpenStruct.new(:name => 'Morgan Schweers', :website => 'www.jbidwatcher.com', :job => 'Primary Developer')
      else
        nil
      end
    end
  end

  class Ticket
    def self.find(condition, params)
      Lighthouse.require_account
      Lighthouse.require_token

      @@tickets ||= Lighthouse.from_yaml(:tickets)
      case condition
        when :all: return @@tickets
      else
        ticket = @@tickets.find { |ticket| ticket.number.to_s == condition.to_s }
        ticket = Lighthouse.from_yaml(:raw_ticket) if ticket.number.to_s == '254'
        ticket
      end
    end
  end

  class Project
    def self.init
      Lighthouse.require_account
      Lighthouse.require_token
      @@projects ||= Lighthouse.from_yaml(:projects)
    end

    def self.find(condition)
      init
      case condition
      when :all:
          if Lighthouse.account == 'empty'
            return []
          else
            return @@projects
          end
      else
        return nil if Lighthouse.account == 'empty'
        project = @@projects.find { |project| project.id.to_s == condition.to_s }
      end
    end
  end
end
