require 'spec_helper'

describe Project do 
  describe "Validations" do 
    it { should validate_presence_of(:client_id) }
    it { should validate_presence_of(:project_name) }
    it { should validate_uniqueness_of(:project_name).scoped_to(:client_id) }
  end

  describe "Relationships" do 
    before(:each) do 
      @belongs_to = subject.reflections.select{|n, r| r.macro == :belongs_to }.collect{|i| i[0] }    
      @has_many = subject.reflections.select{|n, r| r.macro == :has_many }.collect{|i| i[0] }  
    end

    it "has 1 belongs_to" do 
      @belongs_to.size.should == 1
    end

    it "belongs_to :client" do 
      @belongs_to.include?(:client).should == true
    end

    it "has 1 has_many" do 
      @has_many.size.should == 1
    end

    it "has_many :invoices" do 
      @has_many.include?(:invoices).should == true
    end
  end

  describe "#attr_accessible" do 
    it "has 5 attributes" do
      Project.attr_accessible[:default].size.should == 5
    end
    it "includes #client_id" do
      Project.attr_accessible[:default].include?("client_id").should be_true
    end
    it "includes #project_name" do 
      Project.attr_accessible[:default].include?("project_name").should be_true
    end
    it "includes #project_type" do
      Project.attr_accessible[:default].include?("project_type").should be_true
    end 
    it "includes #due_date" do 
      Project.attr_accessible[:default].include?("due_date").should be_true
    end
  end
end