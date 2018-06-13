require 'sequel'
require 'pg'

DB = Sequel.connect('postgres://postgres@localhost') # Uses the postgres adapter
category = 1
riders = []

riders.each do |rider|
  query = "SELECT name, plate_number, racing_age FROM racers where plate_number = #{rider_num} and category = #{category}"
  name = ''
  age = ''
  DB.fetch(query) do |row|
    name = row[:name]
    age = row[:racing_age]
  end
  puts "#{rider_num},#{name},#{age}"
end
