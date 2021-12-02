input = File.open("input").lines.map(&:to_i)
started = Time.now

numbers = [0]
numbers.concat(input.sort).push(input.max + 3)

paths = Hash.new(0)
paths[0] = 1
numbers.each_index do |index|
  current_number = numbers[index]
  max_reach = current_number + 3
  entrance_paths = paths[current_number]
  reachable_index = index + 1
  reachable_number = numbers[reachable_index]
  until !reachable_number || reachable_number > max_reach
    paths[reachable_number] += entrance_paths
    reachable_index += 1
    reachable_number = numbers[reachable_index]
  end
end

ended = Time.now
puts paths[numbers.max]
puts ended - started
