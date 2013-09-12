class Membership < ActiveRecord::Base
  MONTHLY_CONTRIBUTION_AMOUNT = 5

  belongs_to :user
  has_one :voting
  has_many :contributions

  scope :active, -> { where(state: 'approved') }

  state_machine :state, initial: :new do
    after_transition any => :approved do |membership, _|
      membership.touch(:approved_at)
    end

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

  def daily_contribution_amount
    MONTHLY_CONTRIBUTION_AMOUNT.to_f / 31
  end
end
