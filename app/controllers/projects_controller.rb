class ProjectsController < ApplicationController
  before_filter :get_token

  def index
    @projects = Lighthouse::Project.find(:all)
  end

  def choose
    @project = Lighthouse::Project.find(params[:id])
  end

  def refresh
  end

  private
  def get_token
    Lighthouse.token = @token = ''
  end
end
