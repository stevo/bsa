class User::VotesController < AuthenticatedController
  inherit_resources
  belongs_to :voting
  actions :create

  private

  def permitted_params
    enriched_params.permit(vote: [:state, :voter_id])
  end

  def enriched_params
    params.tap { |p| p[:vote].try(:merge!, {voter_id: current_user.id}) }
  end
end
