class Client < ActiveRecord::Base
  has_many :projects
  has_many :contacts

  attr_accessible :client_name, :enabled, :api_key
  
  validates_uniqueness_of :client_name
end