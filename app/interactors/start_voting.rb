class StartVoting < Interactor
  perform do
    if membership.poll
      membership.create_voting(permitted_params[:voting])
    else
      false
    end
  end

  helpers do
    def membership
      get_user.membership
    end

    def get_user
      User.find(permitted_params[:user_id])
    end
  end
end
