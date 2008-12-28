class BinsController < ApplicationController
  before_filter :login_required
  before_filter :get_token

  def index
    @project = Lighthouse::Project.find(params[:project_id])
    @bins = @project.bins
  end

  def choose
  end
end
