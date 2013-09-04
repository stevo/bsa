class StartVoting
  include Interactor

  def perform
    if membership.poll
      membership.create_voting
    else
      context.fail!
    end
  end

  private

  def membership
    get_user.membership
  end

  def get_user
    User.find(context['user_id'])
  end
end
