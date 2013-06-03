class Project < ActiveRecord::Migration
  def up
    create_table :projects do |i|
      i.integer     :client_id
      i.string      :project_name
      i.string      :project_type
      i.date        :due_date
      i.timestamps
    end
  end

  def down
    drop_table :projects
  end
end
