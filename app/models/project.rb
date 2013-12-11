class Project < ActiveRecord::Base
  belongs_to :client
  has_many   :invoices,       dependent: :destroy
  attr_accessible :client_id, :project_name, :project_type, :due_date

  scope :by_user, lambda { |user|
    joins("LEFT JOIN clients ON projects.client_id = clients.id").
    where("clients.user_id = ?", user)
  }

  validates :client_id, :project_name, :presence => true
  validates_uniqueness_of :project_name, :scope => :client_id
end