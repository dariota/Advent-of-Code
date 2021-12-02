input = File.open("input").lines.map(&:chomp)

start = input[0].to_i
times = input[1].split(",").reject { |time| time == "x" }.map(&:to_i)

min_time = nil
min_time_id = nil
times.each do |time|
  time_left = time - (start % time)
  if min_time.nil? || min_time > time_left
    min_time = time_left
    min_time_id = time
  end
end

puts min_time * min_time_id
