# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :forum do
    name "Foo Forum"
    url "https://www.foo.bar"
    login_url "https://foo.bar/login"
    meeting_url "https://foo.bar/topics/meetings"
    state false
    user "awesome_user"
    password "awesome_password"
  end
end
