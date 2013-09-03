class User::MembershipController < AuthenticatedController
  inherit_resources
  defaults singleton: true
  actions :create

  protected

  def begin_of_association_chain
    current_user
  end
end
