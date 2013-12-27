require 'spec_helper'

describe InvoiceService do 
  let(:client){ FactoryGirl.create(:client) }

  before(:each) do 
    client
  end

  after do 
    DatabaseCleaner.clean
  end

  subject { InvoiceService.new(options) }

  let(:options){ 
    {
      :client_id  => client.id, 
      :items      => {
        "0" => { :amount => 15.00, :title => "Update Website.", :description => "Add Twitter Icon"}
      }
    }
  }

  describe "Instance Methods" do 
    it { should respond_to(:build_invoice) }
    it { should respond_to(:calculate_total) }
    it { should respond_to(:calculate_tax) }
    it { should respond_to(:save) }

    it "should calculate_total" do 
      subject.calculate_total.should == options[:items].map{ |k,v| v[:amount] }.sum
    end

    it "should calculate_tax" do 
      total = options[:items].map{ |k,v| v[:amount] }.sum
      subject.instance_variable_set(:@total, total)
      subject.calculate_tax.should == (total * 0.0725)
    end 
  end

  describe "Class Methods" do 
    it { subject.class.should respond_to(:generate_invoice) }
  end

  describe "Validations" do 
    it "should be invalid when .total is blank" do 
      options.delete(:items)
      subject.valid?
      subject.errors.include?(:items).should be_true
    end

    it "should be invalid when .client is blank" do 
      options.delete(:client_id)
      subject.valid?
      subject.errors.include?(:client).should be_true
    end

  end

  context "Save" do 
    it "should .save" do 
      invoice = mock_model("Invoice", :invoice_id => 1)
      invoice.stub(:save).and_return()
      tax     = (options[:items].map{ |k,v| v[:amount] }.sum * 0.0725)
      total   = (options[:items].map{ |k,v| v[:amount] }.sum * 0.0725) + (options[:items].map{ |k,v| v[:amount] }.sum)
      Invoice.should_receive(:new).with({:client_id  => options[:client_id], 
                                            :amount     => options[:items].map{ |k,v| v[:amount] }.sum, 
                                            :tax        => tax, 
                                            :total      => total}).and_return(invoice)

      options[:items].each do |k,v|
        line_item = stub("Stripe::InvoiceItem", :cusotmer => anything, 
                                                :amount   => (v[:amount].to_f*100).to_i,
                                                :currency => 'usd',
                                                :description => v[:description],
                                                :id => anything)
        Stripe::InvoiceItem.should_receive(:create).and_return(line_item)

        InvoiceItems.should_receive(:create).with({:invoice_id => invoice.invoice_id, 
                                                   :amount     => v[:amount],
                                                   :title      => v[:title], 
                                                   :description => v[:description],
                                                   :item_key    => line_item.id})        
      end

      subject.build_invoice
      subject.save
    end
  end
end