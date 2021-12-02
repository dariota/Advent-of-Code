class Coord
  attr_reader :a, :r, :c

  def initialize(a = 0, r = 0, c = 0)
    @a = a
    @r = r
    @c = c
  end

  def move(instruction)
    case instruction
    when 'ne'
      old_a = @a
      @a = 1 - @a
      @r -= @a
      @c += old_a
    when 'e'
      @c += 1
    when 'se'
      old_a = @a
      @a = 1 - @a
      @r += old_a
      @c += old_a
    when 'sw'
      old_a = @a
      @a = 1 - @a
      @r += old_a
      @c -= @a
    when 'w'
      @c -= 1
    when 'nw'
      @a = 1 - @a
      @r -= @a
      @c -= @a
    else raise ArgumentError, "Bad direction #{instruction}"
    end

    self
  end

  def adjacent_coords
    directions = %w[ne e se sw w nw]
    directions.map { |direction| Coord.new(a, r, c).move(direction) }
  end
  
  def hash
    (a & 0x1) | ((r & 0xFFFF) << 1) | ((c & 0x7FFF) << 17)
  end

  def eql?(other)
    other.is_a?(Coord) &&
      other.a == a &&
      other.r == r &&
      other.c == c
  end

  def to_s
    "(#{a}, #{r}, #{c})"
  end
end

def to_coord(line)
  ind = 0
  coord = Coord.new
  until ind == line.length
    instruction = if %w[n s].include?(line[ind])
      line[ind..(ind+1)]
    else
      line[ind]
    end

    coord.move(instruction)

    ind += instruction.length
  end
  coord
end

input = File.open("input").lines.map(&:chomp)
tiles = Hash.new(false)

input.each do |line|
  tiles[to_coord(line)] ^= true
end

100.times do |day|
  adjacency = Hash.new(0)
  new_tiles = Hash.new(false)
  tiles.select { |_, v| v }.each do |coord, _|
    coord.adjacent_coords.each do |adj|
      adjacency[adj] += 1
    end
  end

  adjacency.each do |coord, adjacent|
    next unless (adjacent == 2) || (adjacent == 1 && tiles[coord])

    new_tiles[coord] = true
  end

  tiles = new_tiles
end

puts tiles.values.select { |v| v }.count
