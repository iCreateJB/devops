class AddCustomerKeyToClients < ActiveRecord::Migration
  def up
    add_column :clients, :customer_key, :string, :limit => 55
    add_index  :clients, :api_key
    add_index  :clients, :customer_key
  end

  def down
    remove_column :clients, :customer_key
    remove_index  :clients, :api_key
    remove_index  :clients, :customer_key
  end
end
