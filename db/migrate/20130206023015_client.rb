class Client < ActiveRecord::Migration
  def up
    create_table :clients do |i|
      i.integer    :user_id
      i.string     :client_name, :limit => 55
      i.boolean    :enabled,     :default => true
      i.string     :api_key
      i.timestamps
    end
  end

  def down
    drop_table :clients
  end
end
