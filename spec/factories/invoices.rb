# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    client
    amount 100.00
    tax 7.00
    total 107.00
    sequence :invoice_key do |n|
      "#{n}_#{SecureRandom.uuid}"
    end     
  end
end
