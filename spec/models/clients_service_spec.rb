require 'spec_helper'

describe ClientService do 
  subject { ClientService.new(options) }

  let(:user){ FactoryGirl.create(:user) }

  let(:options) { 
    {
      :project_name => "Upgrade for Beta", 
      :client_name  => "SmartRent LLC", 
      :first_name   => "John", 
      :last_name    => "Doe", 
      :phone        => "12345678", 
      :email        => "john.doe@smartrent.pro", 
      :website      => "http://www.smartrent.pro",
      :user_id      => user.id
    }
  }

  after do 
    DatabaseCleaner.clean
  end

  describe "Instance Methods" do 
    it { should respond_to(:save) }
  end

  context ".new" do 
    it "should #save" do 
      subject.stub(:save).and_return()
      subject.save
    end
  end

  context "validations" do 
    it "should be invalid if :company is blank" do 
      options.delete(:client_name)
      subject.valid?
      subject.errors.include?(:client_name).should be_true
    end

    it "should be invalid if :email is blank" do 
      options.delete(:email)
      subject.valid?
      subject.errors.include?(:email).should be_true
    end

    it "should be invalid if :first_name is blank" do 
      options.delete(:first_name)
      subject.valid?
      subject.errors.include?(:first_name).should be_true
    end

    it "should be invalid if :last_name is blank" do 
      options.delete(:last_name)
      subject.valid?
      subject.errors.include?(:last_name).should be_true
    end

    it "should be invalid if :phone is blank" do 
      options.delete(:phone)
      subject.valid?
      subject.errors.include?(:phone).should be_true
    end
  end

  context "Save" do 
    it "should .save" do 
      stripe = stub("Stripe::Customer", :id => '1_agfdh' )
      Stripe::Customer.should_receive(:create).and_return(stripe)
      client = mock_model("Client", :id => 1)
      Client.should_receive(:create).with({:client_name => options[:client_name], 
                                           :enabled => true, 
                                           :user_id => user.id,
                                           :customer_key => stripe.id}).and_return(client)
      Project.should_receive(:create).with({:client_id => client.id, 
                                            :project_name => options[:project_name], 
                                            :due_date => options[:due_date]})
      Contact.should_receive(:create).with({:client_id  => client.id, 
                                            :first_name => options[:first_name], 
                                            :last_name  => options[:last_name], 
                                            :email      => options[:email], 
                                            :phone      => options[:phone]})
      subject.save
    end
  end
end