require 'set'

def triangle(n)
  return 0 if n < 0

  @triangle ||= [0]

  if @triangle.length < (n + 1) 
    (@triangle.length..(n + 1)).each do |t|
      @triangle[t] = t + @triangle[t - 1]
    end
  end

  @triangle[n]
end

def horizontal_distance_after(speed, time)
  triangle(speed) - triangle(speed - time)
end

def vertical_distance_after(speed, time)
  if speed.positive?
    if time <= speed
      triangle(speed) - triangle(speed - time)
    else
      triangle(speed) - triangle(time - speed - 1)
    end
  else
    speed = -speed - 1
    distance = triangle(speed) - triangle(speed + time)
  end
end

def potential_speeds(target_x, target_y)
  # Precompute some triangular numbers
  triangle([target_x.max,target_y.max].max)

  x_potentials = (1..target_x.max).each_with_object({}) do |x, hsh|
    hsh[x] = (1..x).take_while { |t| horizontal_distance_after(x, t) <= target_x.max }
      .select { |t| target_x.cover?(horizontal_distance_after(x, t)) }
  end.select { |_,v| v.any? }

  x_ranges = x_potentials.each_with_object({}) do |pair, hsh|
    min, max = pair.last.minmax
    hsh[pair.first] = if max == pair.first
      (min..)
    else
      (min..max)
    end
  end

  y_potentials = ((target_y.min)..(target_y.min - 1).abs).each_with_object({}) do |y, hsh|
    hsh[y] = (1..).take_while { |t| vertical_distance_after(y, t) >= target_y.min }
      .select { |t| target_y.cover?(vertical_distance_after(y, t)) }
  end.select { |_,v| v.any? }
  y_ranges = y_potentials.each_with_object({}) do |pair, hsh|
    min, max = pair.last.minmax
    hsh[pair.first] = (min..max)
  end

  [x_ranges, y_ranges]
end

def range_overlap?(x_range, y_range)
  x_range.first <= y_range.last &&
    (!x_range.count.finite? || x_range.last >= y_range.first)
end

def problem_1(target_x, target_y)
  x_ranges, y_ranges = potential_speeds(target_x, target_y)

  max_y = y_ranges.sort_by(&:first).reverse.find do |_, y_range|
    x_ranges.any? do |_, x_range|
      range_overlap?(x_range, y_range)
    end
  end.first

  triangle(max_y)
end

def problem_2(target_x, target_y)
  x_ranges, y_potentials = potential_speeds(target_x, target_y)

  vectors = Set.new
  y_potentials.each do |y, y_range|
    x_ranges.each do |x, x_range|
      next unless range_overlap?(x_range, y_range)

      vectors.add([x, y])
    end
  end

  vectors.count
end

input = File.readlines("input", chomp: true).first
match = /x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/.match(input)
x_range = (match[1].to_i..match[2].to_i)
raise "Expected positive x target" unless x_range.first > 0 && x_range.last > 0

y_range = (match[3].to_i..match[4].to_i)
raise "Expected negative y target" unless y_range.first < 0 && y_range.last < 0

puts problem_1(x_range, y_range)
puts problem_2(x_range, y_range)
