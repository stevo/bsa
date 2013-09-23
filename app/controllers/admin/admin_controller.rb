class Admin::AdminController < AuthenticatedController
  before_action :authorize_admin!
  layout 'admin'

  private

  def authorize_admin!
    authorize! action_name.intern, @user, :message => 'Not authorized as an administrator.'
  end
end
