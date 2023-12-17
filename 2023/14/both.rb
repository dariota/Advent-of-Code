require 'set'

test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def calculate_load(rocks, length)
  rocks.sum do |row, col|
    length - row
  end
end

def solve(input)
  part_1 = nil

  cache = {}
  directions = %i[north west south east]
  directions.each { |sym| cache[sym] = {} }

  rolls = []
  stops_by_col = Hash.new { |h,k| h[k] = [] }
  stops_by_row = Hash.new { |h,k| h[k] = [] }
  input.each_with_index do |line, row|
    line.chars.each_with_index do |char, col|
      if char == '#'
        stops_by_col[col].append(row)
        stops_by_row[row].append(col)
      elsif char == 'O'
        rolls.append([row, col])
      end
    end
  end

  # A bit of overkill when I was trying to actually just run all the cycles
  #  - A lookup from every non-# in the map to where it ends up after moving in
  #    any direction
  input.each_with_index do |line, row|
    line.chars.each_with_index do |char, col|
      next if char == '#'

      cache[:north][[row, col]] = [stops_by_col[col].select { |r| r < row }.max || -1, col]
      cache[:south][[row, col]] = [stops_by_col[col].select { |r| r > row }.min || input.length, col]
      cache[:west][[row, col]] = [row, stops_by_row[row].select { |c| c < col }.max || -1]
      cache[:east][[row, col]] = [row, stops_by_row[row].select { |c| c > col }.min || input[0].length]
    end
  end

  direction_offsets = {
    north: [1, 0],
    west: [0, 1],
    south: [-1, 0],
    east: [0, -1],
  }
  seen_states = {}
  loops_done = 0
  loops_to_do = 4_000_000_000
  until loops_done == 4_000_000_000
    direction_offsets.each do |direction, offsets|
      hits = Hash.new { |h, k| h[k] = 0 }
      rolls.each do |rock|
        stop = cache[direction][rock]
        rocks_at_stop = hits[stop] += 1
        rock[0] = stop[0] + rocks_at_stop * offsets[0]
        rock[1] = stop[1] + rocks_at_stop * offsets[1]
      end

      loops_done += 1
      if loops_done == 1
        part_1 = calculate_load(rolls, input.length)
      end
    end

    cache_key = rolls.sort.map(&:dup)
    if seen_states.include?(cache_key)
      loop_length = loops_done - seen_states[cache_key]
      loops_done += (loops_to_do - loops_done) / loop_length * loop_length
    end
    seen_states[cache_key] = loops_done
  end

  [part_1, calculate_load(rolls, input.length)]
end

test_result = solve(test_input)
result = solve(input)
puts "Problem 1 (test): #{test_result[0]}"
puts "Problem 1: #{result[0]}"
puts "Problem 2 (test): #{test_result[1]}"
puts "Problem 2: #{result[1]}"
