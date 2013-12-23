# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice_item, :class => 'InvoiceItems' do
    invoice 
    amount 15.00
    title "Database Upgrades"
    description "Add the following columns to this table for reporting..."
    sequence :item_key do |n|
      "#{n}"
    end
  end
end
