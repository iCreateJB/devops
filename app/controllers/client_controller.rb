class ClientController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  end

  def new
    @client = Client.new
  end

  def create
  end

  def update
  end

  def show
  end
end