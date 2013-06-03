FactoryGirl.define do
  factory :contact, :class => 'Contact' do
    first_name "John"
    last_name "Doe"
    email { "#{first_name}.#{last_name}@devops.com".downcase }
    phone "2168676712"
  end
end