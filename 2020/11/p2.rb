started = Time.now

input = File.open("input").lines.map(&:chomp)

# true for seat, false for floor
floor_map = input.map { |row| row.chars.map { |tile| tile == "L" } }
height = floor_map.count
width = floor_map[0].count

# prebaked raycasts
visibility_map = {}
directions = [-1, 0, 1].product([-1, 0, 1]).reject { |incs| incs == [0, 0] }
floor_map.each_index do |row|
  visibility_map[row] = {}

  floor_map[row].each_index do |col|
    next unless floor_map[row][col]

    visible_seats = []

    directions.each do |row_inc, col_inc|
      curr_col, curr_row = col + col_inc, row + row_inc

      while (0...width).cover?(curr_col) && (0...height).cover?(curr_row)
        if floor_map[curr_row][curr_col]
          visible_seats << [curr_row, curr_col]
          break
        end
        curr_col += col_inc
        curr_row += row_inc
      end
    end
    
    visibility_map[row][col] = visible_seats
  end
end

# true for occupied seat, false otherwise
occupancy_map = (1..height).map { |_| (1..width).map { |_| false } }
# number of adjacent occupied seats
adjacency_map = (1..height).map { |_| (1..width).map { |_| 0 } }
initial_seats_occupied = nil
final_seats_occupied = 0

def adjust_adjacency(adjacency_map, row, col, increment, visibility_map)
  visibility_map[row][col].each do |visible_row, visible_col|
    adjacency_map[visible_row][visible_col] += increment
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
        next unless adjacency_map[row][col] >= 5

        occupancy_map[row][col] = false
        adjust_adjacency(next_adjacency_map, row, col, -1, visibility_map)
      else # it's empty
        # if there are any adjacent occupied seats we do nothing
        next unless adjacency_map[row][col].zero?

        occupancy_map[row][col] = true
        adjust_adjacency(next_adjacency_map, row, col, 1, visibility_map)
      end
    end
  end

  adjacency_map = next_adjacency_map

  final_seats_occupied = 0
  occupancy_map.each { |row| row.each { |seat| final_seats_occupied += 1 if seat } }
end

puts Time.now - started

#puts iter
#puts final_seats_occupied
