require "set"

test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def first_invalid(deps, nums)
  seen = Set.new
  relevant = Set.new(nums)
  nums.find do |num|
    seen.add(num)
    ((deps[num] - seen) & relevant).any?
  end
end

def parse_input(input)
  deps = Hash.new { |hsh, k| hsh[k] = Set.new }
  dep_rules, pages = input.partition { |line| line.include?("|") }
  pages.reject!(&:empty?)

  dep_rules.each do |rule|
    before, after = rule.split("|")
    deps[after].add(before)
  end

  valid_pages, invalid_pages = pages.partition do |nums|
    first_invalid(deps, nums.split(",")).nil?
  end

  return deps, valid_pages, invalid_pages
end

def solution_1(input)
  _, valid_pages, _ = parse_input(input)

  valid_pages.sum do |nums|
    nums = nums.split(",")
    nums[nums.length / 2].to_i
  end
end

def solution_2(input)
  deps, _, invalid_pages = parse_input(input)

  invalid_pages.sum do |page|
    nums = page.split(",")
    relevant = Set.new(nums)
    num = first_invalid(deps, nums)
    while !num.nil? do
      nums.delete(num)
      ind = (deps[num] & relevant).map { |dep| nums.index(dep) }.max + 1
      nums.insert(ind, num)
      num = first_invalid(deps, nums)
    end
    nums[nums.length / 2].to_i
  end
end

puts "Problem 1 (test): #{solution_1(test_input)}"
puts "Problem 1: #{solution_1(input)}"

puts "Problem 2 (test): #{solution_2(test_input)}"
puts "Problem 2: #{solution_2(input)}"
