test_input = File.readlines("input.test", chomp: true).map { |line| line.split(" ").map(&:to_i) }
input = File.readlines("input", chomp: true).map { |line| line.split(" ").map(&:to_i) }

def is_safe(nums)
  is_increasing = nums[1] > nums[0]
  min_diff = if is_increasing then 1 else -1 end
  max_diff = if is_increasing then 3 else -3 end
  nums.each_cons(2).all? { |a, b| ((a+min_diff)..(a+max_diff)).step(min_diff).include?(b) }
end

def solution_1(input)
  input.count { |line| is_safe(line) }
end

def solution_2(input)
  input.count { |line|
    (0...line.length).any? { |i|
      replaced = line.dup
      replaced.delete_at(i)
      is_safe(replaced)
    }
  }
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"

puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
