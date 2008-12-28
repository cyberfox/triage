class ProjectsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @projects = Lighthouse::Project.find(:all)
  end
end
