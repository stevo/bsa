# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    voting_id 1
    voter_id 1
    state "MyString"
  end
end
