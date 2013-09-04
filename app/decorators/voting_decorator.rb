class VotingDecorator < Draper::Decorator
  delegate_all

  def vote_for_link
    vote_link(:for, 'btn-success')
  end

  def vote_against_link
    vote_link(:against, 'btn-danger')
  end

  def hold_vote_link
    vote_link(:hold, 'btn-default')
  end

  private

  def vote_link(state, klass)
    h.link_to I18n.t("enumerations.vote.state.#{state.to_s}"), h.user_voting_votes_path(object, {vote: {state: state.to_s}}),
              method: :post, class: "btn btn-lg #{klass}"
  end
end
