class Node
  attr_reader :value
  attr_accessor :node

  def initialize(value)
    @value = value
  end

  def point(node)
    @node = node
  end
end

def target_from(val, max)
  val - 1 == 0 ? max : val - 1
end

started = Time.now
input = File.open("input").lines.first.chomp.chars.map(&:to_i)
first_node = nil
last_node = nil
max_val = nil
input.each do |val|
  max_val = val if max_val.nil? || val > max_val
  node = Node.new(val)
  first_node ||= node
  last_node&.point(node)
  last_node = node
end
last_node.point(first_node)

current_node = first_node
100.times do |_|
  target_value = target_from(current_node.value, max_val)

  moving_values = []
  moving_nodes = current_node.node
  end_node = nil
  new_next = moving_nodes
  3.times do |_|
    end_node = new_next
    moving_values << new_next.value
    new_next = new_next.node
  end
  until !moving_values.include?(target_value)
    target_value = target_from(target_value, max_val)
  end

  current_node.node = new_next
  insert_point = new_next
  until insert_point.value == target_value
    insert_point = insert_point.node
  end
  end_node.node = insert_point.node
  insert_point.node = moving_nodes

  current_node = current_node.node
end

until current_node.value == 1
  current_node = current_node.node
end

current_node = current_node.node
str = ""
until current_node.value == 1
  str += current_node.value.to_s
  current_node = current_node.node
end

puts Time.now - started
puts str
