require 'set'

test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def solve(input, expansion_factor)
  galaxies = []
  occupied_rows = Set.new
  occupied_cols = Set.new
  input.each_with_index do |line, row|
    line.chars.each_with_index do |char, col|
      if char == '#'
        galaxies.append([row, col])
        occupied_rows.add(row)
        occupied_cols.add(col)
      end
    end
  end

  height = input.length
  width = input[0].length
  expanding_rows = (0...height).select { |i| !occupied_rows.include?(i) }
  expanding_cols = (0...width).select { |i| !occupied_cols.include?(i) }

  expansion_factor -= 1
  expanded_galaxies = galaxies.map do |row, col|
    [row + expanding_rows.count { |e| e < row } * expansion_factor, col + expanding_cols.count { |e| e < col } * expansion_factor]
  end
  # Cartesian product will pair the first and second galaxy, but also the second and first
  # so the distance will be doubled.
  # Rather than fix it, just divide by 2
  expanded_galaxies.product(expanded_galaxies).sum do |galaxy_1, galaxy_2|
    (galaxy_1[0] - galaxy_2[0]).abs + (galaxy_1[1] - galaxy_2[1]).abs
  end / 2
end

def solution_1(input)
  solve(input, 2)
end

def solution_2(input)
  solve(input, 1_000_000)
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
