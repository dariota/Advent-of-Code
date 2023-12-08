test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

class Hand
  attr_reader :hand, :bid, :human, :rank

  CARDS = ['A', 'K', 'Q', 'J', 'T'] + (9..2).step(-1).map(&:to_s)
  CARD_MAP = CARDS.zip((0..).take(CARDS.length).reverse).each_with_object({}) { |pair, acc| acc[pair.first] = pair.last }
  CARD_MAP[:joker] = CARD_MAP.values.min - 1
  JOKER_UPGRADES = {
  # [rank_without_jokers, num_jokers] => best rank with jokers
    [:high, 5] => :five,
    [:high, 4] => :five,
    [:high, 3] => :four,
    [:high, 2] => :three,
    [:high, 1] => :pair,
    [:high, 0] => :high,
    [:pair, 3] => :five,
    [:pair, 2] => :four,
    [:pair, 1] => :three,
    [:pair, 0] => :pair,
    [:two_pair, 1] => :full_house,
    [:two_pair, 0] => :two_pair,
    [:three, 2] => :five,
    [:three, 1] => :four,
    [:three, 0] => :three,
    [:full_house, 0] => :full_house,
    [:four, 1] => :five,
    [:four, 0] => :four,
    [:five, 0] => :five,
  }
  RANKS = %i[high pair two_pair three full_house four five]

  def self.rank(hand)
    tallied = hand.tally
    values = tallied.values.tally
    return :five if values.include?(5)
    return :four if values.include?(4)
    if values.include?(3)
      return :full_house if values.include?(2)
      return :three
    end
    return :two_pair if values.dig(2) == 2
    return :pair if values.include?(2)
    :high
  end

  def self.joker_rank(hand)
    joker_map = CARD_MAP[:joker]
    joker_count = hand.count { |c| c == joker_map }
    joker_rank = Hand.rank(hand.reject { |c| c == joker_map })
    JOKER_UPGRADES[[joker_rank, joker_count]]
  end

  def initialize(line, jokerise)
    hand, bid = line.split(" ")
    @bid = bid.to_i
    @hand = hand.split("").map { |c| jokerise && c == 'J' ? :joker : c }.map { |c| CARD_MAP[c] }
    human_rank = jokerise ? Hand.joker_rank(@hand) : Hand.rank(@hand)
    @rank = RANKS.index(human_rank)
  end

  def <=>(other)
    rank_compare = self.rank <=> other.rank
    return @hand <=> other.hand if rank_compare.zero?

    rank_compare
  end
end

def solution_1(input)
  hands = input.map { |hand| Hand.new(hand, false) }.sort
  hands.each_with_index.sum { |hand, index| hand.bid * (index + 1) }
end

def solution_2(input)
  hands = input.map { |hand| Hand.new(hand, true) }.sort
  hands.each_with_index.sum { |hand, index| hand.bid * (index + 1) }
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
