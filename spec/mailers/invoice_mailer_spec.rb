require "spec_helper"

describe InvoiceMailer do
  let(:client){ FactoryGirl.create(:client, :customer_key => 'cus_12345') }
  let(:project){ FactoryGirl.create(:project, :client => client) }
  let(:invoice){ FactoryGirl.create(:invoice)}
  let(:user){ FactoryGirl.create(:user) }
  let(:contact){ FactoryGirl.create(:contact, :client => client )}
  let(:options){
    {
      :invoice => invoice,
      :contact => contact
    }
  }

  before(:each) do 
    contact
    user.confirm!
  end

  after do 
    ActionMailer::Base.deliveries.clear
    DatabaseCleaner.clean
  end

  context "Class Methods" do 
    it { InvoiceMailer.should respond_to(:send_invoice) }
  end

  before(:each) do 
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []    
    InvoiceMailer.send_invoice(options).deliver
  end

  it "should send an email" do 
    ActionMailer::Base.deliveries.count.should == 1
  end

  it "should send an email to" do 
    ActionMailer::Base.deliveries.first.to.should == [contact.email]
  end

  it 'should set the subject to the correct subject' do
    ActionMailer::Base.deliveries.first.subject.should == "#{contact.email}, your invoice is ready!"
  end  

  it 'renders the sender email' do  
    ActionMailer::Base.deliveries.first.from.should == ["donotreply@jonathanballard.com"]
  end  

end
