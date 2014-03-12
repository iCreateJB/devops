require 'spec_helper'

describe ClientService do
  subject { ClientService.new(options) }

  let(:client){ FactoryGirl.create(:client, :user => user) }
  let(:contact){ FactoryGirl.create(:contact, :client => client )}
  let(:project){ FactoryGirl.create(:project, :client => client) }
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
      :user_id      => user.id,
      :customer_key => client.customer_key
    }
  }

  after do
    DatabaseCleaner.clean
  end

  describe "Instance Methods" do
    it { should respond_to(:save) }
    it { should respond_to(:update) }
    it { should respond_to(:delete)}
    it { subject.class.should respond_to(:update)}
    it { subject.class.should respond_to(:delete)}
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
    before(:each) do
      @stripe = double("Stripe::Customer", :id => '1_agfdh' )
      Stripe::Customer.should_receive(:create).and_return(@stripe)
    end

    it "should .save" do
      client = mock_model("Client", :id => 1)
      Client.should_receive(:create).with({:client_name => options[:client_name],
                                           :enabled => true,
                                           :user_id => user.id,
                                           :customer_key => @stripe.id}).and_return(client)
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

  context "Update" do
    before(:each) do
      @stripe = double("Stripe::Customer", :id => '1_agfdh' )
      Stripe::Customer.should_receive(:retrieve).and_return(@stripe)
    end

    it "should .update" do
      @stripe.stub(:email=).and_return()
      @stripe.stub(:description=).and_return()
      @stripe.stub(:metadata=).and_return()
      @stripe.stub(:save).and_return()
      Client.should_receive(:find).exactly(2).times.and_return(client)
      subject.update
    end
  end

  context "Delete" do
    before(:each) do
      @stripe = double("Stripe::Customer", :id => '1_agfdh' )
      @stripe.stub(:delete).and_return(true)
      Stripe::Customer.should_receive(:retrieve).and_return(@stripe)
    end

    it "should .delete" do
      Client.should_receive(:find_by_customer_key).with(options[:customer_key]).and_return(client)
      subject.delete
    end
  end
end
