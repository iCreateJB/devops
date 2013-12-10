require 'spec_helper'

describe ClientController do 
  it { should respond_to(:new) }
  it { should respond_to(:edit) }
  it { should respond_to(:create) }
  it { should respond_to(:update) }
  it { should respond_to(:show) }
  it { should respond_to(:destroy) }

  let(:client){ FactoryGirl.create(:client, :user => user) }
  let(:contact){ FactoryGirl.create(:contact, :client => client )}
  let(:project){ FactoryGirl.create(:project, :client => client) }
  let(:user){ FactoryGirl.create(:user) }

  let(:params){
    {
      :client_name => 'Test 1', 
      :first_name  => user.first_name,
      :last_name   => user.last_name,
      :email       => user.email,
      :phone       => '1234567890'
    }
  }

  before(:each) do 
    client
    user
    sign_in user
  end

  after do 
    DatabaseCleaner.clean
  end

  context "#new" do 
    it "should render #new" do 
      get :new
      response.should be_success
    end
  end

  context "#edit" do 
    it "should render #edit" do 
      get :edit, { :id => client.id }
      response.should be_success
      assigns(:client).should_not be_nil
    end
  end

  context "#create" do 
    before(:each) do 
      stripe = stub("Stripe::Customer", :id => '1_agfdh' )
      Stripe::Customer.should_receive(:create).and_return(stripe)
    end

    it "should #create" do 
      post :create, params
      response.should redirect_to dashboard_path
    end
  end

  context "#create with errors" do 
    it "should not #create ( Errors )" do 
      params.delete(:client_name)
      post :create, params
      response.should redirect_to new_client_path
    end    
  end

  context "#update" do
    before(:each) do 
      @stripe = stub("Stripe::Customer", :id => '1_agfdh' )   
      @stripe.stub(:email=).and_return()
      @stripe.stub(:description=).and_return()
      @stripe.stub(:metadata=).and_return()
      @stripe.stub(:save).and_return()  
    end

    it "should update client information" do 
      Stripe::Customer.should_receive(:retrieve).and_return(@stripe)
      put :update, :id => client.id,
        :client_name => 'Test 1.1', :first_name => user.first_name, :last_name => user.last_name, :email => user.email, :phone => '1234567890',
        :user_id => user.id, :client_id => client.id, :customer_key => client.customer_key
      response.should redirect_to dashboard_path
    end

    it "should not update client information ( error )" do 
      put :update, :id => client.id, :client_name => 'Test 1.1'
      response.should redirect_to edit_client_path      
    end
  end

  context "destroy" do 
    before(:each) do 
      @stripe = stub("Stripe::Customer", :id => '1_agfdh' )   
      @stripe.stub(:delete).and_return(true)    
    end

    it "should destroy the client" do 
      Stripe::Customer.should_receive(:retrieve).and_return(@stripe)        
      delete :destroy, :id => client.id, :customer_key => client.customer_key
      response.should redirect_to dashboard_path
    end

    it "should not destroy the client" do 
      delete :destroy, :id => client.id
      response.should redirect_to dashboard_path
    end
  end
end