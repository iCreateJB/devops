class InvoiceItems < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :invoice_id, :amount, :title, :description, :item_key

  validates :invoice_id, :amount, :title, :presence => true
end
