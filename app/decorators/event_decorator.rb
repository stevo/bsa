class EventDecorator < ApplicationDecorator
  delegate_all

  def transition_link
     object.state_events.map do |transition|
       h.link_to(transition.to_s, h.admin_event_path(object, event: {transition: transition}), method: :put , class: 'btn btn-xs btn-default')
     end.join(' ').html_safe
  end
end
