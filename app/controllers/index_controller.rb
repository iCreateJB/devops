class IndexController < ApplicationController

  def index
    @projects = Project.all
  end
  
end
