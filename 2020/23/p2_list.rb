def target_from(val, max)
  val - 1 == 0 ? max : val - 1
end

def print_list(current_val, list)
  initial_ind = current_val
  rep = current_val.to_s
  ind = list[initial_ind]
  until list[ind].nil? || ind == initial_ind
    rep += ind.to_s
    ind = list[ind]
  end
  puts rep
end

##$timings = Hash.new(0)

##started = Time.now
input = File.open("input").lines.first.chomp.chars.map(&:to_i)
nodes = []
max_val = nil
first_val = nil
last_val = nil
input.each do |val|
  max_val = val if max_val.nil? || val > max_val
  first_val ||= val
  if last_val
    nodes[last_val] = val
  end

  last_val = val
end
((max_val + 1)..1000000).each do |val|
  nodes[last_val] = val
  last_val = val
end
max_val = 1000000
nodes[last_val] = first_val
#$timings[:setup] = Time.now - #started

game_loop = Time.now
current_val = first_val
10000000.times do |_|
  #started = Time.now
  moving_val = nodes[current_val]
  moving_values = [moving_val]
  new_next = moving_val
  2.times do |_|
    new_next = nodes[new_next]
    moving_values << new_next
  end
  #$timings[:move_selection] += Time.now - #started

  #started = Time.now
  target_value = target_from(current_val, max_val)
  #$timings[:first_target] += Time.now - #started

  #started = Time.now
  until !moving_values.include?(target_value)
    target_value = target_from(target_value, max_val)
  end
  #$timings[:retargeting] += Time.now - #started

  #started = Time.now
  old_val = current_val
  current_val = nodes[old_val] = nodes[new_next]
  nodes[new_next] = nodes[target_value]
  nodes[target_value] = moving_val
  #$timings[:inserting] += Time.now - #started
end
#$timings[:game_loop] = Time.now - game_loop

after_one = nodes[1]
after_that = nodes[after_one]

puts #$timings
puts "After one comes #{after_one} and #{after_that} == #{after_one * after_that}"
