class ProjectController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def new
    @project = Project.new
  end

  def create 
    begin 
    rescue
    end
  end
  
  def edit
    @project = Project.find(params[:project_id])
  end

  def update
    @project = Project.find(params[:id])
    begin
      @project.update_attributes(params[:project])
    rescue => e
      Rails.logger.error "[ERROR] #{Time.now} : #{e}"
    end
    redirect_to :dashboard
  end
end
