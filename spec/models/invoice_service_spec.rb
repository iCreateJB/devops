require 'spec_helper'

describe InvoiceService do 
  subject { InvoiceService.new(options) }

  let(:options){ 
    {
      :client_id  => 1, 
      :project_id => 1, 
      :items      => [
        { :amount => 15.00, :title => "Update Website.", :description => "Add Twitter Icon"}
      ]
    }
  }

  describe "Instance Methods" do 
    it { should respond_to(:build_invoice) }
    it { should respond_to(:calculate_total) }
    it { should respond_to(:calculate_tax) }
    it { should respond_to(:save) }

    it "should calculate_total" do 
      subject.calculate_total.should == options[:items].map{ |i| i[:amount] }.sum
    end

    it "should calculate_tax" do 
      total = options[:items].map{ |i| i[:amount] }.sum
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

    it "should be invalid when .project_id is blank" do 
      options.delete(:project_id)
      subject.valid?
      subject.errors.include?(:project).should be_true
    end
  end

  context "Save" do 
    it "should .save" do 
      invoice = mock_model("Invoice", :invoice_id => 1)
      tax     = (options[:items].map{ |i| i[:amount] }.sum * 0.0725)
      total   = (options[:items].map{ |i| i[:amount] }.sum * 0.0725) + (options[:items].map{ |i| i[:amount] }.sum)
      Invoice.should_receive(:create).with({:project_id => options[:project_id], 
                                            :amount     => options[:items].map{ |i| i[:amount] }.sum, 
                                            :tax        => tax, 
                                            :total      => total}).and_return(invoice)
      InvoiceItems.should_receive(:create).with({:invoice_id => invoice.invoice_id, 
                                                 :amount     => options[:items].map{ |i| i[:amount] }.sum,
                                                 :title      => options[:items].first[:title], 
                                                 :description => options[:items].first[:description]})
      subject.build_invoice
      subject.save
    end
  end
end