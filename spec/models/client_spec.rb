require 'spec_helper' 

describe Client do 
  describe "Relationships" do 
    before(:each) do 
      @has_many = subject.reflections.select{|n, r| r.macro == :has_many }.collect{|i| i[0] }
    end

    it "has 2 belongs_to" do 
      @has_many.size.should == 2
    end

    it "has_many :projects" do 
      @has_many.include?(:projects).should == true
    end

    it "has_many :contacts" do 
      @has_many.include?(:contacts).should == true
    end
  end

  describe "#attr_accessible" do 
    it "has 4 attributes" do
      Client.attr_accessible[:default].size.should == 6
    end
    it "includes #user_id" do 
      Client.attr_accessible[:default].include?("user_id").should be_true
    end
    it "includes #client_name" do
      Client.attr_accessible[:default].include?("client_name").should be_true
    end
    it "includes #enabled" do 
      Client.attr_accessible[:default].include?("enabled").should be_true
    end
    it "includes #api_key" do
      Client.attr_accessible[:default].include?("api_key").should be_true
    end 
    it "includes #customer_key" do
      Client.attr_accessible[:default].include?("customer_key").should be_true
    end     
  end
end