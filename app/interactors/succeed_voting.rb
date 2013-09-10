class SucceedVoting < Interactor
  perform do
    membership.force_approve!
    voting.try(:deactivate!)
  end

  helpers do
    def voting
      membership.voting
    end

    def membership
      get_user.membership || get_user.create_membership
    end

    def get_user
      User.find(permitted_params[:user_id])
    end
  end
end
