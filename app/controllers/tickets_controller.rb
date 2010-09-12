require 'ostruct'

class TicketsController < ApplicationController
  before_filter :login_required
  before_filter :get_token
  before_filter :set_project

  def fun
    @action = params[:id]
    unless ['all', 'new', 'open'].include?(@action)
      redirect_to :index
      return
    end

    prep_bucket_form

    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @bin = nil

    tickets = []
    case(@action)
      when 'all' then tickets = Ticket.all
      when 'new' then tickets = Ticket.where(:state => 'new')
      when 'open' then tickets = Ticket.where(:state => 'open')
    end

    @lh_tickets = tickets.includes(:project).order(:number).collect(&:pure_lighthouse)
    @search_query = @action
    @ticket_count = @lh_tickets.length

    session[:tickets] = @lh_tickets.collect(&:number)
    session[:ticket_index] = 0

    render 'index'
  end

  def all
    prep_bucket_form

    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @bin = nil
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)
    @lh_tickets = db_project.tickets.includes(:project).order(:number).collect(&:pure_lighthouse)
    @search_query = 'all'
    @ticket_count = @lh_tickets.length

    render 'index'
  end

  # Output to the template:
  #   @lh_project - Current project (lighthouse)
  #   @bin - Current bin (lighthouse)
  #   @search_query = Current query (string)
  #   @lh_tickets = List of tickets (lighthouse)
  #   @ticket_count = The count of tickets in the bin (if there is one),
  #     or in this set of tickets if we're not viewing a bin.

  def index
    page = params[:page] || 1
    page = page.to_i unless page == 1
    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)
    @bin = @lh_project.bins.find {|bin| bin.id.to_s == params[:bin_id].to_s}
    if @bin
      @search_query = @bin.query
      @lh_tickets = Ticket.search(db_project, @bin.query, page)
    else
      @search_query = session[:ticket_search]
      @lh_tickets = Ticket.search(db_project, @search_query) if @search_query
    end
    if @lh_tickets.blank? && !request.xhr?
      flash[:error] = "No tickets found for '#{h @search_query}'"
      redirect_to :controller => 'projects', :action => 'index'
    else
      if @search_query.include?('sort:number') || !@search_query.include?('sort:')
        @lh_tickets.sort! {|x, y| x.number <=> y.number}
      end
      prep_bucket_form
      session[:bin_id] = params[:bin_id]
      if request.xhr?
        session[:tickets] += @lh_tickets.collect(&:number)
      else
        session[:tickets] = @lh_tickets.collect(&:number)
        session[:ticket_index] = 0
      end
      session[:ticket_search] = @search_query
    end
    if @bin
      @ticket_count = @bin.tickets_count
    else
      @ticket_count = @lh_tickets.length
    end
    if page != 1 && request.xhr?
      @page = page
      render :partial => 'later_ticket_pages', :locals => { :tickets => @lh_tickets, :project => @lh_project }
    end
  end

  def refresh
    lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(lh_project.id)
    db_ticket = db_project.tickets.find_by_number(params[:id])
    db_ticket.update_from_lighthouse(Ticket.retrieve(db_project, db_ticket.number))
    redirect_to :action => 'show', :project_id => params[:project_id], :id => db_ticket.number
  end

  def show
    if params[:id].blank?
      flash[:error] = "Ticket to view is blank"
      redirect_to :action => 'index', :project_id => params[:project_id]
      return
    end
    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)
    db_ticket = db_project.tickets.find_by_number(params[:id])
    if db_ticket.nil?
      flash[:error] = "Ticket #{h params[:id]} is missing"
      redirect_to :action => 'index', :project_id => params[:project_id]
      return
    end
    @lh_ticket = db_ticket.lighthouse
    session[:ticket_index] = session[:tickets].index(@lh_ticket.number) if session[:tickets]
    session[:ticket_number] = @lh_ticket.number

    users = (@lh_ticket.versions.collect {|x| x.respond_to?(:user_id) ? x.user_id : x['user_id']} +
             @lh_ticket.versions.collect {|x| x.respond_to?(:assigned_user_id) ? x.assigned_user_id : x['assigned_user_id']}).uniq
    @user_map = users.inject({}) {|accum, user_id| accum[user_id] = LighthouseUser.get(user_id); accum}
    prep_bucket_form
  end

  def apply
    @db_project = current_user.projects.find_by_lighthouse_id(params[:project_id])
    @bucket = current_user.buckets.find_by_id(params[:bucket_id])
    @ticket = @db_project.tickets.find_by_number(params[:ticket_number])
    @bucket.apply_one(@ticket)
    @ticket.update_from_lighthouse(Ticket.retrieve(@db_project, @ticket.number))
    flash[:notice] = "Applied '#{@bucket.tag}' to '#{@ticket.title}' (ticket ##{@ticket.number})."
    self.next if session[:ticket_index]
    redirect_to(:action => 'show', :project_id => params[:project_id], :id => params[:ticket_number]) unless session[:ticket_index]
  end

  # Pull the current search from the session, get the next entry, and show it.
  def next
    if session[:ticket_index]
      next_ticket_idx = session[:ticket_index].to_i + 1
      if next_ticket_idx > session[:tickets].length
        # TODO -- Retrieve next 30 tickets?
        # TODO -- Return to index if past the actual end of tickets.
      end
      session[:ticket_index] = next_ticket_idx
      next_ticket_number = session[:tickets][next_ticket_idx]
      redirect_to :action => 'show', :project_id => params[:project_id], :id => next_ticket_number
    else
      index_action = { :action => 'index', :project_id => params[:project_id] }
      index_action.merge!(:bin_id => session[:bin_id]) if session[:bin_id]
      redirect_to index_action
    end
  end

  def search
    @lh_project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    db_project = current_user.projects.find_by_lighthouse_id(@lh_project.id)

    @lh_tickets = Ticket.search(db_project, params[:q])
    session[:tickets] = @lh_tickets.collect(&:number)
    session[:ticket_index] = 0
    session[:ticket_search] = params[:q]
    @query = params[:q]
    @result = OpenStruct.new(:tickets_count => "At least #{@lh_tickets.length}")
    prep_bucket_form
  end

  private
  def set_project
    session[:project_id] = current_project.id if current_project
  end

  protected
    include ERB::Util
end
