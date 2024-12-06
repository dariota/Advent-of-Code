test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def solution_1(input)
  re = /(mul\(\d{1,3},\d{1,3}\))/
  input.sum { |line| line.scan(re).map { |matches| matches[0].sub("mul(", "").sub(")", "").split(",").map(&:to_i).reduce(:*) }.sum }
end

def solution_2(input)
  enabled = true
  re = /(mul\(\d{1,3},\d{1,3}\))|(do\(\))|(don't\(\))/
  input.sum { |line| line.scan(re).map { |matches|
    if not matches[0].nil? and enabled then
      matches[0].sub("mul(", "").sub(")", "").split(",").map(&:to_i).reduce(:*)
    elsif not matches[1].nil? then
      enabled = true
      0
    elsif not matches[2].nil? then
      enabled = false
      0
    else
      0
    end
  }.sum }
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"

puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
