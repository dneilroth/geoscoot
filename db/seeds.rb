# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Scooter.find_or_create_by!(lonlat: 'Point(-122.4 37)', battery: 100)
Scooter.find_or_create_by!(lonlat: 'Point(-122.5 37)', battery: 95)
Scooter.find_or_create_by!(lonlat: 'Point(-122.6 37)', battery: 90)
Scooter.find_or_create_by!(lonlat: 'Point(-122.7 37)', battery: 80)
scooter = Scooter.find_or_create_by!(lonlat: 'Point(-122.8 37)', battery: 50)
scooter.unlock!
scooter.maintain!
scooter.update_data({ lat: 36, lon: -122, battery: 50 })
scooter.lock!
