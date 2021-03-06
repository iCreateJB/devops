class ProjectController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def new
    @project = Project.new
  end

  def create 
    @project = Project.new(params.except(:controller, :action, :format))
    begin 
      if @project.valid?
        @project.save
        redirect_to dashboard_path
      else
        raise
      end
    rescue
      flash[:error] = @project.errors.full_messages
      redirect_to new_project_path
    end
  end
  
  def edit
    @project = Project.find(params[:project_id])
  end

  def update
    @project = Project.find(params[:id])
    begin
      if @project.update_attributes(params[:project])
        redirect_to dashboard_path
      else
        raise
      end
    rescue
      flash[:error] = @project.errors.full_messages
      redirect_to edit_project_path
    end
  end
end
