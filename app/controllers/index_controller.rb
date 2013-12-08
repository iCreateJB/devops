class IndexController < ApplicationController
  before_filter :authenticate_user!

  def index
    clients  = Stripe::Customer.all.data
    @clients = Client.with_contact_by_user_and_customer_keys(current_user.id,clients.collect{|i| i['id']})
  end
  
end
