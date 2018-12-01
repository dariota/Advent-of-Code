class Solution
	attr_reader :dict, :largest
	
	def initialize
		@dict = Hash.new(0)
		@largest = 0
	end

	def inc(num)
		num
	end

	def dec(num)
		-num
	end
	
	def method_missing(name, *args, &block)
		if args == []
			# set the value when we see it so dict is comprehensive
			dict[name] = dict[name]
		else
			dict[name] += args.pop	
			if dict[name] > largest
				@largest = dict[name]
			end
			dict[name]
		end
	end
	
	def lazy_eval
		return if @done_eval
		@done_eval = true
		eval File.new("input").read
	end
	
	def solution_1
		lazy_eval
		dict.values.max
	end
	
	def solution_2
		lazy_eval
		largest
	end
end

solution = Solution.new
puts solution.solution_1
puts solution.solution_2
