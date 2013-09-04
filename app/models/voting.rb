class Voting < ActiveRecord::Base
  belongs_to :membership
  has_one :candidate, class_name: User, through: :membership, source: :user

  delegate :name, to: :candidate, prefix: true

  scope :available_to_answer_for, ->(voter) do
    _scope = active.not_for(voter)
    voter.admin? ? _scope : _scope.where(closed: true)
  end

  scope :active, -> { joins(:membership).where('memberships.state' => 'being_polled') }
  scope :not_for, ->(candidate) { joins(:membership).where("memberships.user_id <> ?", candidate.id) }
end
