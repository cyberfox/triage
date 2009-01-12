class ProjectsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @projects = Project.all_lighthouse(current_user)
    @buckets = current_user.buckets
  end
end
