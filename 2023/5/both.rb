require 'set'

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

    def covers?(num)
      @source_range.cover?(num)
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
end

def solution_1(input)
  seeds = input[0].split(": ")[1].split(" ").map(&:to_i)
  converters = input[2..]
    .chunk { |l| l == "" ? :_separator : 1 }
    .map { |_, v| Converter.new(v[1..]) }
  seeds.map { |seed| converters.inject(seed) { |num, converter| converter.convert(num) } }.min
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
