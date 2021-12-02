class Leaf
  attr_reader :literal, :offset

  def initialize(literal)
    @literal = literal
    @offset = literal.length - 1
  end

  def match?(str, pos, _rules)
    return [] if str[pos..(pos + offset)] != literal

    [pos + literal.length]
  end
end

class Rule
  attr_reader :id, :definitions

  def initialize(id, definitions)
    @id = id.to_i
    @definitions = definitions
  end

  def self.parse(description)
    id, rules = description.split(": ")

    alternatives = rules.split(" | ")
    definitions = []
    alternatives.each do |alternative|
      atoms = alternative.split(" ")
      definitions << atoms.map do |atom|
        if atom.match?(/"\w"/)
          Leaf.new(atom.gsub('"', ''))
        else
          atom.to_i
        end
      end
    end

    Rule.new(id, definitions)
  end

  # return: list of positions in the string where matches end
  def match?(str, pos, rules)
    match_ends = []

    definitions.each do |alternative|
      #puts "comparing alternative: #{alternative}"

      current_pos = [pos]
      alternative.each do |atom|
        #puts " alternative at positions: #{current_pos}"
        if atom.is_a?(Integer)
          atom = rules[atom]
        end

        new_pos = []
        current_pos.each do |starting_pos|
          atom_matches = atom.match?(str, starting_pos, rules)
          #puts "  checking atom #{atom} from #{starting_pos}, got #{atom_matches}"
          new_pos.concat(atom_matches)
        end
        current_pos = new_pos
      end
      match_ends.concat(current_pos)
    end

    match_ends
  end
end

input = File.open("input").lines.map(&:chomp)
rule_lines, messages = input.slice_when { |line| line.empty? }.to_a
#puts "rule_lines: #{rule_lines}"
#puts "messages: #{messages}"
rule_lines = rule_lines.first(rule_lines.size - 1)

rules = {}
rule_lines.each do |line|
  rule = Rule.parse(line)
  rules[rule.id] = rule
end
rules[8] = Rule.new(8, [[42],[42,8]])
rules[11] = Rule.new(11, [[42, 31],[42, 11, 31]])

matching_messages = messages.map do |message|
  if rules[0].match?(message, 0, rules).any? { |pos| pos == message.length }
    1
  else
    0
  end
end

puts matching_messages.sum
