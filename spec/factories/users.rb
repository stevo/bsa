# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    sequence(:email) {|n| "person#{n}@example.com" }
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now

    factory :admin do
      after(:create) do |user|
        user.add_role(:admin)
      end
    end

    trait :new_membership do
      membership { create(:new_membership) }
    end

    trait :membership_being_polled do
      membership { create(:membership_being_polled) }
    end

    trait :approved_membership do
      membership { create(:approved_membership) }
    end

    factory :voter do
      membership { create(:approved_membership) }
    end

    factory :candidate do
      membership { create(:membership_being_polled, voting: create(:voting)) }
    end
  end
end
