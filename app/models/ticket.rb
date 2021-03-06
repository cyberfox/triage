require 'nokogiri'

class XMLProxy
  def initialize(xml)
    @underlying = Nokogiri::XML.parse(xml)
    @root = @underlying.root.name
  end

  def method_missing(method, *args, &block)
    begin
      if (@underlying % "//#{@root}/#{method.to_s.dasherize}") == nil
        super
      else
        (@underlying % "//#{@root}/#{method.to_s.dasherize}").text
      end
    end
  rescue => e
    puts e
    super
  end
end

class Ticket < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  include Caching

  belongs_to :project

  def self.search(project, query, page=1)
    tickets = query(project, query, page)

    # This is optimized from what came before, because what came before was very slow.
    ticket_numbers = []
    ticket_map = {}
    tickets.each do |ticket|
      ticket_numbers << ticket.number
      ticket_map[ticket.number.to_i] = ticket
    end
    db_tickets = project.tickets.find_all_by_number(ticket_numbers)
    results = db_tickets.collect do |ticket|
      updated_at = (ticket_map.delete ticket.number).updated_at
      choose_refresh(ticket, project, ticket.number, updated_at)
    end

    unless ticket_map.empty?
      ticket_map.values.collect do |ticket|
        results << choose_refresh(nil, project, ticket.number, ticket.updated_at)
      end
    end

#    results.sort {|x, y| x.number <=> y.number}
    results
  end

#    tickets.collect do |ticket|
#      find_by_project_and_ticket(project, ticket.number, ticket.updated_at)
#    end

 # Takes an ActiveRecord Project, a number, and an optional latest_update date.
  def self.find_by_project_and_ticket(project, ticket_number, latest_update = nil)
    cached = project.tickets.find_by_number(ticket_number)
    choose_refresh(cached, project, ticket_number, latest_update)
  end

  def self.choose_refresh(cached, project, ticket_number, latest_update = nil)
    cached.updated_at = Time.at(0) if cached && latest_update && latest_update > cached.updated_at
    optional_refresh(cached, project, ticket_number, Lighthouse::Ticket)
  end

  # This takes a long time; it first loads the search-level ticket information
  # then for each ticket, it loads the detailed information.
  # TODO -- It should look the ticket up in the database first, and only update if it needs to.
  #
  # In any case, it shouldn't be run inline with a web request.
  def self.import_all(project)
    page = 1
    count = last = nil
    all_tickets = []
    while count.nil? || count == last
      count = last
      ticket_set = query(project, 'sort:number', page)
      last = ticket_set.length
      all_tickets += ticket_set
      page += 1
      puts "Imported #{all_tickets.length} so far."
    end

    length = all_tickets.length
    mod = length / 10
    all_tickets.each do |ticket|
      ticket = find_by_project_and_ticket(project, ticket.number, ticket.updated_at)
    end
  end

  def update_from_lighthouse(ticket)
    # Assumption: Project & Ticket numbers don't change.
    update_attributes(:title => ticket.title, :data => ticket.to_xml)
    return ticket
  end

  def pure_lighthouse
    Lighthouse::Ticket.new.from_xml(data)
  end

  def lighthouse(latest_update = nil)
    updated_at = Time.at(0) if updated_at.nil? && !latest_update.nil?
    updated_at = Time.at(0) if latest_update && latest_update > updated_at
    Ticket.optional_refresh(self, project, number, Lighthouse::Ticket)
  end

  def info
    XMLProxy.new(data)
  end
  memoize :info

  private
  def self.update_frequency
    1.day.ago
  end

  def self.create_from_lighthouse(db_project, ticket)
    db_project.tickets.create(:number => ticket.number,
                              :title => ticket.title,
                              :data => ticket.to_xml)
    return ticket
  end

  def self.query(db_project, q, page)
    init_lighthouse(db_project)
    Lighthouse::Ticket.all(:params => { :project_id => db_project.lighthouse_id, :page => page, :q => q })
  end

  def self.retrieve(db_project, ticket_number)
    init_lighthouse(db_project)
    Lighthouse::Ticket.find(ticket_number, :params => { :project_id => db_project.lighthouse_id })
  end
end
