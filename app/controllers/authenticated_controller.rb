class AuthenticatedController < ApplicationController
  expose(:decorated_current_user){ current_user.decorate }

  before_action :authenticate_user!
end
