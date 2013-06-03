class Project < ActiveRecord::Base
  belongs_to :client
  has_many   :invoices
  attr_accessible :client_id, :project_name, :project_type, :due_date
end