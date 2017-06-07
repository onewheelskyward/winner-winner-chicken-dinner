require 'sequel'
require 'pg'


yao = {}
run_array = []
laps = {1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [], 8 => [], 9 => [], 10 => []}

max_occurrence = 1
per_lap_count = 0

unless ARGV.count == 2
  puts 'Usage: winner.rb cat2.txt 2'
  exit 1
end

# Open up the results file (plate numbers, one per line)

File.open(ARGV[0]).each_with_index do |line, index|
  num = line.chomp
  unless yao[num]
    yao[num] = 0
  end
  yao[num] += 1
  per_lap_count += 1
  laps[yao[num]].push num

  if yao[num] > max_occurrence
    max_occurrence += 1
    run_array.push "Lap #{max_occurrence} (#{per_lap_count} riders)"
    per_lap_count = 0
  end
  run_array.push "#{num} occurrence #{yao[num]}"
end

puts yao.inspect
puts run_array.join("\n")

laps.each do |k, lap|
  puts "Lap #{k}, #{lap.count} riders"
  # puts lap.join "\n"
  lap.each do |rider_num|
    print rider_num
    query = "SELECT first_name, last_name, plate_number, racing_age FROM racers where plate_number = #{rider_num} and category = #{ARGV[1]}"
    DB.fetch(query) do |row|
      print ",#{row[:first_name]} #{row[:last_name][0]},#{row[:racing_age]}"
    end
    puts
  end
end
