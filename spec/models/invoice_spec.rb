require 'spec_helper'

describe Invoice do
  let(:invoice){ FactoryGirl.create(:invoice) }
  let(:item_one){ FactoryGirl.create(:invoice_item, :invoice => invoice, :amount => 100.00) }
  let(:item_two){ FactoryGirl.create(:invoice_item, :invoice => invoice, :amount => 50.00) }

  subject{ Invoice.new }

  before(:each) do 
    item_one
    item_two
  end

  after do 
    DatabaseCleaner.clean
  end

  describe "Instance Methods" do 
    it { should respond_to(:recalculate) }
  end

  describe "Validations" do 
    it { should validate_presence_of(:client_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:tax) }
    it { should validate_presence_of(:total) }
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

  describe "#attr_accessible" do 
    it "has 7 attributes" do
      Invoice.attr_accessible[:default].size.should == 8
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

  context "Instance Methods" do 
    before(:each) do 
      invoice.recalculate
      @invoice = Invoice.find(invoice.invoice_id)
    end

    it "should not raise an error when recalculating" do 
      expect{ invoice.recalculate }.to_not raise_error
    end

    it "should recalculate the invoice total" do 
      amount = invoice.invoice_items.map{|i| i[:amount].to_f }.sum
      tax    = (amount * 0.0725).to_f
      @invoice.total.to_f.should == (amount + tax) 
    end

    it "should recalculate the invoice amount" do 
      @invoice.amount.to_f.should == invoice.invoice_items.map{|i| i[:amount].to_f }.sum
    end

    it "should recalculate the invoice tax" do 
      amount = invoice.invoice_items.map{|i| i[:amount].to_f }.sum
      @invoice.tax.to_f.should == (amount * 0.0725).to_f
    end
  end
end
