class Scooter < ApplicationRecord
  include AASM
  has_many :transitions
  has_many :tickets

  validates :battery, inclusion: { in: (0..100) }
  FROM_STATE_EVENT_MAP = {
    locked: :lock!,
    unlocked: :unlock!,
    maintenance: :maintain,
  }.freeze

  aasm whiny_transitions: false, column: :state do
    state :locked, initial: true
    state :unlocked, :maintenance, :updating

    after_all_transitions :log_transition

    event :unlock do
      transitions from: [:updating, :locked, :maintenance], to: :unlocked
    end

    event :maintain do
      transitions from: [:updating, :locked, :unlocked], to: :maintenance
    end

    event :lock do
      transitions from: [:updating, :unlocked, :maintenance], to: :locked
    end

    event :update_data do
      transitions from: [:unlocked, :maintenance, :locked],
                  to: :updating,
                  after: :return_to_previous_state
    end
  end

  def log_transition
    transitions.create!(
      event: aasm.current_event,
      from: aasm.from_state,
      to: aasm.to_state,
      battery: battery,
      lonlat: lonlat
    )
  end

  def return_to_previous_state
    byebug
    send(FROM_STATE_EVENT_MAP[aasm.from_state])
  end
end
