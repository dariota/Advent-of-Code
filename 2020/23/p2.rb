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

$timings = Hash.new(0)

started = Time.now
input = File.open("input").lines.first.chomp.chars.map(&:to_i)
nodes = []
first_node = nil
last_node = nil
max_val = nil
input.each do |val|
  max_val = val if max_val.nil? || val > max_val
  node = Node.new(val)
  nodes[val] = node
  first_node ||= node
  last_node&.point(node)
  last_node = node
end
((max_val + 1)..1000000).each do |val|
  node = Node.new(val)
  nodes[val] = node
  last_node.point(node)
  last_node = node
end
max_val = 1000000
last_node.point(first_node)
$timings[:setup] = Time.now - started

game_loop = Time.now
current_node = first_node
10000000.times do |i|
  started = Time.now
  target_value = target_from(current_node.value, max_val)
  $timings[:first_target] += Time.now - started

  started = Time.now
  moving_values = []
  moving_nodes = current_node.node
  end_node = nil
  new_next = moving_nodes
  3.times do |_|
    end_node = new_next
    moving_values << new_next.value
    new_next = new_next.node
  end
  $timings[:move_selection] += Time.now - started
  started = Time.now
  until !moving_values.include?(target_value)
    target_value = target_from(target_value, max_val)
  end
  $timings[:retargeting] += Time.now - started

  started = Time.now
  current_node.node = new_next
  started_2 = Time.now
  insert_point = nodes[target_value]
  ended_2 = Time.now
  end_node.node = insert_point.node
  insert_point.node = moving_nodes
  $timings[:inserting] += started - started_2 + (Time.now - ended_2)
  $timings[:node_lookup] += ended_2 - started_2

  current_node = current_node.node
end
$timings[:game_loop] = Time.now - game_loop

current_node = nodes[1]

puts $timings
puts "After one comes #{current_node.node.value} and #{current_node.node.node.value} == #{current_node.node.value * current_node.node.node.value}"
