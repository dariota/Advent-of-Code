class PolymerRules
  def initialize(mapping)
    @mapping = mapping
  end

  def map(pair)
    result = @mapping[pair]
    raise "No mapping for #{pair}" unless result

    result
  end

  def self.parse(rules)
    PolymerRules.new(
      rules.each_with_object({}) do |line, hsh|
        pair, char = line.split(" -> ")
        pair_chars = pair.split("")
        hsh[pair] = [pair_chars.first + char, char + pair_chars.last, char]
      end
    )
  end
end

def solve(polymer, rules, iterations)
  pairs = Hash.new(0)
  polymer.split("").each_cons(2) do |pair|
    pairs[pair.join] += 1
  end
  characters = Hash.new(0)
  polymer.split("").each { |char| characters[char] += 1 }

  iterations.times do |i|
    new_pairs = Hash.new(0)
    pairs.each do |pair, occurrences|
      mapping = rules.map(pair)
      characters[mapping.last] += occurrences
      mapping.first(2).each do |new_pair|
        new_pairs[new_pair] += occurrences
      end
    end
    pairs = new_pairs
  end

  characters
end

def problem_1(polymer, rules)
  min, max = solve(polymer, rules, 10).values.minmax
  max - min
end

def problem_2(polymer, rules)
  min, max = solve(polymer, rules, 40).values.minmax
  max - min
end

input = File.readlines("input", chomp: true)
polymer = input.first
rules = PolymerRules.parse(input[2..])

puts "Problem 1: #{problem_1(polymer, rules)}"
puts "Problem 2: #{problem_2(polymer, rules)}"
