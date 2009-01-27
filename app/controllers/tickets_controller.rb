require 'ostruct'

class TicketsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)
    @bin = @lh_project.bins.find {|bin| bin.id.to_s == params[:bin_id].to_s}
    @lh_tickets = Ticket.search(db_project, @bin.query)
  end

  def show
    lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(lh_project.id)
    @lh_ticket = db_project.tickets.find_by_number(params[:id]).lighthouse

    users = (@lh_ticket.versions.collect(&:user_id) +
             @lh_ticket.versions.collect(&:assigned_user_id)).uniq
    @user_map = users.inject({}) {|accum, user_id| accum[user_id] = LighthouseUser.get(user_id); accum}
    prep_bucket_form
  end

  def apply
    @db_project = current_user.projects.find_by_lighthouse_id(params[:project_id])
    @bucket = current_user.buckets.find_by_id(params[:bucket_id])
    @bucket.boilerplate = "Zarf is with you again."
    @ticket = @db_project.tickets.find_by_number(params[:ticket_number])
    @bucket.apply_one(@ticket)
    # Pull the current search from the session, and get the next entry, and show it.
  end

  def next
    # Pull the current search from the session, get the next entry, and show it.
  end

  def search
    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)

    @lh_tickets = Ticket.search(db_project, params[:q])
    @query = params[:q]
    @result = OpenStruct.new(:tickets_count => "At least #{@lh_tickets.length}")
  end
end
