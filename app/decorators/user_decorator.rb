class UserDecorator < Draper::Decorator
  delegate_all

  def membership_state_full
    if object.guest?
      h.content_tag(:div, I18n.t('activemodel.user.guest_alert'), class: 'alert alert-warning') <<
      h.content_tag(:p, class: 'text-center') do
        h.link_to I18n.t('activemodel.user.join_association_link'), h.user_membership_path, method: :post, class: 'btn btn-success btn-lg'
      end
    elsif !object.membership_approved?
      h.content_tag(:div,I18n.t("activemodel.membership.statuses.#{object.membership_state}.description"), class: 'alert alert-info')
    end
  end

  def membership_state
    I18n.t("enumerations.membership.state.#{object.membership_state}")
  end
end