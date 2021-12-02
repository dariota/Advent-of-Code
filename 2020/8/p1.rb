input = File.open("input").lines.map(&:chomp)
instructions = input.map { |instruction| instruction.split(" ") }

accumulator = 0
seen_indices = []
current_index = 0

until seen_indices.include?(current_index)
  seen_indices << current_index

  instruction = instructions[current_index].first
  increment = instructions[current_index].last.to_i

  if instruction == "nop"
    current_index += 1
  elsif instruction == "acc"
    accumulator += increment
    current_index += 1
  else
    current_index += increment
  end
end

puts accumulator
