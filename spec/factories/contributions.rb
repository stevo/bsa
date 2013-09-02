# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contribution do
    amount "9.99"
    user_id 1
  end
end
