class Admin::User::VotingsController < Admin::AdminController
  def create
    StartVoting.perform(permitted_params)
    redirect_to :back, notice: t('flashes.voting.create')
  end

  private

  def permitted_params
    params.permit(:user_id, {voting: [:closed]})
  end
end
