# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voting do
    membership_id 1
    closed false
    finishes_at "2013-09-03"
  end
end
