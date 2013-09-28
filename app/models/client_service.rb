class ClientService
  include ActiveModel::Validations
  include Savable
  
  attr_accessor :options, :company, :first_name, :last_name, :email, :phone, :api_key

  validates :company, :first_name, :last_name, :email, :phone, :presence => true

  def initialize(options={})
    @options        = options
    @company        = options[:company]
    @first_name     = options[:first_name]
    @last_name      = options[:last_name]
    @phone          = options[:phone]
    @email          = options[:email]
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

  def generate_api_key
    SecureRandom.hex(16)
  end
end