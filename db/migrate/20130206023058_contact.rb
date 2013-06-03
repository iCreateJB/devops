class Contact < ActiveRecord::Migration
  def up
    create_table :contacts do |i|
      i.integer       :client_id
      i.string        :first_name,    :limit => 55
      i.string        :last_name,     :limit => 55
      i.string        :email 
      i.string        :phone
      i.string        :payment_pin
      i.timestamps
    end
  end

  def down
    drop_table :contacts
  end
end
