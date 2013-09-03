class Membership < ActiveRecord::Base
  belongs_to :user

  state_machine :state, initial: :new do
    event :activate do
      transition :new => :active
    end
  end
end
