input = File.open("input").lines.map(&:chomp).map(&:to_i)
preamble_length = 25

def remove(number, others, sums)
  others.each { |other| sums[number + other] = sums[number + other] - 1 }
end

def add(number, others, sums)
  others.each { |other| sums[number + other] = sums[number + other] + 1 }
end

sums = Hash.new(0)
numbers = input.slice(0, preamble_length)
numbers.each_index do |index|
  number = numbers[index]
  add(number, numbers[(index + 1)..-1], sums)
end

invalid_numbers = []
input[preamble_length..-1].each do |number|
  invalid_numbers << number if sums[number].zero?

  removed = numbers.slice!(0)
  remove(removed, numbers, sums)
  add(number, numbers, sums)
  numbers << number
end

raise "wrong number of invalid numbers" unless invalid_numbers.count == 1
invalid_number = invalid_numbers.first
puts invalid_number
