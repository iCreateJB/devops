require 'spec_helper'

describe InvoiceController do
  let(:client){ FactoryGirl.create(:client) }
  let(:project){ FactoryGirl.create(:project, :client => client) }
  let(:invoice){ FactoryGirl.create(:invoice, :client => client) }
  let(:contact){ FactoryGirl.create(:contact, :client => client) }
  let(:user){ FactoryGirl.create(:user) }

  before(:each) do 
    user.confirm!
    sign_in user
  end

  after do 
    DatabaseCleaner.clean
  end

  describe "Instance Methods" do 
    it { should respond_to(:new) }
    it { should respond_to(:edit) }
    it { should respond_to(:update) }
    it { should respond_to(:show) }
    it { should respond_to(:list) }
    it { should respond_to(:create) }
    it { should respond_to(:destroy) }
    it { should respond_to(:send_invoice) }
  end

  context "request" do 
    it "should respond to invoice edit" do 
      get :edit, :id => invoice.invoice_id
      assigns(:invoice).should_not be_nil
    end

    it "should respond to invoice" do 
      get :show, :invoice_key => invoice.invoice_key
      assigns(:invoice).should_not be_nil
    end   

    it "should repond to list" do 
      get :list, :client_id => client.id
      assigns(:invoices).should_not be_nil
    end   
  end

  context "New Invoice" do 
    let(:params){ 
      { 
        :client_id => client.id, 
        :invoice => {
          "0" => { :title => 'DB Column Update', :description => 'Add in these columns', :amount => "75.00" },
          "1" => { :title => 'Save Twitter followers', :description => 'Save all new followers from this point', :amount => '150.00'}
        }
      }
    }

    it "should create a new invoice with the following items" do 
      post :create, params
      assigns(:invoice).should_not be_nil
    end

  end

  context "Send Invoice" do 
    let(:params){ 
      { 
        :invoice_key => invoice.invoice_key, 
        :contact_id  => contact.id
      }
    }

    it "should attempt to send an invoice" do 
      post :send_invoice, params
      assigns(:invoice).should_not be_nil
      assigns(:contact).should_not be_nil
    end
  end
end
