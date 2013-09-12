# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership, aliases: [:new_membership] do
    monthly_contribution '9.99'
    state 'new'

    factory :membership_being_polled do
      state 'being_polled'
    end

    factory :approved_membership do
      state 'approved'
      approved_at { Date.today }
    end

    factory :disapproved_membership do
      state 'disapproved'
    end
  end
end
