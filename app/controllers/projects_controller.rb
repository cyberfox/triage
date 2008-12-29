class ProjectsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @projects = Project.all(current_user)
  end
end
