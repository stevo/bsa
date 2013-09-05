class Vote < ActiveRecord::Base
  belongs_to :voter, class_name: User
  belongs_to :voting

  validates :voter_id, uniqueness: { scope: :voting_id }
end
