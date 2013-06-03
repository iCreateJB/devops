FactoryGirl.define do
  factory :project, :class => 'Project' do
    client
    sequence :project_name do |n|
      "Project #{n}"
    end
    project_type "Rails"
    due_date 2.months.from_now
  end
end