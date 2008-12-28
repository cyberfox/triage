class TicketsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @project = Lighthouse::Project.find(params[:project_id])
    bin = Lighthouse::Project.find(8037).bins.find {|bin| bin.id == 5933}
    @bin = @project.bins.find {|bin| bin.id.to_s == params[:bin_id].to_s}
    @tickets = Lighthouse::Ticket.find(:all, :params => { :project_id => @project.id, :q => @bin.query })
  end

  def show
    @project = Lighthouse::Project.find(params[:project_id])
    @ticket = Lighthouse::Ticket.find(params[:ticket_id], :params => { :project_id => @project.id})
    @title = @ticket.title
    @users = @ticket.versions.collect(&:user_id).uniq
    @user_map = @users.inject({}) {|accum, user_id| accum[user_id] = Lighthouse::User.find(user_id); accum}
  end

  def triage
  end

end
