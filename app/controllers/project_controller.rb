class ProjectController < ApplicationController
  before_filter :authenticate_user!

  def index
    
  end
  
  def edit
    @project = Project.find(params[:project_id])
  end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes(params[:project])
    redirect_to :dashboard
  end
end
