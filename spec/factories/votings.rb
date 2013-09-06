# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voting do
    membership_id 1
    finishes_at "2013-09-03"
    active true

    trait :inactive do
      active false
    end

    trait :active do
      active true
    end

    trait :membership_being_polled do
      membership { create(:membership_being_polled)}
    end

    trait :approved_membership do
      membership { create(:approved_membership)}
    end

    factory :passing_voting do
      after(:create) do |voting|
        FactoryGirl.create_list(:vote, 1, voting: voting, state: 'for')
      end
    end

    factory :not_passing_voting do
      after(:create) do |voting|
        FactoryGirl.create_list(:vote, 1, voting: voting, state: 'against')
      end
    end


    factory :voting_with_votes do
      ignore do
        votes_count 5
      end

      after(:create) do |voting, evaluator|
        if evaluator.votes_count.is_a? Hash
          evaluator.votes_count.each do |state, count|
            FactoryGirl.create_list(:vote, count, voting: voting, state: state.to_s)
          end
        else
          FactoryGirl.create_list(:vote, evaluator.votes_count, voting: voting)
        end
      end
    end
  end
end
