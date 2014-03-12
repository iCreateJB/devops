require 'spec_helper'

describe IndexController do
  let(:client){ FactoryGirl.create(:client, :customer_key => 'cus_12345') }
  let(:project){ FactoryGirl.create(:project, :client => client) }
  let(:invoice){ FactoryGirl.create(:invoice, :project => project)}
  let(:user){ FactoryGirl.create(:user) }
  let(:contact){ FactoryGirl.create(:contact, :client => client )}

  before(:each) do
    contact
    user.confirm!
    sign_in user
  end

  after do
    DatabaseCleaner.clean
  end

  describe "Instance Methods" do
    it { should respond_to(:index) }

    context "request" do
      before(:each) do
        stripe = double("Stripe::Customer", :data => [ {'id' => client.customer_key}] )
        Stripe::Customer.should_receive(:all).and_return(stripe)
      end

      it "should respond to index" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        get :index
        assigns(:clients).should_not be_nil
      end
    end
  end
end
