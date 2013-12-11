require 'spec_helper'

describe ProjectController do
  let(:client){ FactoryGirl.create(:client) }
  let(:project){ FactoryGirl.create(:project, :client => client) }
  let(:invoice){ FactoryGirl.create(:invoice, :project => project)}
  let(:user){ FactoryGirl.create(:user) }

  let(:params){ 
    {
      :client_id => client.id, 
      :project_name => 'Test 1'
    }
  }

  before(:each) do 
    user.confirm!
    sign_in user
  end  

  after do 
    DatabaseCleaner.clean
  end

  describe "Instance Methods" do 
    it { should respond_to(:index) }
    it { should respond_to(:new) }
    it { should respond_to(:create)}
    it { should respond_to(:edit) }
    it { should respond_to(:update) }
  end

  context "Request" do 
    it "should render new" do 
      get :new
      response.should render_template(:new)
    end

    it "should #create" do 
      post :create, params
      response.should redirect_to dashboard_path
    end

    it "should not #create" do 
      params.delete(:project_name)
      post :create, params
      flash[:error].should_not be_nil
      response.should redirect_to new_project_path
    end

    it "should respond to edit" do 
      get :edit, :project_id => project.id
      assigns(:project).should_not be_nil
    end

    it "should respond to update" do
      put :update, :id => project.id, :project => { :project_name => 'Test 1'}
      response.should redirect_to dashboard_path
    end

    it "should not update" do 
      put :update, :id => project.id, :project => { :project_name => nil }
      response.should redirect_to edit_project_path
    end
  end
end
