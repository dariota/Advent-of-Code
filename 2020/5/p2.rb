started = Time.now

class Seat

  attr_reader :row, :number

  def initialize(row, number)
    @row = row
    @number = number
  end

  def id
    row * 8 + number
  end

  def self.parse(instruction)
    seat = new(
      bisect((0..127), instruction[0..6]),
      bisect((0..7), instruction[7..]),
    )
    seat
  end

  def self.bisect(range, instruction)
    instruction.chars.each do |char|
      if char == "F" || char == "L"
        range = range.first(range.size / 2)
      else
        range = range.last(range.size / 2)
      end
    end
    range.first
  end
end

seats = File.open("input").lines.map(&:chomp).map { |line| Seat.parse(line) }

seat_ids = seats.map(&:id).sort
last_seen = seat_ids.first
seat_ids.each do |id|
  if last_seen == id - 2
    #puts id - 1
  end
  last_seen = id
end

puts Time.now - started
