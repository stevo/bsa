class Admin::User::RightsController < Admin::AdminController
  expose(:user, attributes: :permitted_params)

  def update
    user.save
    redirect_to admin_users_path, :notice => "User updated."
  end

  private

  def permitted_params
    params.require(:user).permit(:role_ids)
  end
end
