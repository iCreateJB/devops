require 'spec_helper' 

describe Client do 

  subject{ Client.new }

  describe "Relationships" do 
    before(:each) do 
      @has_one  = subject.reflections.select{|n, r| r.macro == :has_one }.collect{|i| i[0] }
      @has_many = subject.reflections.select{|n, r| r.macro == :has_many }.collect{|i| i[0] }
    end

    it "has 1 has_many" do 
      @has_many.size.should == 1
    end

    it "has_many :projects" do 
      @has_many.include?(:projects).should == true
    end

    it "has 1 has_one" do 
      @has_one.size.should == 1
    end

    it "has_one :contact" do 
      @has_one.include?(:contact).should == true
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

  it { should respond_to(:generate_api_key) }

  context "#api_key" do 
    it "should set the api key of the client" do 
      client = Client.new(client_name: 'Test Client')
      client.api_key.should == nil
      client.save
      client.api_key.should_not == nil
    end
  end

end