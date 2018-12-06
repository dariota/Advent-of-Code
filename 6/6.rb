class Coordinate
	attr_reader :x, :y
	attr_accessor :closest
	
	def initialize(str)
		coords = str.split(", ").map(&:to_i)
		@x = coords[0]
		@y = coords[1]
		@closest = 0
	end
	
	def distance_from(ox, oy)
		(ox - x).abs + (oy - y).abs
	end
end

def bounds_loop(coordinates)
	lower_x, upper_x = coordinates.minmax_by(&:x).map(&:x)
	lower_y, upper_y = coordinates.minmax_by(&:y).map(&:y)
	[lower_x, upper_x, lower_y, upper_y]
	(lower_x + 1..upper_x - 1).each do |x|
		(lower_y + 1..upper_y - 1).each do |y|
			coords = coordinates.map { |c| [c, c.distance_from(x, y)] }
			yield(coords)
		end
	end
end

def solution_1(coordinates)
	bounds_loop(coordinates) do |coords|
		min = nil
		min_coord = nil
		unique_min = true
		coords.each do |c, dist|
			if min.nil? || dist < min
				min = dist
				min_coord = c
				unique_min = true
			elsif dist == min
				unique_min = false
			end
		end
		min_coord.closest += 1 if unique_min
	end
	
	coordinates.max_by(&:closest).closest
end

def solution_2(coordinates)
	candidate_coordinates = 0
	bounds_loop(coordinates) do |coords|
		next unless coords.map(&:last).reduce(:+) < 10000
		candidate_coordinates += 1
	end
	candidate_coordinates
end

input = File.new("input").read.chomp.split("\n").map { |l| Coordinate.new(l) }
puts solution_1(input)
puts solution_2(input)
