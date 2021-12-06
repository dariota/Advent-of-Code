def solve(initial, days_to_simulate)
  current_day = [0] * 9

  initial.each { |remaining| current_day[remaining] += 1 }

  days_to_simulate.times do |count|
    next_day = [0] * 9
    (0..8).each do |day|
      next_day[day] = current_day[day + 1]
    end
    next_day[8] = current_day[0]
    next_day[6] += current_day[0]
    current_day = next_day
  end

  puts current_day.sum
end

def problem_1(initial)
  solve(initial, 80)
end

def problem_2(initial)
  solve(initial, 256)
end

input = File.readlines("input", chomp: true).first.split(",").map(&:to_i)
puts "Problem 1: #{problem_1(input)}"
puts "Problem 2: #{problem_2(input)}"
