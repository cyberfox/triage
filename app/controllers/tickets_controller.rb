require 'ostruct'
require 'rdiscount'

class TicketsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)
    @bin = @lh_project.bins.find {|bin| bin.id.to_s == params[:bin_id].to_s}
    @lh_tickets = Ticket.search(db_project, @bin.query)
    prep_bucket_form
    session[:tickets] = @lh_tickets.collect(&:number)
    session[:ticket_index] = 0
    session[:ticket_search] = @bin.query
  end

  def show
    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)
    @lh_ticket = db_project.tickets.find_by_number(params[:id]).lighthouse
    session[:ticket_index] = session[:tickets].index(@lh_ticket.number) if session[:tickets]
    session[:ticket_number] = @lh_ticket.number

    users = (@lh_ticket.versions.collect(&:user_id) +
             @lh_ticket.versions.collect(&:assigned_user_id)).uniq
    @user_map = users.inject({}) {|accum, user_id| accum[user_id] = LighthouseUser.get(user_id); accum}
    prep_bucket_form
  end

  def apply
    @db_project = current_user.projects.find_by_lighthouse_id(params[:project_id])
    @bucket = current_user.buckets.find_by_id(params[:bucket_id])
    @ticket = @db_project.tickets.find_by_number(params[:ticket_number])
    @bucket.apply_one(@ticket)
    @ticket.lighthouse(Time.now)
    # Pull the current search from the session, and get the next entry, and show it.
  end

  # Pull the current search from the session, get the next entry, and show it.
  def next
    if session[:ticket_index]
      next_ticket_idx = session[:ticket_index].to_i + 1
      if next_ticket_idx > session[:tickets].length
        # TODO -- Retrieve next 30 tickets?
      end
      next_ticket_number = session[:tickets][next_ticket_idx]
      redirect_to :action => 'show', :project_id => params[:project_id], :id => next_ticket_number
    end
  end

  def search
    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)

    @lh_tickets = Ticket.search(db_project, params[:q])
    session[:search] = @lh_tickets
    @query = params[:q]
    @result = OpenStruct.new(:tickets_count => "At least #{@lh_tickets.length}")
    prep_bucket_form
  end
end
