class Invoice < ActiveRecord::Base
  belongs_to  :project, :foreign_key => :project_id
  has_many :invoice_items

  attr_accessible :project_id, :amount, :tax, :total, :invoice_key, :paid_on

  validates_uniqueness_of :invoice_key

  before_save :generate_invoice_key

  def generate_invoice_key
    self.invoice_key = SecureRandom.hex(25)[0..8]
  end

end
