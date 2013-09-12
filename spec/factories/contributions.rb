# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contribution do
    amount "9.99"
    user { create(:user, :approved_membership) }
  end
end
