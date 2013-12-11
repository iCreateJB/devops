class InvoiceItems < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :invoice_id, :amount, :title, :description

  validates :invoice_id, :amount, :title, :presence => true
end
