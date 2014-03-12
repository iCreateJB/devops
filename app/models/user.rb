class User < ActiveRecord::Base
  has_many :clients

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  before_save :format_email

private
  def format_email
    self.email = email.downcase
  end
end
