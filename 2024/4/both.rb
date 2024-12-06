test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def traverse(grid, row_ind, col_ind, row_inc, col_inc, next_char='X')
  return false if row_ind >= grid.length || row_ind < 0
  return false if col_ind >= grid[row_ind].length || col_ind < 0

  return false if grid[row_ind][col_ind] != next_char

  next_col = col_ind + col_inc
  next_row = row_ind + row_inc
  case next_char
  when 'S'
    true
  when 'A'
    traverse(grid, next_row, next_col, row_inc, col_inc, 'S')
  when 'M'
    traverse(grid, next_row, next_col, row_inc, col_inc, 'A')
  when 'X'
    traverse(grid, next_row, next_col, row_inc, col_inc, 'M')
  else
    false
  end
end

def solution_1(input)
  grid = input.map(&:chars)
  count = 0
  (0...grid.length).each do |row_ind|
    (0...grid[row_ind].length).each do |col_ind|
      # This'll check 8 times if the current character is an X.
      # Whatever. Makes it easier to reuse in part 2.
      [-1, 0, 1].product([-1, 0, 1]).each do |row_inc, col_inc|
        count += 1 if traverse(grid, row_ind, col_ind, row_inc, col_inc)
      end
    end
  end
  count
end

def solution_2(input)
  grid = input.map(&:chars)
  count = 0
  (0...grid.length).each do |row_ind|
    (0...grid[row_ind].length).each do |col_ind|
      next if grid[row_ind][col_ind] != 'A'


      # Both Ms on the left or top
      if traverse(grid, row_ind - 1, col_ind - 1, 1, 1, 'M') && (traverse(grid, row_ind + 1, col_ind - 1, -1, 1, 'M') || traverse(grid, row_ind - 1, col_ind + 1, 1, -1, 'M')) ||
          # Both Ms on the right or bottom
          traverse(grid, row_ind + 1, col_ind + 1, -1, -1, 'M') && (traverse(grid, row_ind + 1, col_ind - 1, -1, 1, 'M') || traverse(grid, row_ind - 1, col_ind + 1, 1, -1, 'M'))
        count += 1
      end
    end
  end
  count
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"

puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
