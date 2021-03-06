require Rails.root.join('lib/authenticated_system.rb').to_s

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
  protect_from_forgery

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  def current_project
    @session_project ||= Project.find_by_id(session[:project_id]) if session[:project_id]
    @session_project ||= Project.find_by_lighthouse_id(params[:project_id]) if params[:project_id]
    @session_project
  end

  def store_current_project
    session[:project_id] = @session_project ? @session_project.id : nil;
  end

  protected
  def get_token
    if logged_in?
      Lighthouse.account = current_user.subdomain
      Lighthouse.token = @token = current_user.api_key
    end
  end

  def prep_bucket_form
    @bucket = Bucket.new unless @bucket
    project = current_user.projects.first
    @milestones = project.milestones
    @states = project.states
  end

  def prepare_title_information
    singularizer = defined?(ActiveModel::Naming.singular) ? ActiveModel::Naming.method(:singular) : ActionController::RecordIdentifier.method(:singular_class_name)
    logger.warn     

    @title_controller = self.class.to_s.gsub('Controller', '').singularize.capitalize
    @title_optional_action = self.action_name if self.action_name != 'index'
    @title_optional_action, @title_controller = [nil, 'Sign In'] if @title_controller == 'Sessions' && @title_optional_action == 'new'
    @title_optional_action, @title_controller = [nil, 'Sign Up'] if @title_controller == 'Users' && @title_optional_action == 'new'
  end
end
