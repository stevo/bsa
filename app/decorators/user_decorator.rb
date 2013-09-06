class UserDecorator < Draper::Decorator
  delegate_all

  def membership_state(version=:short)
    if version == :full
      membership_state_full
    else
      I18n.t("enumerations.membership.state.#{object.membership_state}").tap do |_state|
        _state << ' '<< voted_badge if object.membership_being_polled?
      end.html_safe
    end
  end

  def voted_badge
    h.content_tag(:span, object.voting.voted, class: 'badge', data: {toggle: 'tooltip', original_title: I18n.t('tooltips.vote.given')})
  end

  def membership_actions
    if object.membership_new?
      h.link_to I18n.t('enumerations.voting.kind.open'),
                h.admin_user_votings_path(object),
                method: :post
    elsif object.membership_being_polled?
      h.link_to I18n.t('links.voting.conclude'),
                h.admin_user_voting_path(object, object.voting, {voting: {transition: 'conclude'}}),
                method: :put
    end
  end

  private

  def membership_state_full
    if object.guest?
      h.content_tag(:div, I18n.t('activemodel.user.guest_alert'), class: 'alert alert-warning') <<
        h.content_tag(:p, class: 'text-center') do
          h.link_to I18n.t('activemodel.user.join_association_link'), h.user_membership_path, method: :post, class: 'btn btn-success btn-lg'
        end
    elsif !object.membership_approved?
      h.content_tag(:div, I18n.t("activemodel.membership.statuses.#{object.membership_state}.description"), class: 'alert alert-info')
    end
  end

end
