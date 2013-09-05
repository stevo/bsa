class User::MembershipController < AuthenticatedController
  inherit_resources
  defaults singleton: true
  actions :create
  before_action :require_no_membership, only: [:create]

  protected

  def require_no_membership
    raise IntegrityException, "This user has membership already!" if current_user.membership
  end

  def begin_of_association_chain
    current_user
  end
end
