require '../shared/grid.rb'

def find_flashes(grid)
  def update_cell(cell, flashed)
    return unless cell.val > 9

    newly_flashed = false
    flashed.at(row_ind: cell.row, col_ind: cell.col) do
      # If we've flashed already, we can stop
      return if val

      # Otherwise, mark that we've flashed and update adjacent
      self.val = true
      cell.each_adjacent(include_diagonal: true) do
        self.val += 1

        update_cell(self, flashed)
      end
    end
  end

  flashed = grid.indicator_board
  
  grid.each_cell do
    self.val += 1

    update_cell(self, flashed)
  end

  grid.each_cell do
    self.val = 0 if val > 9
  end

  flashed
end

def problem_1(grid)
  100.times.map do
    find_flashes(grid).each_cell.count(&:val)
  end.reduce(:+)
end

def problem_2(grid)
  (1..).each do |i|
    return i if find_flashes(grid).each_cell.all?(&:val)
  end
end

grid = Grid.new(File.readlines("input", chomp: true).map { |line| line.split("").map(&:to_i) })
puts "Problem 1: #{problem_1(grid)}"

# grid is modified in place, so just reload it
grid = Grid.new(File.readlines("input", chomp: true).map { |line| line.split("").map(&:to_i) })
puts "Problem 2: #{problem_2(grid)}"
