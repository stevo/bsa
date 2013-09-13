class Admin::User::MembershipsController < Admin::AdminController
  expose(:membership, attributes: :permitted_params)

  def update
    membership.save
    redirect_to admin_users_path, notice: t('flashes.membership.updated')
  end

  private

  def permitted_params
    params.require(:membership).permit(:approved_at)
  end
end
