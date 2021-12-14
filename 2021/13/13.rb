require 'set'

input = File.readlines("input", chomp: true)
positions = Set.new(input.select { |line| line.include?(",") }.map { |line| line.split(",").map(&:to_i) })
folds = input.select { |line| line.include?("fold") }.map { |line| line.split("along ")[1].split("=") }

def fold(board, axis, position)
  new_board = Set.new

  if axis == "x"
    board.each do |x, y|
      raise "point on fold" if x == position

      new_x = (x < position) ? x : position - (x - position)
      new_board.add([new_x, y])
    end
  else
    board.each do |x, y|
      raise "point on fold" if y == position

      new_y = (y < position) ? y : position - (y - position)
      new_board.add([x, new_y])
    end
  end

  new_board
end

def display(board)
  max_y = board.map(&:last).max
  max_x = board.map(&:first).max

  (0..max_y).each do |y|
    (0..max_x).each do |x|
      if board.include?([x,y])
        print "#"
      else
        print " "
      end
    end
    puts ""
  end
end

def problem_1(positions, folds)
  fold = folds.first
  fold(positions, fold.first, fold.last.to_i).count
end

def problem_2(positions, folds)
  board = positions

  folds.each do |axis, position|
    board = fold(board, axis, position.to_i)
  end

  display(board)
end

puts "Problem 1: #{problem_1(positions, folds)}"
puts "Problem 2:"
problem_2(positions, folds)
