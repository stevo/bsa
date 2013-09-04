class User::DashboardController < AuthenticatedController
  expose(:current_user__){ current_user.decorate }
  expose(:voting){ Voting.available_to_answer_for(current_user).order("RANDOM()").first }
  expose(:decorated_voting){ voting.decorate }
end
