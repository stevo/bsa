class ContributionDecorator < Draper::Decorator
  delegate_all

  def amount
    h.number_to_currency(object.amount, locale: :pl)
  end

  def created_at
    h.time_ago_in_words(object.created_at)
  end
end
