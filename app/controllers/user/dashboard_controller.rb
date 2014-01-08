class User::DashboardController < AuthenticatedController
  expose(:voting){ Voting.get_random_for(current_user) }
  expose(:decorated_voting){ voting.decorate }
  expose(:decorated_events){ Event.order(:starts_at).published.decorate }
end
