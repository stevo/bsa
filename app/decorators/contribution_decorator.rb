class ContributionDecorator < Draper::Decorator
  INFINITY = 1.0 / 0

  delegate_all
  delegate :content_tag, to: :h

  def amount
    h.number_to_currency(object.amount, locale: :pl)
  end

  def created_at
    h.time_ago_in_words(object.created_at)
  end


  def expires_at
    h.distance_of_time_in_words(Time.now, object.expires_at)
  end

  def expires_at_label
    content_tag(:span, expiry_message, class: "label label-default label-#{expires_at_warn_level}")
  end

  private

  def expiry_message
    if days_to_expiry > 0
      I18n.t('common.expires', distance: expires_at)
    else
      I18n.t('common.expired')
    end
  end

  def expires_at_warn_level
    case days_to_expiry
      when 7..INFINITY then
        'success'
      when 1..7 then
        'warning'
      else
        'danger'
    end
  end

  def days_to_expiry
    object.expires_at - Date.today
  end
end
