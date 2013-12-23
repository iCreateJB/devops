class CreateInvoiceItemKey < ActiveRecord::Migration
  def up
    add_column :invoice_items,  :item_key,  :string,  :limit => 55
  end

  def down
    remove_column :invoice_items
  end
end
