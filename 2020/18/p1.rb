class Op
  attr_reader :left, :op
  attr_accessor :right

  def initialize(op, left, right)
    @op = op
    @left = left
    @right = right
  end

  def value
    left.value.send(op, right.value)
  end

  def to_s
    vals = [left, op, right]
    vals.map { |v| v.is_a?(Op) ? "(#{v})" : v.to_s }.join(" ")
  end
end

class Constant
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s
    "#{value}"
  end
end

def parse(str, pos, preceding_node)
  #puts "At #{str[pos]}, preceding node: #{preceding_node}"
  return preceding_node if pos == str.length

  if str[pos] == ' '
    parse(str, pos + 1, preceding_node)
  elsif str[pos] == '('
    next_node, next_pos = parse(str, pos + 1, nil)
    if preceding_node
      preceding_node.right = next_node
    else
      preceding_node = next_node
    end

    parse(str, next_pos, preceding_node)
  elsif str[pos] == ')'
    return [preceding_node, pos + 1]
  elsif str[pos].match?(/\d/)
    # NB: "123+456".to_i == 123 because lol
    value = Constant.new(str[pos..].to_i)
    next_node = if preceding_node
      raise ArgumentError, "Two constants in a row" if preceding_node.is_a?(Constant)
      raise ArgumentError, "Op with no left operand" if preceding_node.left.nil?

      preceding_node.right = value
      preceding_node
    else
      value
    end

    parse(str, pos + 1, next_node)
  else
    parse(str, pos + 1, Op.new(str[pos].to_sym, preceding_node, nil))
  end
end

input = File.open("input").lines.map(&:chomp)
sums = input.map do |expr|
  parse(expr, 0, nil).value
end

puts sums.sum
