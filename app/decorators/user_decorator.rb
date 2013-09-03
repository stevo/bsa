class UserDecorator < Draper::Decorator

  def association_status
    if object.guest?
      h.content_tag(:div, I18n.t('activemodel.user.guest_alert'), class: 'alert alert-warning')
    else
      h.content_tag(:div,'TODO', class: 'alert alert-success')
    end
  end
end
