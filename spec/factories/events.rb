# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name "Super impreza"
    description "Świetna impreza - OMG!"

    trait :published do
      state 'published'
    end
  end
end
