class Admin::AdminController < ApplicationController
  before_action :authenticate_user!, :authorize_admin!

  private

  def authorize_admin!
    authorize! action_name.intern, @user, :message => 'Not authorized as an administrator.'
  end
end
