class ConcludeVoting < Interactor
  perform do
    if voting.passed?
      membership.approve!
    else
      membership.disapprove!
    end
    voting.deactivate!
  end

  helpers do
    def voting
      membership.voting
    end

    def membership
      get_user.membership
    end

    def get_user
      User.find(permitted_params['user_id'])
    end
  end
end
