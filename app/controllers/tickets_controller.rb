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
  end

  def search
    @project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @cached_project = Project.find_by_lighthouse_id(@project.id)
    @tickets = Ticket.search(@cached_project, params[:q])
    @query = params[:q]
    @result = OpenStruct.new(:tickets_count => "At least #{@tickets.length}")
  end
end
