require 'set'
require '../shared/grid.rb'

# Manhattan distance
def heuristic(cell, target)
  target.row - cell.row + target.col - cell.col
end

# A*, adapted from Wikipedia
def find_path(start, target)
  start.val[:path_cost] = 0

  # This will be built up as a array sorted in descending order. It's essentially a min-heap, where
  # the min is always the last value in the array, optimising its deletion (so we don't have to
  # shift the entire array over every time).
  candidates = [start]

  iterations = 0
  until candidates.empty?
    current = candidates.delete_at(candidates.length - 1)
    return if current == target

    current.each_adjacent(include_diagonal: false) do
      new_path_cost = current.val[:path_cost] + val[:cost]
      if val[:path_cost].nil? || new_path_cost < val[:path_cost]
        val[:path_cost] = new_path_cost
        val[:predecessor] = current

        # Here we find where to insert this value to keep the array sorted correctly.
        ind = candidates.bsearch_index { |cell| new_path_cost > cell.val[:path_cost] }
        candidates.insert(ind || candidates.length, self)
      end
    end
  end

  raise "No path found"
end

def solve(grid)
  dimensions = grid.dimensions
  start = grid.at(row_ind: 0, col_ind: 0)
  target = grid.at(row_ind: dimensions[:rows] - 1, col_ind: dimensions[:columns] - 1)

  find_path(start, target)

  target.val[:path_cost]
end

def problem_1(board)
  solve(Grid.new(board))
end

def problem_2(board)
  # I hate this tiling code.

  # tile horizontally
  horizontally_tiled = []
  board.each do |row|
    new_row = []
    5.times do |i|
      new_row.concat(
        row.map do |hsh|
          new_cost = (hsh[:cost] + i) % 9
          new_cost = 9 if new_cost.zero?
          { cost: new_cost }
        end
      )
    end
    horizontally_tiled << new_row
  end

  # tile vertically
  new_board = []
  5.times do |i|
    horizontally_tiled.each do |row|
      new_board << row.map do |hsh|
        new_cost = (hsh[:cost] + i) % 9
        new_cost = 9 if new_cost.zero? 
        { cost: new_cost }
      end
    end
  end

  solve(Grid.new(new_board))
end

board = File.readlines("input", chomp: true).map { |line| line.split("").map(&:to_i).map { |cost| { cost: cost } } }

puts "Problem 1: #{problem_1(board)}"
puts "Problem 2: #{problem_2(board)}"
