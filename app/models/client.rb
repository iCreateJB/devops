class Client < ActiveRecord::Base
  has_many :projects
  has_many :contacts
  belongs_to :user

  attr_accessible :client_name, :enabled, :user_id, :api_key, :customer_key
  
  validates_uniqueness_of :client_name
end