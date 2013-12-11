class Client < ActiveRecord::Base
  has_many :projects, dependent: :destroy
  has_one :contact,   dependent: :destroy
  belongs_to :user

  attr_accessible :client_name, :enabled, :user_id, :api_key, :customer_key
  
  validates :client_name, :presence => true
  validates_uniqueness_of :client_name

  scope :with_contact_by_user_and_customer_keys, lambda {|user,keys|
    select('clients.id, clients.customer_key, clients.client_name, contacts.first_name, contacts.last_name, contacts.email, contacts.phone').
    joins("LEFT JOIN contacts ON clients.id = contacts.client_id").
    where("clients.user_id = ?",user).
    where("clients.customer_key IN (?)", keys)
  }

  scope :with_contact_info_by_user_and_client_id, lambda {|user,client_id|
    select('clients.id, clients.customer_key, clients.client_name, contacts.first_name, contacts.last_name, contacts.email, contacts.phone').
    joins("LEFT JOIN contacts ON clients.id = contacts.client_id").
    where("clients.user_id = ?", user).
    where("clients.id = ?", client_id)
  }

  before_save :generate_api_key

  def generate_api_key
    self.api_key = SecureRandom.hex(16)[0..9]
  end
end