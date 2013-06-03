require 'spec_helper'

describe Savable do 
  subject { TestClass.new }

  before(:each) do 
    subject.extend(Savable)
  end

  describe "Instance Methods" do 
    it { should respond_to(:save_client) }
    it { should respond_to(:save_project) }
    it { should respond_to(:save_contact) }
    it { should respond_to(:save_invoice) }
    it { should respond_to(:save_invoice_items) }
  end
end

class TestClass
end