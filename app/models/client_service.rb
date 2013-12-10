class ClientService
  include ActiveModel::Validations
  include Savable
  
  attr_accessor :options, :client_name, :first_name, :last_name, :email, :phone

  validates :client_name, :first_name, :last_name, :email, :phone, :presence => true

  def self.update(options={})
    self.new(options)
  end

  def self.delete(options={})
    self.new(options).delete
  end

  def initialize(options={})
    @options        = options
    @client_name    = options[:client_name]
    @first_name     = options[:first_name]
    @last_name      = options[:last_name]
    @phone          = options[:phone]
    @email          = options[:email]
  end

  def save
    if valid? 
      client = save_client(@options)
      save_project(client,@options) if !@options[:project_name].blank?
      save_contact(client,@options)
    end
  end

  def update
    if valid?
      update_stripe_customer
      update_client(options)
      update_contact(options)
    end
  end

  def delete
    begin 
      client = Client.where(customer_key: options[:customer_key])
      stripe = Stripe::Customer.retrieve(options[:customer_key])
      stripe.delete
      client.destroy()
    rescue => e
      Rails.logger.error "[ERROR] #{Time.now} : #{e}"
    end
  end
end