class Client < ActiveRecord::Base
  has_many :projects
  has_many :contacts
  belongs_to :user

  attr_accessible :client_name, :enabled, :user_id, :api_key, :customer_key
  
  validates_uniqueness_of :client_name

  before_save :generate_api_key

  def generate_api_key
    self.api_key = SecureRandom.hex(16)[0..9]
  end
end