class Admin::User::ContributionsController < Admin::AdminController
  inherit_resources
  belongs_to :user
  actions :new, :create, :destroy

  def create
    super do |format|
      format.html { redirect_to :back }
    end
  end

  def destroy
    super do |format|
      format.html { redirect_to :back }
    end
  end

  private

  def permitted_params
    params.permit(contribution: [:amount])
  end
end
