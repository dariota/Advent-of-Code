test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def max_wins(time, distance)
  a = -1
  b = time
  c = -distance
  discriminant = Math.sqrt(b * b - 4 * a * c)
  denominator = 2 * a
  min_hold = ((-b + discriminant) / denominator).next_float.ceil
  max_hold = ((-b - discriminant) / denominator).prev_float.floor

  max_hold - min_hold + 1
end

def solution_1(input)
  def get_ints(line)
    line.split(/\s+/)[1..].map(&:to_i)
  end

  times = get_ints(input[0])
  distances = get_ints(input[1])
  races = times.zip(distances)

  races.map do |time, distance|
    max_wins(time, distance)
  end.reduce(:*)
end

def solution_2(input)
  def get_int(line)
    line.gsub(" ", "").split(":")[1].to_i
  end

  time = get_int(input[0])
  distance = get_int(input[1])
  max_wins(time, distance)
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
