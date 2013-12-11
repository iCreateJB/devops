require 'spec_helper'

describe Contact do 
  let(:contact){ FactoryGirl.create(:contact, :client => client) }
  let(:client){ FactoryGirl.create(:client) }

  before(:each) do 
    contact
  end

  after do 
    DatabaseCleaner.clean
  end

  describe "Validations" do 
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:phone) }
  end

  describe "Relationships" do 
    before(:each) do 
      @belongs_to = subject.reflections.select{|n, r| r.macro == :belongs_to }.collect{|i| i[0] }
    end

    it "has 1 belongs_to" do 
      @belongs_to.size.should == 1
    end

    it "belongs_to :client" do 
      @belongs_to.include?(:client).should == true
    end
  end

  describe "#attr_accessible" do 
    it "has 7 attributes" do
      Contact.attr_accessible[:default].size.should == 7
    end
    it "includes #client_id" do
      Contact.attr_accessible[:default].include?("client_id").should be_true
    end
    it "includes #first_name" do 
      Contact.attr_accessible[:default].include?("first_name").should be_true
    end
    it "includes #last_name" do
      Contact.attr_accessible[:default].include?("last_name").should be_true
    end 
    it "includes #email" do 
      Contact.attr_accessible[:default].include?("email").should be_true
    end  
    it "includes #phone" do 
      Contact.attr_accessible[:default].include?("phone").should be_true
    end
    it "includes #payment_pin" do 
      Contact.attr_accessible[:default].include?("payment_pin").should be_true
    end
  end

  context "#new contact" do 
    it "should downcase the email" do 
      contact = Contact.new(first_name: 'Test', last_name: 'User', email: 'Test.User@devops.com', phone: '1234567890', client_id: client.id)
      contact.save
      contact.email.should == 'test.user@devops.com'
    end
  end
end