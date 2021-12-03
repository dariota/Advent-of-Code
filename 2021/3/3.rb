require 'set'

def problem_1(input, bin_len)
  masks = (0...bin_len).map { |shift| 1 << shift }
  # numbers of zeros for each mask
  counts = [0] * bin_len
  input.each do |num|
    masks.each_with_index do |mask, index|
      if (mask & num).zero?
        counts[index] += 1
      end
    end
  end

  # how many times a number has to appear before it's in the gamma
  number_threshold = input.count / 2
  gamma = 0
  counts.each_with_index do |count, index|
    if count < number_threshold
      gamma |= masks[index]
    end
  end
  epsilon = ~gamma & masks.reduce(&:|)

  gamma * epsilon
end

def problem_2(input, bin_len)
  def count_zeroes(input, mask)
    input.select { |input| (input & mask).zero? }.count
  end

  oxygen_values = input.dup
  masks = (0...bin_len).map { |shift| 1 << shift }.reverse

  until oxygen_values.count == 1
    mask = masks.delete_at(0)
    bit_criteria = if count_zeroes(oxygen_values, mask) > oxygen_values.count / 2
      0
    else
      mask
    end
    oxygen_values.select! { |value| value & mask == bit_criteria }
  end

  masks = (0...bin_len).map { |shift| 1 << shift }.reverse
  co2_values = input.dup
  until co2_values.count == 1
    mask = masks.delete_at(0)
    bit_criteria = if count_zeroes(co2_values, mask) <= co2_values.count / 2
      0
    else
      mask
    end
    co2_values.select! { |value| value & mask == bit_criteria }
  end

  co2_values.first * oxygen_values.first
end

raw_input = File.readlines("input", chomp: true)
bin_len = raw_input[0].length
input = raw_input.map { |num| num.to_i(2) }

puts "Problem 1: #{problem_1(input, bin_len)}"
puts "Problem 2: #{problem_2(input, bin_len)}"
