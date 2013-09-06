class SucceedVoting < ConcludeVoting
  include Interactor

  def perform
    membership.force_approve!
    voting.try(:deactivate!)
  end

  private

  def membership
    get_user.membership || get_user.create_membership
  end
end
