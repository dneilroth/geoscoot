class Scooter < ApplicationRecord
  include AASM
  has_many :transitions
  has_many :tickets
  scope :active, -> { where("battery > 30").where(state: :locked) }

  validates :battery, inclusion: { in: (0..100) }
  FROM_STATE_EVENT_MAP = {
    locked: :lock!,
    unlocked: :unlock!,
    maintenance: :maintain
  }.freeze

  aasm whiny_transitions: false, column: :state do
    state :locked, initial: true
    state :unlocked, :maintenance, :updating

    after_all_transitions :log_transition

    event :unlock do
      transitions from: [:updating, :locked], to: :unlocked
    end

    event :maintain do
      before do |ticket_params|
        tickets.create!(ticket_params)
      end

      transitions from: [:updating, :unlocked], to: :maintenance
    end

    event :lock do
      transitions from: [:updating, :unlocked], to: :locked
    end

    event :update_data do
      after do |update_obj|
        # update battery and location data
        if update_obj[:lon] && update_obj[:lat]
          lon = update_obj.delete(:lon)
          lat = update_obj.delete(:lat)
          update_obj[:lonlat] = "POINT(#{lon} #{lat})"
        end

        update_attributes(update_obj)
        # return to previous state
        send(FROM_STATE_EVENT_MAP[aasm.from_state])
      end

      transitions from: [:unlocked, :maintenance, :locked], to: :updating
    end
  end

  def self.find_active_scooters_within_kilometers(lon, lat, radius)
    active
      .where("ST_DWithin(lonlat, ST_MakePoint(#{lon}, #{lat})::geography, #{radius * 1000})")
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
end
