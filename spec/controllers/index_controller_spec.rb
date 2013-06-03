require 'spec_helper'

describe IndexController do
  let(:client){ FactoryGirl.create(:client) }
  let(:project){ FactoryGirl.create(:project, :client => client) }
  let(:invoice){ FactoryGirl.create(:invoice, :project => project)}
  let(:user){ FactoryGirl.create(:user) }

  before(:each) do 
    user.confirm!
    sign_in user
  end

  after do 
    DatabaseCleaner.clean
  end

  describe "Instance Methods" do 
    it { should respond_to(:index) }

    context "request" do 
      it "should respond to index" do 
        @request.env["devise.mapping"] = Devise.mappings[:user]
        get :index
        assigns(:projects).should_not be_nil
      end
    end
  end
end
