class Admin::User::VotingsController < Admin::AdminController
  def create
    StartVoting.perform(permitted_params)
    redirect_to admin_users_path, notice: t('flashes.voting.create')
  end

  def update
    ConcludeVoting.perform(permitted_params)
    redirect_to admin_users_path, notice: t('flashes.voting.update')
  end

  private

  def permitted_params
    params.permit(:user_id, {voting: [:closed, :transition]})
  end
end
