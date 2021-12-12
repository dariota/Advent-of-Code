class Node
  attr_reader :id, :cap_traversals, :traversals

  def initialize(id)
    @id = id
    @cap_traversals = id.downcase == id
    @edges = []
    @traversals = 0
  end

  def add_edge(edge)
    raise "Infinite loop on edge #{id}-#{edge.id}" unless @cap_traversals || edge.cap_traversals

    @edges << edge
  end

  def traverse(only_exceptions)
    results = []

    @traversals += 1
    @edges.each do |node| 
      next if node.id == "start"

      if only_exceptions
        next unless node.cap_traversals && node.traversals == 1

        results << yield(node)
      else
        next if node.cap_traversals && node.traversals > 0

        results << yield(node)
      end
    end
    @traversals -= 1

    results
  end

  def to_s
    "Node(#{id})<@cap_traversals: #{cap_traversals}, @edges: #{@edges.map(&:id)}>"
  end

  def inspect
    to_s
  end

  def self.parse(lines)
    graph = lines.map { |line| line.split("-") }.each_with_object({}) do |pair, hsh|
      hsh[pair.first] ||= []
      hsh[pair.first] << pair.last
      hsh[pair.last] ||= []
      hsh[pair.last] << pair.first
    end

    nodes = (graph.keys + graph.values.flatten).uniq.each_with_object({}) do |id, hsh|
      hsh[id] = new(id)
    end

    graph.each do |node_id, edges|
      edges.each { |edge| nodes[node_id].add_edge(nodes[edge]) }
    end

    nodes
  end
end

def paths_from(node, find_extra)
  return [1, 0] if node.id == "end"

  paths = node.traverse(false) { |other_node| paths_from(other_node, find_extra) }
  paths = [paths.map(&:first).sum, paths.map(&:last).sum]
  extra_paths = if find_extra
    node.traverse(true) { |other_node| paths_from(other_node, false).first }.sum
  else
    0
  end
  
  [paths[0], extra_paths + paths[1]]
end

def problem_1(paths)
  paths.first
end

def problem_2(paths)
  paths.sum
end

nodes = Node.parse(File.readlines("input", chomp: true))

paths = paths_from(nodes["start"], true)
puts "Problem 1: #{problem_1(paths)}"
puts "Problem 2: #{problem_2(paths)}"
