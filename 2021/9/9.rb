def adjacent_positions(row_ind, col_ind, board)
  row_max = board.length
  col_max = board.first.length
  positions = []

  positions << [row_ind - 1, col_ind] unless row_ind.zero?
  positions << [row_ind + 1, col_ind] unless row_ind + 1 == row_max
  positions << [row_ind, col_ind - 1] unless col_ind.zero?
  positions << [row_ind, col_ind + 1] unless col_ind + 1 == col_max

  positions
end

def problem_1(board)
  risk = 0

  board.each_with_index do |row, row_ind|
    row.each_with_index do |val, col_ind|
      is_low_point = adjacent_positions(row_ind, col_ind, board).all? do |row_ind, col_ind|
        board[row_ind][col_ind] > val
      end

      if is_low_point
        risk += val + 1
      end
    end
  end

  risk
end

# This is simpler than the problem as stated. All non-9 values are necessarily in a basin, so
# there's no need to check whether a number is adjacent to numbers in a basin, we just need to
# find all numbers that are enclosed by board boundaries or 9s.
def problem_2(board)
  def find_basin(board, row_ind, col_ind, visited, indent=" ")
    return 0 if visited[row_ind][col_ind]

    visited[row_ind][col_ind] = true
    return 0 if board[row_ind][col_ind] == 9

    positions = adjacent_positions(row_ind, col_ind, board)
    1 + positions.map { |oth_row_ind, oth_col_ind| find_basin(board, oth_row_ind, oth_col_ind, visited, indent + " ") }.sum
  end

  # The more natural [[false] * board.first.length] * board.length creates multiple copies of the
  # same array, such that visiting the first column of the first row visits the first column of all
  # rows.
  visited = (0...board.length).map { [false] * board.first.length }

  basin_sizes = []
  board.each_with_index do |row, row_ind|
    row.each_with_index do |val, col_ind|
      next if visited[row_ind][col_ind]

      basin_sizes << find_basin(board, row_ind, col_ind, visited)
    end
  end

  basin_sizes.sort.last(3).reduce(:*)
end

board = File.readlines("input", chomp: true).map { |line| line.split("").map(&:to_i) }

puts "Problem 1: #{problem_1(board)}"
puts "Problem 2: #{problem_2(board)}"
