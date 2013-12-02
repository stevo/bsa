class Event < ActiveRecord::Base
  validates :name, presence: true

  attr_accessor :transition

  after_save :process_transition, if: :transition

  scope :published, ->{ where(state: 'published') }

  state_machine :state, initial: :new do

    event :publish do
      transition :new => :published
    end

    event :cancel do
      transition [:new, :published] => :canceled
    end

    event :finish do
      transition :published => :finished
    end
  end

  private

  def process_transition
    _transition = transition.to_sym
    self.transition = nil
    if state_events.include?(_transition)
     fire_state_event(_transition)
    end
  end
end
