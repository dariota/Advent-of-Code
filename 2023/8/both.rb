require 'set'

test_input = File.readlines("input.test", chomp: true)
test_input_2 = File.readlines("input_2.test", chomp: true)
input = File.readlines("input", chomp: true)

def solution_1(input)
  directions = input[0].chars.map { |c| c == 'L' ? 0 : 1 }
  nodes = input[2..].each_with_object({}) do |line, acc|
    parts = /(\w+) = \((\w+), (\w+)\)/.match(line)
    acc[parts[1]] = [parts[2], parts[3]]
  end
  node = 'AAA'
  steps = 0
  directions.cycle do |dir|
    node = nodes[node][dir]
    steps += 1
    return steps if node == 'ZZZ'
  end
end

def solution_2(input)
  directions = input[0].chars.map { |c| c == 'L' ? 0 : 1 }
  nodes = input[2..].each_with_object({}) do |line, acc|
    parts = /(\w+) = \((\w+), (\w+)\)/.match(line)
    acc[parts[1]] = [parts[2], parts[3]]
  end
  current_nodes = nodes.keys.select { |node| node[2] == 'A' }
  nodes_to_z = current_nodes.each_with_object({}) do |node, acc|
    steps_to_z = Set.new
    positions_seen = Set.new
    steps = 0
    current_node = node
    directions.zip((0..).take(directions.length)).cycle do |dir, index|
      # Check if we're in a loop
      current_position = [current_node, index]
      break if positions_seen.include?(current_position)
      positions_seen.add(current_position)

      # Add the steps it took to get here if we're on a Z node
      steps_to_z.add(steps) if current_node[2] == 'Z'

      # Advance
      current_node = nodes[current_node][dir]
      steps += 1
    end
    acc[node] = steps_to_z
  end

  # This isn't generalisable, but works for my input (and, I would bet, all AoC inputs)
  # Specifically, suppose you had one node that reaches the end in 3 or 5 steps, and
  # another that reaches it every 2 steps. The correct answer is 6, the LCM of 3 and 5,
  # but this will find 30, the LCM of 2, 3, and 5.
  #
  # To make it generalisable, you'd need to find the lowest possible LCM constructed
  # from each combination of steps (e.g. LCM 2,3 == 6, LCM 2,5 == 10, so the answer is 6).
  nodes_to_z.values.flat_map(&:to_a).reduce(1, :lcm)
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input_2)}"
puts "Problem 2: #{solution_2(input)}"
