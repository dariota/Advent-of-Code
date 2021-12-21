class InfiniteBoard
  # true is lit (fam)
  def initialize(board, out_of_bounds, lookup)
    @out_of_bounds = out_of_bounds
    @board = board
    @lookup = lookup.chars.map { |c| c == "#" }
  end

  def iterate
    new_oob = @out_of_bounds ? @lookup.last : @lookup.first
    new_board = (@board.length + 2).times.map do
      [false] * (@board.first.length + 2)
    end

    new_board.length.times do |row|
      new_board.first.length.times do |col|
        new_board[row][col] = @lookup[index_at(row - 1, col - 1)]
      end
    end

    @board = new_board
    @out_of_bounds = new_oob

    self
  end

  def lit_pixels
    @board.sum { |row| row.count(&:itself) }
  end

  def to_s
    @board.map { |row| row.map { |val| val ? "#" : "." }.join }.join("\n")
  end

  private def index_at(row, col)
    positions = (row-1..row+1).to_a.product((col-1..col+1).to_a)
    bits = positions.map do |row, col|
      if row < 0 || col < 0 || row >= @board.length || col >= @board.first.length
        @out_of_bounds
      else
        @board[row][col]
      end
    end
    bits.reduce(0) { |acc, bit| (acc << 1) | (bit ? 1 : 0) }
  end
end

def solve(iterations, board)
  iterations.times { board.iterate }
  board.lit_pixels
end

def problem_1(board)
  solve(2, board)
end

def problem_2(board)
  # already iterated twice in part 1
  solve(48, board)
end

input = File.readlines("input", chomp: true)
lookup = input.first
image = input[2..].map { |line| line.chars.map { |c| c == "#" } }

board = InfiniteBoard.new(image, false, lookup)

puts problem_1(board)
puts problem_2(board)
