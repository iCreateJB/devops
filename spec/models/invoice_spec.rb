require 'spec_helper'

describe Invoice do
  subject{ Invoice.new }

  describe "Validations" do 
    it { should validate_presence_of(:client_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:tax) }
    it { should validate_presence_of(:total) }
    it { should validate_presence_of(:invoice_key) }
  end

  describe "Relationships" do
    before(:each) do 
      @has_many = subject.reflections.select{|n, r| r.macro == :has_many }.collect{|i| i[0] }
      @belongs_to = subject.reflections.select{|n, r| r.macro == :belongs_to }.collect{|i| i[0] }
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

    it "has_many :invoice_items" do 
      @has_many.include?(:invoice_items).should == true
    end
  end

  describe "Instance Methods" do 
    it { should respond_to(:generate_invoice_key) }
  end

  describe "#attr_accessible" do 
    it "has 7 attributes" do
      Invoice.attr_accessible[:default].size.should == 7
    end
    it "includes #project_id" do
      Invoice.attr_accessible[:default].include?("client_id").should be_true
    end
    it "includes #amount" do 
      Invoice.attr_accessible[:default].include?("amount").should be_true
    end
    it "includes #tax" do
      Invoice.attr_accessible[:default].include?("tax").should be_true
    end 
    it "includes #total" do 
      Invoice.attr_accessible[:default].include?("total").should be_true
    end
    it "includes #invoice_key" do 
      Invoice.attr_accessible[:default].include?("invoice_key").should be_true
    end
    it "includes #paid_on" do 
      Invoice.attr_accessible[:default].include?("paid_on").should be_true
    end
  end
end
