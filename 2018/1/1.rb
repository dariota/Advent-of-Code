def solve_1(input)
	input.reduce(:+)
end

def solve_2(input)
	set = {}
	acc = 0
	until set.key? acc
		acc = input.inject(acc) { |a,e|
			if set.key? a
				a
			else
				set[a] = nil
				a + e
			end
		}
	end
	acc
end

input = File.new("input").read.chomp.split("\n").map(&:to_i)
puts solve_1 input
puts solve_2 input
