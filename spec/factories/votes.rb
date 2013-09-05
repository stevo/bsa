# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    sequence :voting_id
    sequence :voter_id
    state 'for'
  end
end
