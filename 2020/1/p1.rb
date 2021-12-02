input = File.open("input").lines.map(&:chomp).map(&:to_i)

sorted = input.sort
found = false
left = 0
right = sorted.size - 1
until found
  intermediate = sorted[left] + sorted[right]
  if intermediate > 2020
    right -= 1
  elsif intermediate < 2020
    left += 1
  else
    found = true
  end
  if left >= right
    raise "Too far"
  end
end

puts "#{sorted[left]}, #{sorted[right]}"
