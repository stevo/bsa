# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    sequence :voting_id
    voter { create(:voter) }
    state 'for'
  end
end
