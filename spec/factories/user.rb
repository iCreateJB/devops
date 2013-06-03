FactoryGirl.define do
  factory :user, :class => 'User' do
    first_name "Jack" 
    last_name "Dorsey"
    sequence :email do |n|
     "Jack.Dorsey.#{n}@devops.com".downcase 
    end
    password "sekret1234"
    password_confirmation "sekret1234"
  end
end