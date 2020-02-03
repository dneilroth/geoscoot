FactoryBot.define do
  factory :scooter do
    lonlat { "Point(-122.431297 37.773972)" }
    battery { 100 }
  end
end
