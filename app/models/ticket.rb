class Ticket < ApplicationRecord
  has_paper_trail
  belongs_to :scooter
end
