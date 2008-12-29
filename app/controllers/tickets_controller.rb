class TicketsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @bin = @project.bins.find {|bin| bin.id.to_s == params[:bin_id].to_s}
    @tickets = Lighthouse::Ticket.find(:all, :params => { :project_id => @project.id, :q => @bin.query })
  end

  def show
    @project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @ticket = Lighthouse::Ticket.find(params[:ticket_id], :params => { :project_id => @project.id})
    @title = @ticket.title
    @users = @ticket.versions.collect(&:user_id).uniq
    @user_map = @users.inject({}) {|accum, user_id| accum[user_id] = Lighthouse::User.find(user_id); accum}
  end
end
