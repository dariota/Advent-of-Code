started = Time.now

class Rule

  attr_reader :shell_colour, :contents

  def initialize(shell, contents)
    @shell_colour = shell
    @contents = contents
  end

  def can_contain?(colour)
    @content_colours.include?(colour)
  end

  def total_bags(other_rules)
    1 + @contents.map do |colour, count| 
      colour_rule = other_rules.find { |rule| rule.shell_colour == colour }
      count * colour_rule.total_bags(other_rules)
    end.sum
  end

  def self.parse(line)
    parts = line.chomp.split(" bags contain")
    shell = parts.first
    inner = parts.last.sub(/\.$/, '').split(",")
    inner = inner.map { |str| str.sub(/ (\d+) (.+) bags?/, '\1:\2').chomp.split(":") }

    contents = {}
    inner.each do |count, colour|
      next if colour.nil?
      
      contents[colour] = count.to_i
    end

    new(shell, contents)
  end

end

rules = File.open("input").lines.map { |line| Rule.parse(line) }

#puts (rules.find { |rule| rule.shell_colour == "shiny gold" }.total_bags(rules) - 1)
puts Time.now - started
