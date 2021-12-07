class CrabPositions
  def initialize(crabs)
    @crabs = crabs
  end

  def fuel_to(position)
    @fuel_to ||= Hash.new do |hsh, k|
      hsh[k] = @crabs.sum { |pos| (pos - k).abs }
    end

    @fuel_to[position]
  end

  def gaussian_fuel_to(position)
    @gaussian_fuel_to ||= Hash.new do |hsh, k|
      hsh[k] = @crabs.map { |pos| gauss((pos - k).abs) }.sum
    end

    @gaussian_fuel_to[position]
  end

  private def gauss(distance)
    (distance * (distance + 1) / 2.0).round
  end
end

def solve(lower, upper, fuel_method)
  until lower == upper
    midpoint = upper + (lower - upper) / 2
    if fuel_method.call(midpoint) > fuel_method.call(midpoint + 1)
      lower = midpoint
    elsif fuel_method.call(midpoint) > fuel_method.call(midpoint - 1)
      upper = midpoint
    else
      lower = upper = midpoint
    end
  end

  fuel_method.call(upper)
end

def problem_1(input)
  crabs = CrabPositions.new(input)
  lower, upper = input.minmax
  solve(lower, upper, crabs.method(:fuel_to))
end

def problem_2(input)
  crabs = CrabPositions.new(input)
  lower, upper = input.minmax
  solve(lower, upper, crabs.method(:gaussian_fuel_to))
end

input = File.readlines("input").first.split(",").map(&:to_i)

puts "Problem 1: #{problem_1(input)}"
puts "Problem 2: #{problem_2(input)}"
