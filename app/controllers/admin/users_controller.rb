class Admin::UsersController < Admin::AdminController
  expose(:decorated_collection) { User.all.decorate }
  expose(:user, model: User, attributes: :permitted_params)
  expose(:membership) { user.membership }
  expose(:contributions) { user.contributions.decorate }
  expose(:decorated_user) { user.decorate }

  def update
    if user.save
      redirect_to admin_users_path, :notice => "User updated."
    else
      redirect_to admin_users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    unless user == current_user
      user.destroy
      redirect_to admin_users_path, :notice => "User deleted."
    else
      redirect_to admin_users_path, :notice => "Can't delete yourself."
    end
  end

  private

  def permitted_params
    params.require(:user).permit(:name)
  end
end
