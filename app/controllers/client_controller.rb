class ClientController < ApplicationController
  before_filter :authenticate_user!

  def new
    @client       = Client.new
    @current_user = current_user
  end

  def edit
    @client       = Client.with_contact_info_by_user_and_client_id(current_user.id,params[:id]).first
  end

  def create
    @client = ClientService.new(params)
    begin 
      if @client.valid?
        @client.save
        redirect_to dashboard_path
      else
        raise
      end      
    rescue
      flash[:error] = @client.errors.full_messages
      redirect_to new_client_path
    end
  end

  def update
    @client = ClientService.update(params)
    begin 
      if @client.valid?
        @client.save
        redirect_to dashboard_path
      else
        raise
      end
    rescue
      flash[:error] = @client.errors.full_messages
      redirect_to edit_client_path      
    end
  end

  def show
  end
end