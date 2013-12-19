class ChangeInvoiceProjectIdToClientId < ActiveRecord::Migration
  def up
    remove_column :invoices, :project_id
    add_column    :invoices, :client_id,    :integer
  end

  def down
    add_column    :invoices, :project_id,   :integer
  end
end
