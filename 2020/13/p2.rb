started = Time.now

input = File.open("input").lines.map(&:chomp)

class Schedule
  attr_reader :time, :offset, :cong_offset
  
  def initialize(time, offset)
    @time = time.to_i
    @offset = offset
  end
end

times = input[1].split(",")
schedules = []
times.each_index do |ind|
  time = times[ind]
  next if time == "x"

  schedules << Schedule.new(time, ind)
end

congruency_pairs = schedules.map do |schedule|
  if schedule.offset.zero?
    [0, schedule.time]
  else
    [schedule.time - (schedule.offset % schedule.time), schedule.time]
  end
end

sorted_pairs = congruency_pairs.sort_by(&:last).reverse
initial, step = sorted_pairs.slice!(0)
sorted_pairs.each do |target, congruent_to|
  until initial % congruent_to == target
    initial += step
  end
  step *= congruent_to
end

#puts initial
puts Time.now - started
