require 'spec_helper'

describe InvoiceController do
  let(:client){ FactoryGirl.create(:client) }
  let(:project){ FactoryGirl.create(:project, :client => client) }
  let(:invoice){ FactoryGirl.create(:invoice, :project => project)}
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
    it { should respond_to(:edit) }
    it { should respond_to(:show) }
    it { should respond_to(:create) }
    it { should respond_to(:send_invoice) }
  end

  context "request" do 
    it "should respond to invoice edit" do 
      get :edit, :invoice_key => invoice.invoice_key
      assigns(:invoice).should_not be_nil
    end

    it "should respond to invoice" do 
      get :show, :invoice_key => invoice.invoice_key
      assigns(:invoice).should_not be_nil
    end      
  end

  context "New Invoice" do 
    let(:params){ 
      { 
        :client_id => client.id, 
        :project_id => project.id, 
        :items => [
          { :title => 'DB Column Update', :description => 'Add in these columns', :amount => "75.00" },
          { :title => 'Save Twitter followers', :description => 'Save all new followers from this point', :amount => '150.00'}
        ]
      }
    }

    it "should create a new invoice with the following items" do 
      post :create, params
      assigns(:invoice).should_not be_nil
    end

    it "should not create a new invoice" do 
      params.delete(:items)
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
