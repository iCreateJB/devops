require 'spec_helper'

describe ProjectController do
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
    it { should respond_to(:edit) }
    it { should respond_to(:update) }
  end

  context "request" do 
    it "should respond to edit" do 
      get :edit, :project_id => project.id
      assigns(:project).should_not be_nil
    end

    it "should respond to update" do
      put :update, :id => project.id, :project => { :project_name => 'Test 1'}
      update = Project.find(project.id)
      update.project_name.should == 'Test 1'
    end
  end
end
