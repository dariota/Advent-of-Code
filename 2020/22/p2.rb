require 'set'

class Deck
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def deal
    @cards.delete_at(0)
  end

  def win(mine, theirs)
    @cards.concat([mine, theirs])
  end

  def dup
    Deck.new(@cards.dup)
  end

  def size
    @cards.size
  end

  def empty?
    @cards.empty?
  end

  def hash
    if @cards.size >= 4
      @cards[0] << 48 |
        @cards[1] << 32 |
        @cards[-2] << 16 |
        @cards[-1]
    elsif @cards.size == 3
      @cards[1] << 32 |
      @cards[-2] << 16 |
      @cards[-1]
    elsif @cards.size == 2
      @cards[-2] << 16 |
      @cards[-1]
    elsif @cards.size == 1
      @cards[-1]
    else
      0
    end
  end

  def eql?(o)
    o.cards.eql?(@cards)
  end
end
    

input = File.open("input").lines.map(&:chomp).slice_when { |line| line.empty? }.to_a

first_hand = input[0][1..-2].map(&:to_i)
second_hand = input[1][1..-1].map(&:to_i)

# :game if player 1 wins game, :round if player 1 wins round, :lose if player 2 wins
def play_round(first_hand, second_hand, previous_hands)
  first = first_hand.dup
  second = second_hand.dup
  return :game unless previous_hands.add?([first, second])

  first_card = first_hand.deal
  second_card = second_hand.deal

  one_wins = if first_hand.size >= first_card && second_hand.size >= second_card
    play_game(first_hand.cards[0...first_card], second_hand.cards[0...second_card])
  else
    first_card > second_card ? :round : :lose
  end

  return one_wins if one_wins == :game

  if one_wins == :round
    first_hand.win(first_card, second_card)
  else
    second_hand.win(second_card, first_card)
  end

  one_wins
end

def play_game(first_hand, second_hand)
  first_hand = Deck.new(first_hand)
  second_hand = Deck.new(second_hand)

  round = 0
  last_outcome = nil
  previous_hands = Set.new
  until first_hand.empty? || second_hand.empty? || last_outcome == :game
    round += 1
    last_outcome = play_round(first_hand, second_hand, previous_hands)
  end

  last_outcome == :lose ? :lose : :round
end

play_game(first_hand, second_hand)

first_hand = first_hand.empty? ? second_hand : first_hand
hand_size = first_hand.size
sum = 0

(1..hand_size).each do |mul|
  sum += first_hand[hand_size - mul] * mul
end

puts sum
