require 'spec_helper'

describe Savable do 
  subject { TestClass.new }

  describe "Instance Methods" do 
    it { should respond_to(:save_client) }
    it { should respond_to(:save_project) }
    it { should respond_to(:save_contact) }
    it { should respond_to(:save_invoice) }
    it { should respond_to(:save_invoice_items) }
    it { should respond_to(:update_stripe_customer) }
    it { should respond_to(:update_client) }
    it { should respond_to(:update_contact) }
  end
end

class TestClass
  include Savable
end