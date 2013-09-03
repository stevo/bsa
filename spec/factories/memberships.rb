# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    user_id 1
    approved_at '2013-09-03'
    monthly_contribution '9.99'
    state 'new'
  end
end
