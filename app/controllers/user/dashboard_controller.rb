class User::DashboardController < AuthenticatedController
  expose(:current_user__){ current_user.decorate }
end
