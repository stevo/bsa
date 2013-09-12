class Contribution < ActiveRecord::Base
  belongs_to :user
  belongs_to :membership

  validates :amount, numericality: {greater_than: 0}, presence: true
  validate :membership_approved

  private

  def membership_approved
    errors.add(:base, :membership_not_approved) unless membership.try(:approved?)
  end
end
