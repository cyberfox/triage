class ProjectsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @projects = Project.all_lighthouse(current_user)
    # Just pre-load the bins for all the projects.
    @projects.each(&:bins)
    @buckets = current_user.buckets
  end
end
