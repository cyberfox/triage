# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  after_filter :store_current_project
  include AuthenticatedSystem
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8d50b5035747a247035fa0ce12ad03c3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  protected
  def current_project
    @project = Project.find_by_id(session[:project_id]) if session[:project_id]
    return @project
  end

  private
  def store_current_project
    session[:project_id] = @project ? @project.id : nil;
  end

  def get_token
    if logged_in?
      if current_project
        Lighthouse.account = current_project.api_key.subdomain
        Lighthouse.token = @token = current_project.api_key.token
      end
    end
  end
end
