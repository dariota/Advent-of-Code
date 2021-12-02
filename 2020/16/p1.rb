input = File.open("input").lines.map(&:chomp)

class Validator
  def initialize(ranges)
    @ranges = ranges
  end

  def self.parse(str)
    ranges = str.split(": ")[1].split(" or ").map do |range|
      nums = range.split("-")
      (nums[0].to_i..nums[1].to_i)
    end

    new(ranges)
  end

  def valid?(num)
    @ranges.any? { |range| range.cover?(num) }
  end
end


splits = input.slice_when { |line| line.empty? }.to_a
rules = splits[0][0..-2].map { |str| Validator.parse(str) }
my_ticket = splits[1][1]
nearby_tickets = splits[2][1..]

rolling = 0
nearby_tickets.each do |ticket|
  ticket.split(",").map(&:to_i).each do |num|
    next if rules.any? { |rule| rule.valid?(num) }

    rolling += num
  end
end

puts rolling
