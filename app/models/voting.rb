class Voting < ActiveRecord::Base
  belongs_to :membership
  has_many :votes
  has_one :candidate, class_name: User, through: :membership, source: :user

  delegate :name, to: :candidate, prefix: true

  scope :available_to_answer_for, ->(voter) do
    _scope = active.not_for(voter).not_voted_by(voter)
    voter.admin? ? _scope : _scope.where(closed: true)
  end

  scope :not_voted_by, ->(voter) { joins("LEFT OUTER JOIN votes AS v ON v.voting_id = votings.id AND v.voter_id = #{voter.id}").where('v.id' => nil) }
  scope :active, -> { joins(:membership).where('memberships.state' => 'being_polled') }
  scope :not_for, ->(candidate) { joins(:membership).where("memberships.user_id <> ?", candidate.id) }
end
