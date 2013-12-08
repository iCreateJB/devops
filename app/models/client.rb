class Client < ActiveRecord::Base
  has_many :projects
  has_one :contact
  belongs_to :user

  attr_accessible :client_name, :enabled, :user_id, :api_key, :customer_key
  
  validates_uniqueness_of :client_name

  scope :with_contact_by_customer_keys, lambda {|keys|
    select('clients.id, clients.customer_key, clients.client_name, contacts.first_name, contacts.last_name, contacts.email').
    joins("LEFT JOIN contacts ON clients.id = contacts.client_id").
    where("clients.customer_key IN (?)", keys)
  }

  before_save :generate_api_key

  def generate_api_key
    self.api_key = SecureRandom.hex(16)[0..9]
  end
end