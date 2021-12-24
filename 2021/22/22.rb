class Region
  attr_reader :min_x, :max_x, :min_y, :max_y, :min_z, :max_z

  # This used to use ranges instead of 6 variables, but replacing them and their uses provided a ~20% speed increase.
  def initialize(min_x, max_x, min_y, max_y, min_z, max_z)
    @min_x = min_x
    @max_x = max_x
    @min_y = min_y
    @max_y = max_y
    @min_z = min_z
    @max_z = max_z
  end

  def -(other)
    return [self] if other.empty?
    return [] if self.within?(other)

    intersection = intersect(other)
    return [self] if intersection.empty?

    regions = []

    # We build up regions that result from the subtracation by first eliminating everything above and below the
    # intersecting section. This leaves us with a simpler 2D version of the problem (or, actually, decomposes it into
    # two 2D problems).
    #
    # Consider a side-on view of the cube, where # indicates the intersection with the cube being subtracted:
    #
    # - x +
    # ..... +
    # .###.
    # .###. y
    # .###.
    # ..... -
    #
    # We want to remove the regions above and below, marked 1 and 2, noting that either region could be empty:
    #
    # 22222
    # .###.
    # .###.
    # .###.
    # 11111
    #
    # Region 1:
    regions[0] = Region.new(
      min_x, max_x,
      min_y, intersection.min_y - 1,
      min_z, max_z,
    )
    # Region 2:
    regions[1] = Region.new(
      min_x, max_x,
      intersection.max_y + 1, max_y,
      min_z, max_z,
    )

    # Now we look top down at the remaining segment, which is identical throughout its length, and extract regions 3-6,
    # which all extend along the same y range as the intersection:
    #
    # - x +
    # 36664 +
    # 3###4
    # 3###4 z
    # 3###4
    # 35554 -
    #
    # Region 3 
    regions[2] = Region.new(
      min_x, intersection.min_x - 1,
      intersection.min_y, intersection.max_y,
      min_z, max_z,
    )
    # Region 4
    regions[3] = Region.new(
      intersection.max_x + 1, max_x,
      intersection.min_y, intersection.max_y,
      min_z, max_z,
    )
    # Region 5
    regions[4] = Region.new(
      intersection.min_x, intersection.max_x,
      intersection.min_y, intersection.max_y,
      min_z, intersection.min_z - 1,
    )
    # Region 6
    regions[5] = Region.new(
      intersection.min_x, intersection.max_x,
      intersection.min_y, intersection.max_y,
      intersection.max_z + 1, max_z,
    )

    # Any of the regions 1-6 may be empty, so remove them.
    regions.reject(&:empty?)
  end

  def size
    (max_x - min_x + 1) * (max_y - min_y + 1) * (max_z - min_z + 1)
  end

  def empty?
    (min_x > max_x) || (min_y > max_y) || (min_z > max_z)
  end

  # Not strictly within, i.e. a.within?(a) is true
  def within?(other)
    raise unless other.is_a?(Region)

    other.max_x >= max_x &&
      other.min_x <= min_x &&
      other.max_y >= max_y &&
      other.min_y <= min_y &&
      other.max_z >= max_z &&
      other.min_z <= min_z
  end

  def intersect(other)
    raise unless other.is_a?(Region)

    # This is faster than the more ruby way of throwing two elements in an array and calling min/max.
    new_min_x = (min_x > other.min_x) ? min_x : other.min_x
    new_max_x = (max_x < other.max_x) ? max_x : other.max_x
    new_min_y = (min_y > other.min_y) ? min_y : other.min_y
    new_max_y = (max_y < other.max_y) ? max_y : other.max_y
    new_min_z = (min_z > other.min_z) ? min_z : other.min_z
    new_max_z = (max_z < other.max_z) ? max_z : other.max_z
            
    Region.new(new_min_x, new_max_x, new_min_y, new_max_y, new_min_z, new_max_z)
  end

  def to_s
    "x=#{min_x}..#{max_x},y=#{min_y}..#{max_y},z=#{min_z}..#{max_z}"
  end

  def self.parse(line)
    match = /x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/.match(line)
    raise "Can't parse #{line}" unless match

    Region.new(match[1].to_i, match[2].to_i, match[3].to_i, match[4].to_i, match[5].to_i, match[6].to_i)
  end
end

class Reactor
  def initialize
    @regions = []
  end

  def turn_on(region)
    # Remove all regions already in list that are within this one
    @regions.reject! do |existing_region|
      existing_region.within?(region)
    end

    # Subtract all remaining regions already in list
    new_regions = [region]
    @regions.each do |existing_region|
      new_regions = new_regions.flat_map { |new_region| new_region - existing_region }
      # If we've got no regions left, then some combination of the existing regions cover the region we were adding
      return if new_regions.none?
    end

    # Finally add the net new regions to the list
    @regions.concat(new_regions)

    nil
  end

  def turn_off(region)
    # Remove the switched off region from all existing regions
    @regions = @regions.flat_map do |existing_region|
      existing_region - region
    end

    nil
  end

  def active_count
    @regions.sum(&:size)
  end

  def region_count
    @regions.count
  end
end

def solve(region_actions)
  reactor = Reactor.new

  # Within contiguous chunks of on/off actions, ordering doesn't matter. Doing the bigger actions first means less
  # fragmentation of those actions later, and in practice resulted in a ~30% speedup for my input.
  region_actions.chunk { |region, action| action == "on" }.map(&:last).each do |grouped|
    grouped.sort_by { |region, _| -region.size }.each do |region, action|
      if action == "on"
        reactor.turn_on(region)
      else
        reactor.turn_off(region)
      end
    end
  end

  reactor.active_count
end

def problem_1(region_actions)
  initialisation_region = Region.new(-50, 50, -50, 50, -50, 50)
  solve(region_actions.select { |region, _| region.within?(initialisation_region) })
end

def problem_2(region_actions)
  solve(region_actions)
end

input = File.readlines("input", chomp: true)

region_actions = input.map do |line|
  action, region_line = line.split(" ")
  [Region.parse(region_line), action]
end

puts "Problem 1: #{problem_1(region_actions)}"
puts "Problem 2: #{problem_2(region_actions)}"
