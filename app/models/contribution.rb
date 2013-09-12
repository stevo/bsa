class Contribution < ActiveRecord::Base
  belongs_to :user
  belongs_to :membership

  before_create -> { self.membership_id = user.membership.id }
  validates :amount, numericality: {greater_than: 0}, presence: true
end
