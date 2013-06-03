class Contact < ActiveRecord::Base
  belongs_to :client

  attr_accessible :client_id, :first_name, :last_name, :email, :phone, :payment_pin

  before_save :generate_payment_pin

private 
  def generate_payment_pin
    self.payment_pin = SecureRandom.hex(16).gsub(/\D/,'')[0..7]
  end
end