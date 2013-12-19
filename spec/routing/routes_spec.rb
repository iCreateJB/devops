require 'spec_helper'

describe "Routes" do 
  it "GET => '/dashboard'" do 
    { :get => '/dashboard' }.should route_to( :controller => 'index', :action => 'index' )
  end

  it "GET => '/about'" do 
    { :get => '/about' }.should route_to( :controller => 'about', :action => 'index' )
  end

  it "GET => '/p/1'" do 
    { :get => '/p/1'}.should route_to( :controller => 'project', :action => 'edit', :project_id => "1")
  end

  # Developer adding/editing an invoice from within the app
  it "GET => '/invoice/1abdafjd/edit'" do 
    { :get => '/invoice/1abdafjd/edit'}.should route_to( :controller => 'invoice', :action => 'edit', :id => "1abdafjd")
  end

  # Client viewing an invoice wishing to pay. 
  it "GET => '/i/1abdafjd'" do 
    { :get => '/i/1abdafjd'}.should route_to( :controller => 'invoice', :action => 'show', :invoice_key => '1abdafjd')
  end

  it "PUT => '/project/1'" do
    { :put => '/project/1' }.should route_to( :controller => 'project', :action => 'update', :id => '1')
  end

  it "POST => '/invoice" do 
    { :post => '/invoice' }.should route_to( :controller => 'invoice', :action => 'create' )
  end

  it "POST => '/s/1abdafjd'" do 
    { :post => '/s/1abdafjd' }.should route_to( :controller => 'invoice', :action => 'send_invoice', :invoice_key => '1abdafjd')
  end
end