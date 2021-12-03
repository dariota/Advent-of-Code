raw_input = File.readlines("input", chomp: true)
bin_len = raw_input[0].length
input = raw_input.map { |num| num.to_i(2) }

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

puts "Problem 1: #{gamma * epsilon}"
