started = Time.now
input = File.open("input").lines.map(&:chomp).map(&:to_i)

sorted = input.sort
found = false
left = 0
right = sorted.size - 1
until found
  intermediate = sorted[left] + sorted[right]
  target = 2020 - intermediate
  nearest = sorted.bsearch { |x| x >= target }
  if nearest == target && nearest != left && nearest != right
    #puts sorted[left] * sorted[right] * nearest
    found = true
  end

  if target < sorted[left]
    right -= 1
  else
    left += 1
  end

  raise "too far" if left >= right
end

puts Time.now - started
