class Membership < ActiveRecord::Base
  belongs_to :user
  has_one :voting

  scope :active, -> { where(state: 'approved') }

  state_machine :state, initial: :new do
    event :poll do
      transition [:new, :disapproved] => :being_polled
    end

    event :approve do
      transition :being_polled => :approved
    end

    event :disapprove do
      transition :being_polled => :disapproved
    end

    event :force_approve do
      transition any => :approved
    end
  end
end
