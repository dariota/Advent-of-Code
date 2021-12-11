require '../shared/grid.rb'

def problem_1(grid)
  risk = 0

  grid.each_cell do
    if each_adjacent(include_diagonal: false).all? { |other| other.val > val }
      risk += val + 1
    end
  end

  risk
end

# This is simpler than the problem as stated. All non-9 values are necessarily in a basin, so
# there's no need to check whether a number is adjacent to numbers in a basin, we just need to
# find all numbers that are enclosed by board boundaries or 9s.
def problem_2(grid)
  def find_basin(grid, cell, visited)
    visited.at(row_ind: cell.row, col_ind: cell.col) do
      return 0 if val

      self.val = true
    end
    return 0 if cell.val == 9

    1 + cell.each_adjacent(include_diagonal: false).map { |other| find_basin(grid, other, visited) }.sum
  end

  # The more natural [[false] * board.first.length] * board.length creates multiple copies of the
  # same array, such that visiting the first column of the first row visits the first column of all
  # rows.
  visited = grid.indicator_board

  basin_sizes = []
  grid.each_cell do
    next if visited.at(row_ind: row, col_ind: col).val

    basin_sizes << find_basin(grid, self, visited)
  end

  basin_sizes.sort.last(3).reduce(:*)
end

board = Grid.new(File.readlines("input", chomp: true).map { |line| line.split("").map(&:to_i) })

puts "Problem 1: #{problem_1(board)}"
puts "Problem 2: #{problem_2(board)}"
