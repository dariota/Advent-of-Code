class Rule

  attr_reader :shell_colour, :content_colours

  def initialize(shell, contents)
    @shell_colour = shell
    @content_colours = contents
  end

  def can_contain?(colour)
    @content_colours.include?(colour)
  end

  def self.parse(line)
    parts = line.chomp.split(" bags contain")
    shell = parts.first
    inner = parts.last.sub(/\.$/, '').split(",")
    if inner == ["no other bags"]
      inner = []
    else
      inner = inner.map { |str| str.sub(/ \d+ (.+) bags?/, '\1').chomp }
    end

    new(shell, inner)
  end

end

rules = File.open("input").lines.map { |line| Rule.parse(line) }

def recurse(target_colour, rules, seen)
  seen << target_colour

  direct_wrap = rules.select { |rule| rule.can_contain?(target_colour) }.map(&:shell_colour)
  unseen = direct_wrap.reject { |shell| seen.include?(shell) }

  (direct_wrap + unseen.map { |target| recurse(target, rules, seen) }).flatten.uniq
end

puts recurse("shiny gold", rules, []).count
