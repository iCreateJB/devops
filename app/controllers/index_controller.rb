class IndexController < ApplicationController
  before_filter :authenticate_user!

  def index
    clients  = Stripe::Customer.all.data
    @clients = Client.with_contact_by_customer_keys(clients.collect{|i| i['id']})
  end
  
end
