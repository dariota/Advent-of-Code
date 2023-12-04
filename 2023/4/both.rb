require 'set'

test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

class Card
  attr_reader :id, :winning, :have, :match_count
  attr_accessor :count

  def initialize(line)
    @id = line.split(":")[0].split(" ")[-1].to_i
    winning, have = line.split(": ")[1].split(" | ").map { |nums| nums.strip.split(/\s+/).map(&:to_i) }
    @winning = Set.new(winning)
    @have = Set.new(have)
    @match_count = (@winning & @have).length
    @count = 1
  end

  def points
    @match_count.zero? ? 0 : 2 << (@match_count - 2)
  end
end

def solution_1(input)
  input.map(&Card.method(:new)).sum(&:points)
end

def solution_2(input)
  cards = input.map(&Card.method(:new)).each_with_object({}) { |card, hsh| hsh[card.id] = card }

  min_id, max_id = cards.values.map(&:id).minmax
  (min_id..max_id).each do |card_id|
    card = cards[card_id]
    (1..card.match_count).each do |i|
      cards[card_id + i].count += card.count
    end
  end

  cards.values.sum(&:count)
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
