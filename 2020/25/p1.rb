def cycle(initial, subject)
  (initial * subject) % 20201227
end

targets = {}
keys = File.open("input").lines.map(&:to_i)
# this should start at 1
# does the subject number vary?
current = 1
# Apparently the initial value counts as one loop
loop_count = 0
until targets.size == keys.length
  loop_count += 1
  current = cycle(current, 7)
  keys.each do |key|
    if key == current
      targets[key] ||= loop_count
    end
  end
end

_, loops = targets.min_by(&:last)
key, _ = targets.max_by(&:last)
shared_key = 1

loops.times do |_|
  shared_key = cycle(shared_key, key)
end

puts shared_key
