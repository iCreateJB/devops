class InvoiceItems < ActiveRecord::Base
  belongs_to :invoice
  attr_accessible :invoice_id, :amount, :title, :description
end
