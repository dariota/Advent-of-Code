input = File.open("input").lines.map(&:chomp)

started = Time.now

# true for seat, false for floor
floor_map = input.map { |row| row.chars.map { |tile| tile == "L" } }
height = floor_map.count
width = floor_map[0].count

# true for occupied seat, false otherwise
occupancy_map = (1..height).map { |_| (1..width).map { |_| false } }
# number of adjacent occupied seats
adjacency_map = (1..height).map { |_| (1..width).map { |_| 0 } }
initial_seats_occupied = nil
final_seats_occupied = 0

def adjust_adjacency(adjacency_map, row, col, height, width, increment)
  (row - 1..row + 1).each do |marked_row|
    next if marked_row < 0 || marked_row >= height
    (col - 1..col + 1).each do |marked_col|
      next if marked_col < 0 || marked_col >= width
      next if marked_col == col && marked_row == row

      adjacency_map[marked_row][marked_col] += increment
    end
  end
end

iter = 0
until final_seats_occupied == initial_seats_occupied
#  puts "Iteration #{iter}:"
#  floor_map.each_index do |row|
#    row_desc = ""
#    floor_map[row].each_index do |col|
#      if floor_map[row][col]
#        row_desc += occupancy_map[row][col] ? "#" : "L"
#      else
#        row_desc += "."
#      end
#    end
#    puts row_desc
#  end
#  gets
#
#  floor_map.each_index do |row|
#    puts adjacency_map[row].map(&:to_s).join("")
#  end
#  gets
#
  iter += 1

  initial_seats_occupied = final_seats_occupied

  next_adjacency_map = adjacency_map.map(&:dup)

  adjacency_map.each_index do |row|
    adjacency_map[row].each_index do |col|
      # if it's floor, we do nothing
      next unless floor_map[row][col]

      # when occupied, we try to remove occupancy if needed
      if occupancy_map[row][col]
        # if there are few enough adjacent seats occupied we do nothing
        next unless adjacency_map[row][col] >= 4

        occupancy_map[row][col] = false
        adjust_adjacency(next_adjacency_map, row, col, height, width, -1)
      else # it's empty
        # if there are any adjacent occupied seats we do nothing
        next unless adjacency_map[row][col].zero?

        occupancy_map[row][col] = true
        adjust_adjacency(next_adjacency_map, row, col, height, width, 1)
      end
    end
  end

  adjacency_map = next_adjacency_map

  final_seats_occupied = 0
  occupancy_map.each { |row| row.each { |seat| final_seats_occupied += 1 if seat } }
end

puts Time.now - started

puts iter
puts final_seats_occupied
