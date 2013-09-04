class ConcludeVoting
  include Interactor

  def perform
    if voting.passed?
      membership.approve!
    else
      membership.disapprove!
    end
    voting.deactivate!
  end

  private

  def voting
    membership.voting
  end

  def membership
    get_user.membership
  end

  def get_user
    User.find(context['user_id'])
  end
end
