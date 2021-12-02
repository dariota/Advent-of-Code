input = File.open("input").lines.map(&:chomp)

class Validator
  attr_reader :name

  def initialize(name, ranges)
    @name = name
    @ranges = ranges
  end

  def self.parse(str)
    splits = str.split(": ")
    name = splits[0]
    ranges = splits[1].split(" or ").map do |range|
      nums = range.split("-")
      (nums[0].to_i..nums[1].to_i)
    end

    new(name, ranges)
  end

  def valid?(num)
    @ranges.any? { |range| range.cover?(num) }
  end

  def inspect
    "Validator<#{@name}: #{@ranges}>"
  end
end


splits = input.slice_when { |line| line.empty? }.to_a
rules = splits[0][0..-2].map { |str| Validator.parse(str) }
my_ticket = splits[1][1]
nearby_tickets = splits[2][1..].map { |ticket| ticket.split(",").map(&:to_i) }

valid_tickets = nearby_tickets.select do |ticket|
  ticket.all? do |num|
    rules.any? { |rule| rule.valid?(num) }
  end
end

column_potentials = {}
(0...rules.size).each do |col|
  column_values = valid_tickets.map { |ticket| ticket[col] }
  potential_rules = rules.select do |rule|
    column_values.all? { |val| rule.valid?(val) }
  end
  column_potentials[col] = potential_rules
end

column_assignments = {}
until column_assignments.keys.size == rules.size || column_potentials.values.flatten.none? { |v| v.name.start_with?("departure") }
  if column_potentials.values.map(&:size).none? { |v| v == 1 }
    puts column_potentials
    raise "Gon' loop"
  end

  certain_rules = column_potentials.select { |_, v| v.size == 1 }
  column_assignments.merge!(certain_rules)
  column_potentials.each do |k, v|
    column_potentials[k] = v.reject { |rule| certain_rules.values.flatten.map(&:name).include?(rule.name) }
  end
end

departure_assignments = column_assignments.select do |_,v|
  v.first.name.start_with?("departure")
end
ticket_columns = my_ticket.split(",").map(&:to_i)
selected_columns = departure_assignments.keys.map do |ind|
  ticket_columns[ind]
end

puts selected_columns.reduce(:*)
