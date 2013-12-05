class IndexController < ApplicationController
  before_filter :authenticate_user!

  def index
    @projects = Project.by_user(current_user.id)
  end
  
end
