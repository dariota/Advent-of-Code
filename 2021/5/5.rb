class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def hash
    x << 16 | y
  end

  def ==(other)
    other.is_a?(Point) &&
      x == other.x && y == other.y
  end
  alias eql? ==

  def to_s
    "#{x},#{y}"
  end

  def inspect
    "(#{x},#{y})"
  end
end

class Line
  attr_reader :left, :right

  def initialize(startpoint, endpoint)
    if startpoint.x <= endpoint.x
      @left = startpoint
      @right = endpoint
    else
      @left = endpoint
      @right = startpoint
    end
  end

  def axis_aligned?
    left.x == right.x ||
      left.y == right.y
  end

  def draw_onto(map)
    points.each { |point| map[point] += 1 }
  end

  def points
    delta_x = right.x - left.x
    slope = if delta_x.zero?
      min, max = [left.y, right.y].minmax
      return (min..max).map { |val| Point.new(left.x, val) }
    else
      delta_y = right.y - left.y
      raise "not implemented for angle-y bois" unless (delta_y % delta_x).zero? 

      delta_y / delta_x
    end
    c = left.y - slope * left.x

    (left.x..right.x).map { |x| Point.new(x, slope * x + c) }
  end

  def to_s
    "#{left} -> #{right}"
  end
end

def find_overlaps(lines)
  map = Hash.new(0)
  lines.each { |line| line.draw_onto(map) }

  map.values.select { |v| v >= 2 }.count
end

def problem_1(lines)
  find_overlaps(lines.select(&:axis_aligned?))
end

def problem_2(lines)
  find_overlaps(lines)
end

lines = File.readlines("input", chomp: true).flat_map { |line| Line.new(*line.split(" -> ").map { |coords| Point.new(*coords.split(",").map(&:to_i)) }) }

puts "Problem 1: #{problem_1(lines)}"
puts "Problem 2: #{problem_2(lines)}"
