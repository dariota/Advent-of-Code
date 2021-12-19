class SnailValue
  attr_reader :value
  attr_accessor :parent

  def copy
    if value.is_a?(Integer)
      SnailValue.literal(value)
    else
      copy = SnailValue.new
      copy.set_left(value[:left].copy)
      copy.set_right(value[:right].copy)
      copy
    end
  end

  def add(other)
    raise unless other.is_a?(SnailValue)

    new_root = SnailValue.new
    new_root.set_left(self)
    new_root.set_right(other)

    new_root.reduce
  end

  def magnitude
    return value if value.is_a?(Integer)

    3 * value[:left].magnitude + 2 * value[:right].magnitude
  end

  def reduce
    loop do
      next if do_explosions(1)
      next if do_splits
      break
    end

    self
  end

  def do_explosions(depth)
    return false unless @value.is_a?(Hash)

    if depth > 4 && @value.is_a?(Hash)
      explode
      return true
    end

    if @value.is_a?(Hash)
      return true if @value[:left].do_explosions(depth + 1)
      return true if @value[:right].do_explosions(depth + 1)
    end

    false
  end

  def do_splits
    if @value.is_a?(Integer) && @value > 9
      split
      return true
    end

    if @value.is_a?(Hash)
      return true if @value[:left].do_splits
      return true if @value[:right].do_splits
    end

    false
  end

  def set_value(value)
    raise unless value.is_a?(Integer)

    @value = value

    self
  end

  def set_available(value)
    raise unless @value.nil? || @value.is_a?(Hash)

    @value ||= {}
    if @value.key?(:left)
      raise "No slot to set" if @value.key?(:right)

      set_right(value)
    else
      set_left(value)
    end

    self
  end

  def set_left(left)
    raise unless @value.nil? || @value.is_a?(Hash)
    raise unless left.is_a?(SnailValue)

    @value ||= {}
    @value[:left] = left
    left.parent = self

    self
  end

  def set_right(right)
    raise unless @value.nil? || @value.is_a?(Hash)
    raise unless right.is_a?(SnailValue)

    @value ||= {}
    @value[:right] = right
    right.parent = self

    self
  end

  def to_s
    return @value.to_s unless @value.is_a?(Hash)

    "[" + value[:left].to_s + "," + value[:right].to_s + "]"
  end

  private def explode
    raise unless @value.is_a?(Hash) 
    raise unless @value[:left].value.is_a?(Integer)
    raise unless @value[:right].value.is_a?(Integer)

    prev = previous_value
    prev.set_value(prev.value + @value[:left].value)
    succ = next_value
    succ.set_value(succ.value + @value[:right].value)

    replacement = SnailValue.literal(0)
    if parent.value[:left] == self
      parent.set_left(replacement)
    else
      parent.set_right(replacement)
    end
  end

  private def split
    raise unless @value.is_a?(Integer)

    new_pair = SnailValue.new
    new_pair.set_left(SnailValue.literal((@value / 2.0).floor))
    new_pair.set_right(SnailValue.literal((@value / 2.0).ceil))

    if parent.value[:left] == self
      parent.set_left(new_pair)
    elsif parent.value[:right] == self
      parent.set_right(new_pair)
    else
      raise
    end
  end

  private def next_value
    current = self
    # ascend until we're on the left
    loop do
      done = current.parent.nil? || current.parent.value[:left] == current
      current = current.parent
      break if done
    end
    return sentinel unless current

    # descend leftward from the right
    current = current.value[:right]
    until current.value.is_a?(Integer)
      current = current.value[:left]
    end

    current
  end

  private def previous_value
    current = self
    # ascend until we're on the right
    loop do
      done = current.parent.nil? || current.parent.value[:right] == current
      current = current.parent
      break if done
    end
    return sentinel unless current

    # descend rightward from the left
    current = current.value[:left]
    until current.value.is_a?(Integer)
      current = current.value[:right]
    end

    current
  end

  private def sentinel
    SnailValue.literal(0)
  end

  def self.parse(line)
    root = SnailValue.new
    raise unless line[0] == "["

    current = root
    line[1..].split("").each_with_index do |char, ind|
      next if char == ","

      if char == "["
        new_value = SnailValue.new
        current.set_available(new_value)
        current = new_value
        next
      end

      if char == "]"
        current = current.parent
        next
      end

      current.set_available(literal(char.to_i))
    end

    root
  end

  def self.literal(value)
    SnailValue.new.set_value(value)
  end
end

def problem_1(lines)
  numbers = lines.map { |line| SnailValue.parse(line) }
  numbers.reduce { |acc, val| acc.add(val) }.magnitude
end

def problem_2(lines)
  numbers = lines.map { |line| SnailValue.parse(line) }
  all_pairs = numbers.permutation(2).map do |pair|
    [pair.map(&:copy), pair.map(&:copy).reverse]
  end.flatten(1)
  added = all_pairs.map { |a,o| a.add(o) }
  added.map(&:magnitude).max
end

lines = File.readlines("input", chomp: true)

puts "Problem 1: #{problem_1(lines)}"
puts "Problem 2: #{problem_2(lines)}"
