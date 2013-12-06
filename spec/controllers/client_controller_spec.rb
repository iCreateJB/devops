require 'spec_helper'

describe ClientController do 
  it { should respond_to(:index) }
  it { should respond_to(:create) }
  it { should respond_to(:update) }
  it { should respond_to(:show) }

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
    user
    sign_in
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
end