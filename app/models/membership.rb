class Membership < ActiveRecord::Base
  belongs_to :user
  has_one :voting

  state_machine :state, initial: :new do
    event :poll do
      transition :new => :being_polled
    end

    event :approve do
      transition :being_polled => :approved
    end
  end
end
