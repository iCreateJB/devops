class ClientService
  include ActiveModel::Validations
  include Savable
  
  attr_accessor :options, :client_name, :first_name, :last_name, :email, :phone

  validates :client_name, :first_name, :last_name, :email, :phone, :presence => true

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
      save_project(client,@options) if @options[:project_name]
      save_contact(client,@options)
    end
  end
end