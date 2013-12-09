FactoryGirl.define do
  factory :contact, :class => 'Contact' do
    first_name "John"
    last_name "Doe"
    sequence :email do |n|
      "#{first_name}.#{n}.#{last_name}@devops.com".downcase
    end
    phone "2168676712"
  end
end