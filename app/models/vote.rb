class Vote < ActiveRecord::Base
  belongs_to :voter, class_name: User
  belongs_to :voting

  validates :voter_id, uniqueness: { scope: :voting_id }
  validate :voter_is_permitted_to_vote

  private

  def voter_is_permitted_to_vote
    errors.add(:base, :not_permitted_to_vote) unless voter.membership_approved?
  end
end
