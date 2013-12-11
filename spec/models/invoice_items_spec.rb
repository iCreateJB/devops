require 'spec_helper'

describe InvoiceItems do
  subject { InvoiceItems.new }

  describe "Validations" do 
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:title)}
  end

  describe "Relationships" do 
    before(:each) do 
      @belongs_to = subject.reflections.select{|n, r| r.macro == :belongs_to }.collect{|i| i[0] }
    end

    it "has 1 belongs_to" do 
      @belongs_to.size.should == 1
    end

    it "belongs_to :invoice" do 
      @belongs_to.include?(:invoice).should == true
    end
  end

  describe "#attr_accessible" do 
    it "has 4 attributes" do
      InvoiceItems.attr_accessible[:default].size.should == 5
    end
    it "includes #invoice_id" do
      InvoiceItems.attr_accessible[:default].include?("invoice_id").should be_true
    end
    it "includes #amount" do 
      InvoiceItems.attr_accessible[:default].include?("amount").should be_true
    end
    it "includes #title" do
      InvoiceItems.attr_accessible[:default].include?("title").should be_true
    end 
    it "includes #description" do 
      InvoiceItems.attr_accessible[:default].include?("description").should be_true
    end
  end
end
