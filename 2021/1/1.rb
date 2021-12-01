input = File.open("input").readlines.map(&:chomp).map(&:to_i)

# Take every value in overlapping pairs, and for each pair produce a 1 if increasing, 0 if
# decreasing, then add up the results
solution_1 = input.each_cons(2).map { |a, b| b > a ? 1 : 0 }.sum
puts "Problem 1: #{solution_1}"

# Take every triplet, add them up, then just do problem 1 again on those results
solution_2 = input.each_cons(3).map(&:sum).each_cons(2).map { |a, b| b > a ? 1 : 0 }.sum
puts "Problem 2: #{solution_2}"
