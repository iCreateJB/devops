class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices, :primary_key => :invoice_id do |t|
      t.integer     :project_id
      t.decimal     :amount
      t.decimal     :tax
      t.decimal     :total
      t.string      :invoice_key
      t.datetime    :paid_on
      t.timestamps
    end
  end
end
