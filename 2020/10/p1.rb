input = File.open("small_input").lines.map(&:to_i)

previous = 0
distribution = Hash.new(0)
distribution[3] += 1
input.sort.each do |number|
  distribution[number - previous] += 1
  previous = number
end

puts distribution
puts distribution.values.product
