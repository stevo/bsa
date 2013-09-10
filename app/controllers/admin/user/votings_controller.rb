class Admin::User::VotingsController < Admin::AdminController
  def create
    StartVoting.new(self).perform
    redirect_to admin_users_path, notice: t('flashes.voting.create')
  end

  def update
    ConcludeVoting.new(self).perform
    redirect_to admin_users_path, notice: t('flashes.voting.update')
  end

  private

  def permitted_params
    params.permit(:user_id, {voting: [:closed]})
  end
end
