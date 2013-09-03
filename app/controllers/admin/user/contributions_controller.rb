class Admin::User::ContributionsController < Admin::AdminController
  inherit_resources
  belongs_to :user
  actions :index, :new, :create, :destroy

  def create
    super do |format|
      format.html { redirect_to admin_user_contributions_path(parent) }
    end
  end

  private

  def permitted_params
    params.permit(contribution: [:amount])
  end
end
