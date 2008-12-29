class BinsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @project = Project.find_by_lighthouse_project(current_user, params[:project_id])
    @bins = @project.bins
  end
end
