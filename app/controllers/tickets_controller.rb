require 'ostruct'

class TicketsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @bin = @project.bins.find {|bin| bin.id.to_s == params[:bin_id].to_s}
    @cached_project = Project.find_by_lighthouse_id(@project.id)
    @tickets = Ticket.search(@cached_project, @bin.query)
  end

  def show
    @project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @cached_project = Project.find_by_lighthouse_id(@project.id)
    @ticket = Ticket.find_by_project_and_ticket(@cached_project, params[:id])
    @title = @ticket.title
    @users = @ticket.versions.collect(&:user_id).uniq
    @user_map = @users.inject({}) {|accum, user_id| accum[user_id] = LighthouseUser.get(user_id); accum}
    @buckets = current_user.buckets
    prep_bucket_form
  end

  def apply
    @project = current_user.projects.find_by_lighthouse_id(params[:project_id])
    @bucket = current_user.buckets.find_by_id(params[:bucket_id])
    @bucket.boilerplate = "Zarf is with you again."
    @ticket = @project.tickets.find_by_number(params[:ticket_number])
    @bucket.apply_one(@ticket)
    # Pull the current search from the session, and get the next entry, and show it.
  end

  def next
    # Pull the current search from the session, get the next entry, and show it.
  end

  def search
    @project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @cached_project = Project.find_by_lighthouse_id(@project.id)
    @tickets = Ticket.search(@cached_project, params[:q])
    @query = params[:q]
    @result = OpenStruct.new(:tickets_count => "At least #{@tickets.length}")
  end
end
