class Scooter < ApplicationRecord
  include AASM
  has_paper_trail
  has_one :lock
  has_many :tickets

  validates :battery, inclusion: { in: (0..100) }

  aasm whiny_transitions: false, column: :state do
    state :locked, initial: true
    state :unlocked, :maintenance

    event :unlock do
      transitions from: [:locked, :maintenance], to: :unlocked, success: :remove_lock
    end

    event :maintain do
      transitions from: [:locked, :unlocked], to: :maintenance
    end

    event :lock_up do
      transitions from: [:unlocked, :maintenance], to: :locked
    end
  end

  def remove_lock
    lock&.destroy!
  end

  def can_unlock?
    maintenance? || locked?
  end
end
