class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items, :primary_key => :invoice_item_id do |t|
      t.integer       :invoice_id 
      t.decimal       :amount
      t.string        :title
      t.string        :description
      t.timestamps
    end
  end
end
