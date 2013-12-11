# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    project
    amount 100.00
    tax 7.00
    total 107.00
    invoice_key SecureRandom.uuid
  end
end
