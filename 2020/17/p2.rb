input = File.open("input").lines.map(&:chomp)

map = {}
map[0] ||= {}
input.each_index do |y|
  map[0][0] ||= {}

  input[y].chars.each_index do |x|
    map[0][0][y] ||= {}
    if input[y][x] == "#"
      map[0][0][y][x] = true
    end
  end
end

diffs = [1, 0, -1].product([1, 0, -1]).product([1, 0, -1]).map { |lst| lst.flatten }.product([1, 0, -1]).map { |lst| lst.flatten }.reject { |lst| lst.uniq == [0] }

last_map = map
next_map = {}
cycles_run = 0
until cycles_run == 6
  adjacency_map = {}
  last_map.each do |w, row_w|
    w_row = last_map[w]
    w_row.each do |z, row_y|
      z_row = w_row[z]
      z_row.each do |y, row_x|
        y_row = z_row[y]
        y_row.each do |x, x_val|
          diffs.each do |w_inc, z_inc, y_inc, x_inc|
            adjacency_map[w + w_inc] ||= {}
            adjacency_map[w + w_inc][z + z_inc] ||= {}
            adjacency_map[w + w_inc][z + z_inc][y + y_inc] ||= {}
            adjacency_map[w + w_inc][z + z_inc][y + y_inc][x + x_inc] ||= 0
            adjacency_map[w + w_inc][z + z_inc][y + y_inc][x + x_inc] += 1
          end
        end
      end
    end
  end

  adjacency_map.each do |w, row_w|
    w_row = adjacency_map[w]
    w_row.each do |z, row_z|
      z_row = w_row[z]
      z_row.each do |y, row_x|
        y_row = z_row[y]
        y_row.each do |x, x_val|
          next_map[w] ||= {}
          next_map[w][z] ||= {}
          next_map[w][z][y] ||= {}

          if last_map[w] && last_map[w][z] && last_map[w][z][y] && last_map[w][z][y][x]
            next_map[w][z][y][x] = true if x_val == 2 || x_val == 3
          else
            next_map[w][z][y][x] = true if x_val == 3
          end
        end
      end
    end
  end

  last_map = next_map
  next_map = {}
  cycles_run += 1
end

active_cells = 0
last_map.each do |_, row_z|
  row_z.each do |_, row_y|
    row_y.each do |_, row_x|
      row_x.each do |_, _|
        active_cells += 1
      end
    end
  end
end

puts active_cells
