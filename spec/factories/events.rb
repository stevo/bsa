# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event, :class => 'Events' do
    name "Super impreza"
    description "Świetna impreza - OMG!"
  end
end
