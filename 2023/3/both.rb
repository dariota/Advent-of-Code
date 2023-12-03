require 'set'

input = File.readlines("input", chomp: true)

def solution_1(input, adjacencies)
  result = 0

  input.each_with_index do |line, row|
    last_col = line.index(/\d/)

    until last_col.nil?
      num = line[last_col..].to_i
      num_len = num.to_s.length
      if (last_col...last_col + num_len).any? { |col| adjacencies.include?([row, col]) }
        result += num
      end

      last_col = line.index(/\d/, last_col + num_len)
    end
  end

  result
end

def solution_2(input, adjacencies)
  ratios = Hash.new { |hsh, k| hsh[k] = [] }

  input.each_with_index do |line, row|
    last_col = line.index(/\d/)
    until last_col.nil?
      positions = Set.new

      num = line[last_col..].to_i
      num_len = num.to_s.length
      (last_col...last_col + num_len).each do |col_a|
        positions.add(adjacencies[[row, col_a]])
      end
      positions.reject(&:nil?).each { |v| ratios[v].push(num) }

      last_col = line.index(/\d/, last_col + num_len)
    end
  end

  ratios.select { |_, v| v.length == 2 }.sum { |_, v| v.reduce(:*) }
end

# Positions adjacent to a symbol
adjacencies = Set.new
# Position adjacent to a gear => gear position
gear_adjacencies = {}

input.each_with_index do |line, row|
  line.chars.each_with_index do |char, col|
    if char != '.' and not ('0'..'9').cover?(char)
      (row-1..row+1).each do |row_a|
        (col-1..col+1).each do |col_a|
          adjacencies.add([row_a, col_a])
          gear_adjacencies[[row_a, col_a]] = [row, col] if char == '*'
        end
      end
    end
  end
end

puts "Problem 1: #{solution_1(input, adjacencies)}"
puts "Problem 2: #{solution_2(input, gear_adjacencies)}"
