class ClientService
  include Savable
  
  attr_accessor :client_id, :project_name, :company, :first_name, :last_name, :phone, :email, :website, :errors, :api_key, :due_date

  def initialize(options={})
    @client_id      = nil
    @project_name   = options[:project_name]
    @due_date       = options[:due_date]
    @company        = options[:company]
    @first_name     = options[:first_name]
    @last_name      = options[:last_name]
    @phone          = options[:phone]
    @email          = options[:email]
    @website        = options[:webiste]
    @errors         = {}
    @options        = options
  end

  def setup
    @api_key           = generate_api_key
    @options[:api_key] = @options[:api_key]
  end

  def save
    if valid? 
      client = save_client(@options)
      save_project(client,@options)
      save_contact(client,@options)
    end
  end

private
  def valid? 
    validate_company
    validate_contact
    @errors.empty?
  end

  def generate_api_key
    SecureRandom.hex(16)
  end

  def validate_company
    @errors[:company] = "Company can't be blank" if @company.blank?
  end

  def validate_contact
    @errors[:email]      = "Contact should have an email address" if @email.blank?
    @errors[:first_name] = "Contact should have a first name" if @first_name.blank?
    @errors[:last_name]  = "Contact should have a last name" if @last_name.blank?
    @errors[:phone]      = "Contact should have a phone number" if @phone.blank?
  end
end