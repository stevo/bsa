class Voting < ActiveRecord::Base
  ACCEPTANCE_THRESHOLD = 0.5

  belongs_to :membership
  has_many :votes
  has_one :candidate, class_name: User, through: :membership, source: :user

  delegate :name, to: :candidate, prefix: true

  scope :available_to_answer_for, ->(voter) do
    _scope = voter.membership_approved? ? all : none
    _scope = _scope.active.not_for(voter).not_voted_by(voter)
    voter.admin? ? _scope : _scope.where(closed: false)
  end

  scope :not_voted_by, ->(voter) { joins("LEFT OUTER JOIN votes AS v ON v.voting_id = votings.id AND v.voter_id = #{voter.id}").where('v.id' => nil) }
  scope :active, -> { joins(:membership).where('memberships.state' => 'being_polled', active: true) }
  scope :not_for, ->(candidate) { joins(:membership).where("memberships.user_id <> ?", candidate.id) }

  def self.get_random_for(voter)
    available_to_answer_for(voter).order("RANDOM()").first
  end

  def deactivate!
    update_column(:active, false)
  end

  def inactive?
    !active?
  end

  def passed?
    (voted_for.to_f / voted.to_f) > ACCEPTANCE_THRESHOLD
  end

  def voted
    votes.count
  end

  def voted_for
    votes.where(state: 'for').count
  end

  def voted_against
    votes.where(state: 'against').count
  end

  def holded_vote
    votes.where(state: 'hold').count
  end
end

