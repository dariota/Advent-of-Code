started = Time.now

input = File.open("input").lines.map(&:chomp)
instructions = input.map { |instruction| instruction.split(" ") }

def walk(instructions, index, accumulator, seen_indices, swapped = false)
  return [accumulator] if index == instructions.size
  return [nil] if seen_indices.key?(index)

  solutions = []
  instruction = instructions[index].first
  increment = instructions[index].last.to_i

  seen_indices[index] = nil
  if instruction == "acc"
    solutions.concat(walk(
      instructions,
      index + 1,
      accumulator + increment,
      seen_indices,
      swapped,
    ))
  elsif instruction == "nop"
    solutions.concat(walk(
      instructions,
      index + 1,
      accumulator,
      seen_indices,
      swapped,
    ))
    unless swapped
      # jmp solution
      solutions.concat(walk(
        instructions,
        index + increment,
        accumulator,
        seen_indices,
        true,
      ))
    end
  else
    solutions.concat(walk(
      instructions,
      index + increment,
      accumulator,
      seen_indices,
      swapped,
    ))
    unless swapped
      solutions.concat(walk(
        instructions,
        index + 1,
        accumulator,
        seen_indices,
        true,
      ))
    end
  end

  seen_indices.delete(index)
  solutions.compact
end

#puts walk(instructions, 0, 0, {})
puts Time.now - started
