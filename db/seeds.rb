# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
teams=[
  {name: "a", rating: 9},
  {name: "b", rating: 8},
  {name: "c", rating: 9},
  {name: "d", rating: 6},
  {name: "e", rating: 7}
]
p "Inserting seed data - #{teams.length} teams"
Team.create!(teams)
p "Inserted seed data"
