FactoryGirl.define do
  factory :client, :class => 'Client' do
    sequence :client_name do |n|
      "Client #{n}"
    end
    enabled true
  end
end