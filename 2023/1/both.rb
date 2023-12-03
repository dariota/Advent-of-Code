test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def solution_1(input)
  input.sum { |line|
    line.chars.find { |c|
      not c.to_i.zero?
    }.to_i * 10 + line.chars.reverse.find { |c|
      not c.to_i.zero?
    }.to_i
  }
end

def solution_2(input)
  digits = { "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9 }
  (1..9).each { |n| digits[n.to_s] = n }

  regexp = /(#{digits.keys.join("|")})/
  rev_regexp = /(#{digits.keys.map(&:reverse).join("|")})/

  input.sum { |line|
    digits[regexp.match(line)[1]] * 10 +
      digits[rev_regexp.match(line.reverse)[1].reverse]
  }
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"

puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
