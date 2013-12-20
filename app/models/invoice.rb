class Invoice < ActiveRecord::Base
  belongs_to  :client,       :foreign_key => :client_id
  has_many :invoice_items,   :class_name  => "InvoiceItems",  dependent: :destroy

  attr_accessible :invoice_items_attributes, :client_id, :amount, :tax, :total, :invoice_key, :paid_on

  accepts_nested_attributes_for :invoice_items, allow_destroy: true

  validates :client_id, :amount, :tax, :total, :presence => true

  validates_uniqueness_of :invoice_key

  before_save :generate_invoice_key

  def generate_invoice_key
    self.invoice_key = SecureRandom.hex(25)[0..8]
  end

end
