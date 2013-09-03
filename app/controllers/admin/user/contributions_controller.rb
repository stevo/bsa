class Admin::User::ContributionsController < Admin::AdminController
  inherit_resources
  belongs_to :user
  actions :index, :new, :create, :destroy

  def create
    super do |format|
      format.html { redirect_to_index }
    end
  end

  def destroy
    super do |format|
      format.html { redirect_to_index }
    end
  end

  private

  def redirect_to_index
    redirect_to admin_user_contributions_path(parent)
  end

  def permitted_params
    params.permit(contribution: [:amount])
  end
end
