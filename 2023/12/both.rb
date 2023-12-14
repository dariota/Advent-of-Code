test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

class GroupState
  attr_reader :group, :amount, :permutations

  def initialize(group, amount, permutations, groups)
    @group = group
    @amount = amount
    @permutations = permutations
    @groups = groups
  end

  def increment_amount
    @amount += 1
  end

  def terminate_group
    if amount.zero?
      # no-op, we hadn't started yet
    elsif amount == @groups[group]
      # closed on time
      @amount = 0
      @group += 1
    else
      # closed halfway through
      @amount = nil
    end
  end

  def terminate
    terminate_group
    if group != @groups.length
      # didn't reach the end, mark invalid
      @amount = nil
    end
  end

  def valid?
    !amount.nil? && (amount.zero? || group < @groups.length && @groups[group] >= amount)
  end
  
  def mergeable?
    amount.zero?
  end

  def merge(other)
    GroupState.new(group, amount, permutations + other.permutations, @groups)
  end

  def dup
    GroupState.new(group, amount, permutations, @groups)
  end
end

def handle_hash(states)
  states.each(&:increment_amount)
  states.select(&:valid?)
end

def handle_dot(states)
  states.each(&:terminate_group)
  states.select(&:valid?)
end

def merge_states(states)
  mergeable_states, unmergeable_states = states.partition(&:mergeable?)
  to_merge = mergeable_states.group_by(&:group)
  unmergeable_states + to_merge.values.map { |group_states| group_states.reduce(&:merge) }
end

def count_permutations(line, groups)
  states = [GroupState.new(0, 0, 1, groups)]
  
  line.chars.each_with_index do |char, ind|
    if char == '#'
      states = handle_hash(states)
    elsif char == '.'
      states = merge_states(handle_dot(states))
    else # char == '?'
      states = merge_states(handle_dot(states.map(&:dup)) + handle_hash(states))
    end
  end

  states.each(&:terminate)
  states.select(&:valid?).sum(&:permutations)
end

def solution_1(input)
  input.sum do |line|
    search, pattern = line.split(" ")
    pattern = pattern.split(",").map(&:to_i)

    count_permutations(search, pattern)
  end
end

def solution_2(input)
  input.sum do |line|
    search, pattern = line.split(" ")
    search = ([search] * 5).join("?")
    pattern = (pattern.split(",").map(&:to_i) * 5).flatten
    
    count_permutations(search, pattern)
  end
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"
puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
