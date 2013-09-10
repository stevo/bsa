class Admin::User::MembershipAcceptanceController < Admin::AdminController
  def create
    SucceedVoting.new(self).perform
    redirect_to admin_users_path, notice: t('flashes.membership.accepted')
  end

  private

  def permitted_params
    params.permit(:user_id)
  end
end
