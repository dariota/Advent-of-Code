test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

class Game
  attr_reader :id, :rounds

  def initialize(line)
    @id = line.split(":")[0].split("Game ")[1].to_i
    @rounds = line.split(": ")[1].split(";").map { |round|
      round.split(",").map(&:strip).each_with_object(Hash.new(0)) { |l, acc|
        acc[l.split(" ")[1]] = l.split(" ")[0].to_i
      }
    }
  end

  def possible?(colours)
    rounds.all? { |round| colours.all? { |colour, count| round[colour] <= count } }
  end

  def power(colours)
    rounds.each_with_object(Hash.new(0)) { |round, acc|
      colours.each { |colour|
        acc[colour] = [acc[colour], round[colour]].max
      }
    }.values.reduce(:*)
  end
end

def solution_1(input)
  colours = { "red" => 12, "green" => 13, "blue" => 14 }
  input.map { |line| Game.new(line) }.select { |g| g.possible?(colours) }.sum(&:id)
end

def solution_2(input)
  colours = ["red", "green", "blue"]
  input.map { |line| Game.new(line) }.sum { |g| g.power(colours) }
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"

puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
