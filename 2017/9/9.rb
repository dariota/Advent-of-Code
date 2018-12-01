def strip_irrelevant(input)
	input.gsub(/!./, "")
end

def remove_garbage(input, replacement: "")
	input.gsub(/<[^>]*>/, replacement)
end

def score_groups(input)
	value = 0
	score = 0
	input.chars.each { |c|
		value += 1 if c == "{"
		if c == "}"
			score += value
			value -= 1
		end
	}
	score
end

def solution_1(input)
	score_groups remove_garbage input
end

def solution_2(input)
	input.length - remove_garbage(input, replacement: "<>").length
end

input = strip_irrelevant File.open("input").read
puts solution_1 input
puts solution_2 input
