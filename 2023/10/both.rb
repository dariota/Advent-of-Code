require 'set'

test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

class Tile
  CONNECTS_RIGHT = %i[horizontal bend_dr bend_ur start]
  CONNECTS_LEFT = %i[horizontal bend_dl bend_ul start]
  CONNECTS_UP = %i[vertical bend_ul bend_ur start]
  CONNECTS_DOWN = %i[vertical bend_dl bend_dr start]

  TILE_MAP = {
    '|' => :vertical,
    '-' => :horizontal,
    'L' => :bend_ur,
    'J' => :bend_ul,
    '7' => :bend_dl,
    'F' => :bend_dr,
    'S' => :start,
    '.' => :ground,
    'O' => :spacer,
  }
  CHAR_MAP = TILE_MAP.invert

  attr_reader :row, :col, :type
  attr_accessor :flooded

  def initialize(row, col, type, map)
    @row = row
    @col = col
    @type = TILE_MAP[type]
    @flooded = false
    @map = map
  end

  def connections
    up = @map[row - 1][col] if row > 0
    left = @map[row][col - 1] if col > 0
    right = @map[row][col + 1] if col < @map[row].length - 1
    down = @map[row + 1][col] if row < @map.length - 1

    connections = []

    connections.push(up) if up && connects?(:up) && up.connects?(:down)
    connections.push(left) if left && connects?(:left) && left.connects?(:right)
    connections.push(right) if right && connects?(:right) && right.connects?(:left)
    connections.push(down) if down && connects?(:down) && down.connects?(:up)

    connections
  end

  def connects?(direction)
    case direction
    when :up
      CONNECTS_UP.include?(type)
    when :left
      CONNECTS_LEFT.include?(type)
    when :right
      CONNECTS_RIGHT.include?(type)
    when :down
      CONNECTS_DOWN.include?(type)
    else
      false
    end
  end

  def ground!
    @type = :ground
  end
  
  def spacer_down
    if type == :start
      down = @map[row + 1][col] if row < @map.length - 1
      if down && down.connects?(:up)
        return :vertical
      else
        return :spacer
      end
    end

    if connects?(:down)
      :vertical
    else
      :spacer
    end
  end

  def spacer_left
    if type == :start
      left = @map[row][col - 1] if col > 0
      if left && left.connects?(:right)
        return :horizontal
      else
        return :spacer
      end
    end

    if connects?(:left)
      :horizontal
    else
      :spacer
    end
  end

  def floodable
    return [] unless %i[ground spacer].include?(type)

    up = @map[row - 1][col] if row > 0
    left = @map[row][col - 1] if col > 0
    right = @map[row][col + 1] if col < @map[row].length - 1
    down = @map[row + 1][col] if row < @map.length - 1

    [up, left, right, down]
      .reject { |tile| tile.nil? || tile.flooded || !%i[ground spacer].include?(tile.type) }
  end

  def flood
    return unless %i[ground spacer].include?(type)

    @flooded = true

    boundary = Set.new
    boundary.add(self)
    until boundary.empty?
      boundary = boundary.each_with_object(Set.new) do |tile, set|
        tile.floodable.each do |flooding_tile|
          flooding_tile.flooded = true
          set.add(flooding_tile)
        end
      end
    end
  end

  def to_s
    return '#' if flooded

    TILE_MAP.invert[type]
  end
end

def parse_map(input)
  map = []
  start_node = nil
  input.each_with_index { |line, row| map.push([]); line.chars.each_with_index { |char, col| map[row][col] = Tile.new(row, col, char, map); start_node = map[row][col] if char == 'S' } }
  [map, start_node]
end

def print_map(map)
  puts map.map { |tiles| tiles.map(&:to_s).join("") }.join("\n")
end

def solution_1(input)
  map, start_node = parse_map(input)

  seen_nodes = Set.new([start_node])
  next_nodes = [start_node]
  steps = 0
  while next_nodes.any? do
    steps += 1
    next_nodes = next_nodes.flat_map(&:connections).reject { |node| seen_nodes.include?(node) }
    next_nodes.each { |node| seen_nodes.add(node) }
  end
  # Subtract one because the last step is from the furthest tile to nowhere
  steps - 1
end

def solution_2(input)
  map, start_node = parse_map(input)

  # Find the loop
  loop_nodes = Set.new([start_node])
  next_nodes = [start_node]
  while next_nodes.any? do
    next_nodes = next_nodes.flat_map(&:connections).reject { |node| loop_nodes.include?(node) }
    next_nodes.each { |node| loop_nodes.add(node) }
  end

  # Replace everything not in the loop with ground (simplifies flood fill later)
  map.each { |row| row.each { |node| node.ground! unless loop_nodes.include?(node) } }

  # add spacers between rows/cols, ensuring pipes stay connected
  spaced_map = [[]]
  # Add spacer row above first row
  (map[0].length * 2 + 1).times do |col|
    spaced_map[0].append(Tile.new(0, col, Tile::CHAR_MAP[:spacer], spaced_map))
  end
  # Add each row with spacer below
  map.each_with_index do |tiles, row|
    spaced_row = []
    # Add each tile with a spacer left
    tiles.each_with_index do |tile, col|
      spaced_row.append(Tile.new(row * 2 + 1, col * 2, Tile::CHAR_MAP[tile.spacer_left], spaced_map))
      spaced_row.append(Tile.new(row * 2 + 1, col * 2 + 1, Tile::CHAR_MAP[tile.type], spaced_map))
    end
    # Add the final spacer right - always a spacer because the main loop can't connect
    # outside of the map
    spaced_row.append(Tile.new(row * 2 + 1, tiles.length * 2, Tile::CHAR_MAP[:spacer], spaced_map))
    spaced_map.append(spaced_row)

    # Add the spacer row below
    spaced_row = []
    tiles.each_with_index do |tile, col|
      # Always below a spacer, so always a spacer
      spaced_row.append(Tile.new(row * 2 + 2, col * 2, Tile::CHAR_MAP[:spacer], spaced_map))
      # Below the actual tile
      spaced_row.append(Tile.new(row * 2 + 2, col * 2 + 1, Tile::CHAR_MAP[tile.spacer_down], spaced_map))
    end
    # And the final spacer right
    spaced_row.append(Tile.new(row + 1, tiles.length * 2, Tile::CHAR_MAP[:spacer], spaced_map))
    spaced_map.append(spaced_row)
  end

  # flood fill
  spaced_map[0][0].flood

  # count unreached non-spacers
  spaced_map.sum { |row| row.count { |tile| !tile.flooded && tile.type == :ground } }
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
