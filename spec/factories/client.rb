FactoryGirl.define do
  factory :client, :class => 'Client' do
    sequence :client_name do |n|
      "Client #{n}"
    end
    enabled true
    sequence :customer_key do |n|
     "customer-key-#{n}"
    end
  end
end