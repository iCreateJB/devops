class Contact < ActiveRecord::Base
  belongs_to :client

  attr_accessible :client_id, :first_name, :last_name, :email, :phone, :payment_pin

  validates :first_name, :last_name, :phone, :client_id, :email, :presence => true
  validates_uniqueness_of :email

  before_save :generate_payment_pin

  before_save :format_email

private 
  def format_email
    self.email = email.downcase
  end

  def generate_payment_pin
    self.payment_pin = SecureRandom.hex(16).gsub(/\D/,'')[0..7]
  end
end