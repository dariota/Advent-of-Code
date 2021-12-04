class Board
  def initialize
    @numbers = []
    @marked = []
    @value = 0
  end

  def won?
    @marked.any? { |row| row.all? } ||
      (0...@marked.length).any? { |col| @marked.map { |row| row[col] }.all? }
  end

  def mark(called)
    iter do |row_ind, col_ind, val|
      return @marked[row_ind][col_ind] = true if called == val
    end
  end

  def value
    iter.map do |row_ind, col_ind, val|
      @marked[row_ind][col_ind] ? 0 : val
    end.reduce(:+)
  end

  def add_row(row)
    @numbers << row
    @marked << [false] * row.count
  end

  private def iter
    return enum_for(__callee__) unless block_given?

    @numbers.each_with_index do |row, row_ind|
      row.each_with_index do |num, col_ind|
        yield(row_ind, col_ind, num)
      end
    end
  end
end

def problem_1(boards, called)
  called.each do |num|
    boards.each do |board|
      board.mark(num)
      return num * board.value if board.won?
    end
  end

  nil
end

def problem_2(boards, called)
  called.each do |num|
    boards.each do |board|
      board.mark(num)
    end

    potential_board = boards.first
    boards.reject!(&:won?)
    return potential_board.value * num if boards.count.zero?
  end

  nil
end

input = File.readlines("input", chomp: true)
called = input.first.split(",").map(&:to_i)

boards = input[2..]
  .chunk { |line| line.empty? }
  .select { |chunk| !chunk.first }
  .map(&:last)
  .map { |rows| Board.new.tap { |board| rows.each { |row| board.add_row(row.split(" ").map(&:to_i)) } } }

puts "Problem 1: #{problem_1(boards, called)}"
# Intentionally not resetting board state because it doesn't matter
# Also not skipping already called numbers, because I'm lazy
puts "Problem 2: #{problem_2(boards, called)}"
