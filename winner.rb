yao = {}
run_array = []
laps = {1 => [], 2 => [], 3 => [], 4 => [], 5 => []}

max_occurrence = 1
per_lap_count = 0

File.open('2016-stxc-kids-cat2.txt').each do |line|
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
  puts lap.join "\n"
end
