def solve(initial, days_to_simulate)
  fish = [0] * 9
  initial.each { |remaining| fish[remaining] += 1 }

  days_to_simulate.times do |count|
    reset_fish = fish[0]
    fish.rotate!
    fish[6] += reset_fish
  end

  fish.sum
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
