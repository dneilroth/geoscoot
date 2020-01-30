class Lock < ApplicationRecord
  belongs_to :scooter
  has_paper_trail

  before_destroy :set_unlocked_at

  def set_unlocked_at
    self.unlocked_at = Time.now
    save!
  end
end
