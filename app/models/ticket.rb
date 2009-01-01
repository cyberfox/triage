class Ticket < ActiveRecord::Base
  belongs_to :project

  def self.search(project, query, page=1)
    tickets = query(project, query, page)
    tickets.collect do |ticket|
      find_by_project_and_ticket(project, ticket.number, ticket.updated_at)
    end
  end

  def self.find_by_project_and_ticket(project, ticket_number, latest_update = nil)
    cached = project.tickets.find_by_number(ticket_number)
    if cached
      if  (latest_update && latest_update > cached.updated_at) ||
          (cached.updated_at < update_frequency)
        cached.refresh
      else
        YAML.load(cached.data)
      end
    else
      create_from_lighthouse(project, ticket_number)
    end
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
      puts "#{all_tickets.length}, #{count}, #{last}"
    end

    length = all_tickets.length
    mod = length / 10
    all_tickets.each do |ticket|
      ticket = find_by_project_and_ticket(project, ticket.number, ticket.updated_at)
      puts "#{ticket.number}: #{ticket.title}" if (ticket.number % mod) == 0
    end
  end

  def refresh
    ticket = Ticket.retrieve(project, number)

    # Assumption: Ticket numbers don't change.
    update_attributes(:title => ticket.title, :data => ticket.to_yaml)
    return ticket
  end

  private
  def self.update_frequency
    1.day.ago
  end

  def self.create_from_lighthouse(project, ticket_number)
    ticket = retrieve(project, ticket_number)
    project.tickets.create(:number => ticket.number,
                           :title => ticket.title,
                           :data => ticket.to_yaml)
    return ticket
  end

  def self.init_lighthouse(project)
    Lighthouse.account = project.user.subdomain
    Lighthouse.token = project.user.api_key
  end

  def self.query(project, q, page)
    init_lighthouse(project)
    Lighthouse::Ticket.find(:all, :params => { :project_id => project.lighthouse_id, :page => page, :q => q })
  end

  def self.retrieve(project, ticket_number)
    init_lighthouse(project)
    Lighthouse::Ticket.find(ticket_number, :params => { :project_id => project.lighthouse_id })
  end
end