# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  after_filter :store_current_project
  helper :all # include all helpers, all the time
  helper_method :current_project
  before_filter :prepare_title_information

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '8d50b5035747a247035fa0ce12ad03c3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  def current_project
    @session_project = Project.find_by_id(session[:project_id]) if session[:project_id]
    return @session_project
  end

  def store_current_project
    session[:project_id] = @session_project ? @session_project.id : nil;
  end

  private
  def get_token
    if logged_in?
      Lighthouse.account = current_user.subdomain
      Lighthouse.token = @token = current_user.api_key
    end
  end

  protected
  def prep_bucket_form
    @bucket = Bucket.new unless @bucket
    project = current_user.projects.first
    @milestones = project.milestones
    @states = project.states
  end

  def prepare_title_information
    @title_controller = controller.singular_class_name(controller).gsub('_controller', '').captialize
    @title_optional_action = controller.action_name if controller.action_name != 'index'
    @title_optional_action, @title_controller = [nil, 'Sign In'] if @title_controller == 'Sessions' && @title_optional_action == 'new'
  end
end
