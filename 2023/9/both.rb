test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def solve(input, &blk)
  input.sum do |line|
    history = line.split(" ").map(&:to_i)
    diffs = []
    diff = history
    loop do
      diffs.append(diff)
      diff = diff.each_cons(2).map { |a, b| b - a }
      break if diff.all?(&:zero?)
    end
    target = 0
    diffs.reverse.reduce(0, &blk)
  end
end

def solution_1(input)
  solve(input) { |target, diff| diff[-1] + target }
end

def solution_2(input)
  solve(input) { |target, diff| diff[0] - target }
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
