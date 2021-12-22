class Die
  def initialize
    @count = -1
  end

  def roll
    @count += 1
    (@count % 100) + 1
  end

  def total_rolls
    @count + 1
  end
end

class Game
  # Maps from number of steps that can be taken in a single turn, to how many ways they can be taken
  MOVES = [1,2,3].repeated_permutation(3).map(&:sum).group_by(&:itself)
    .each_with_object({}) { |pair, acc| acc[pair.first] = pair.last.length }.freeze

  # Returns array [current_wins, other_wins]
  def results(current_pos, current_score, other_pos, other_score)
    return [1,0] if current_score >= 21
    return [0,1] if other_score >= 21

    # Memoise
    @results ||= {}
    key = [current_pos, current_score, other_pos, other_score]
    # NB reversing players in this key gives the wrong result, as turn order matters
    return @results[key] if @results.key?(key)

    # We alternate the players in here, so we need to reverse them after
    outcomes = MOVES.map do |steps, ways|
      next_pos = new_pos(current_pos, steps)
      results(other_pos, other_score, next_pos, current_score + next_pos).map { |i| i * ways }
    end

    # This is where we reverse them
    @results[key] = outcomes.reduce([0,0]) do |acc, b|
      [acc[0] + b[1], acc[1] + b[0]]
    end
  end

  def new_pos(initial_pos, steps)
    (initial_pos + steps - 1) % 10 + 1
  end
end

def problem_1(p1_pos, p2_pos)
  p1 = { num: 1, pos: p1_pos, score: 0 }
  p2 = { num: 2, pos: p2_pos, score: 0 }
  die = Die.new

  current_player = p1
  iterations = 0
  loop do
    rolls = 3.times.map { die.roll }
    movement = rolls.sum
    new_pos = (current_player[:pos] + movement - 1) % 10 + 1

    current_player[:score] += new_pos
    current_player[:pos] = new_pos
    break if current_player[:score] >= 1000

    current_player = current_player == p1 ? p2 : p1
  end

  die.total_rolls * [p1[:score], p2[:score]].min
end

def problem_2(p1_pos, p2_pos)
  game = Game.new
  game.results(p1_pos, 0, p2_pos, 0).max
end

input = File.readlines("input", chomp: true)
p1_pos = input[0].split(" ").last.to_i
p2_pos = input[1].split(" ").last.to_i

puts "Problem 1: #{problem_1(p1_pos, p2_pos)}"
puts "Problem 2: #{problem_2(p1_pos, p2_pos)}"
