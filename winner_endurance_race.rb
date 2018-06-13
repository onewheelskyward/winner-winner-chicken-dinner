require 'sequel'
require 'pg'

DB = Sequel.connect('postgres://root:b01762cfbe4ab3de@portlandracing.c6aanljryr7p.us-west-2.rds.amazonaws.com:5432/winnerwinner') # Uses the postgres adapter

racer_laps_by_plate_number = {}
run_array = []
laps = {1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [], 8 => [], 9 => [], 10 => [], 11 => [], 12 => [], 13 => [], 14 => [], 15 => []}

max_occurrence = 1
per_lap_count = 0

unless ARGV.count == 2
  puts 'Usage: winner.rb cat2.txt 2'
  exit 1
end

# Open up the results file (plate numbers, one per line)

File.open(ARGV[0]).each_with_index do |line, index|
  plate_number = line.chomp
  unless racer_laps_by_plate_number[plate_number]
    racer_laps_by_plate_number[plate_number] = 0
  end
  racer_laps_by_plate_number[plate_number] += 1
  per_lap_count += 1
  laps[racer_laps_by_plate_number[plate_number]].push plate_number

  if racer_laps_by_plate_number[plate_number] > max_occurrence
    max_occurrence += 1
    run_array.push "Lap #{max_occurrence} (#{per_lap_count} riders)"
    per_lap_count = 0
  end
  run_array.push "#{plate_number} occurrence #{racer_laps_by_plate_number[plate_number]}"
end

puts racer_laps_by_plate_number.inspect
puts run_array.join("\n")

printed = {}

laps.keys.sort.reverse.each do |key|
  # puts lap.join "\n"
  # puts "Lap #{key}, #{laps[key].count} riders"
  laps[key].each do |rider_num|
    query = "SELECT name, plate_number, racing_age FROM racers where plate_number = #{rider_num} and category = #{ARGV[1]}"
    name = ''
    age = ''
    DB.fetch(query) do |row|
      name = "#{row[:first_name]} #{row[:last_name][0]}"
      age = row[:racing_age]
    end
    puts "#{rider_num},#{name},#{age},#{key}" unless printed[rider_num]
    printed[rider_num] = true
  end
end
