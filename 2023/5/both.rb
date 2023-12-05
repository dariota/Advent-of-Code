test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

class Converter
  class Conversion
    def initialize(source_range, destination_offset)
      @source_range = source_range
      @destination_offset = destination_offset
    end

    def convert(num)
      @destination_offset + (num - @source_range.begin)
    end

    def convert_range(range)
      (convert(range.min)..convert(range.max))
    end

    def covers?(num)
      @source_range.cover?(num)
    end

    def covered_range(range)
      # Returns the range of values that can be converted by this conversion
      # or nil
      convert_min = [@source_range.min, range.min].max
      convert_max = [@source_range.max, range.max].min
      (convert_min..convert_max) if convert_max > convert_min
    end
  end

  def initialize(conversions)
    @conversions = conversions.map do |conversion|
      destination_offset, source_start, range_length = conversion.split(" ").map(&:to_i)
      source_range = (source_start...source_start+range_length)
      Conversion.new(source_range, destination_offset)
    end
  end

  def convert(num)
    @conversions.find { |c| c.covers?(num) }&.convert(num) || num
  end

  def convert_range(range)
    # Returns an array of ranges, the ranges resulting from applying this conversion to
    # the full range.
    # e.g. suppose this converter mapped only 10 -> 11 and all other values to themselves
    #      and was passed a range of 0 -> 20, it would return [0->9, 11->20]

    # First apply each explicit conversion to the range to get the ranges at which there's
    # a non-trivial conversion
    ranges = @conversions.each_with_object([]) do |conversion, acc|
      covered_range = conversion.covered_range(range)
      acc.push([covered_range, conversion.convert_range(covered_range)]) if covered_range
    end

    # Then fill in all the gaps in mapped values with a map to themselves
    covered_ranges = ranges.map(&:first).sort_by { |range| range.min }
    walk = range.min
    until walk == range.max + 1
      next_range = covered_ranges.delete_at(0)
      if next_range.nil?
        # we've run out of ranges, without reaching the end
        # the rest of the range maps to itself
        ranges.push([(walk..range.max), (walk..range.max)])
        walk = range.max + 1
      elsif next_range.min > walk
        # There's a gap between the current value and the start of the
        # next range, which maps to itself
        ranges.push([(walk...next_range.min), (walk...next_range.min)])
        walk = next_range.max + 1
      else
        # There's no gap, we step forward to the end of the next range
        walk = next_range.max + 1
      end
    end

    # Then pull out only the values after conversion
    ranges.map(&:last)
  end
end

def parse_converters(input)
  converters = input[2..]
    .chunk { |l| l == "" ? :_separator : 1 }
    .map { |_, v| Converter.new(v[1..]) }
end

def solution_1(input)
  seeds = input[0].split(": ")[1].split(" ").map(&:to_i)
  converters = parse_converters(input)
  seeds.map { |seed| converters.inject(seed) { |num, converter| converter.convert(num) } }.min
end

def solution_2(input)
  converters = parse_converters(input)
  # don't look at me
  ranges = input[0].split(": ")[1].split(" ").map(&:to_i).each_slice(2).map do |arr|
    (arr[0]...arr[0] + arr[1])
  end
  converters.each do |converter|
    ranges = ranges.map { |range| converter.convert_range(range) }.flatten
  end
  ranges.min_by(&:min).min
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
