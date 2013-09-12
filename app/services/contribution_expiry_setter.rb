class ContributionExpirySetter
  attr_reader :contribution
  delegate :membership, :amount, to: :contribution
  delegate :daily_contribution_amount, to: :membership

  private :contribution, :membership, :daily_contribution_amount, :amount

  def initialize(contribution)
    @contribution = contribution
  end

  def save
    contribution.update_column(:expires_at, calculate_expiry)
  end

  private

  def calculate_expiry
    current_expiry + days_covered_by_amount.days
  end

  def days_covered_by_amount
    (amount / daily_contribution_amount).round
  end

  def current_expiry
    membership.contributions.maximum(:expires_at) || membership.approved_at
  end
end
