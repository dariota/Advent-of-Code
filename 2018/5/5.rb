def flip_case(char)
	return char.upcase if char >= "a" && char <= "z"
	char.downcase
end

def reduce(input)
	index = 1
	until index == input.length
		char = input[index]
		if input[index - 1] == flip_case(char)
			input[index - 1..index] = "" 
			index = [index - 1, 1].max
		else
			index += 1
		end
	end
	input.length
end

def solution_1(input)
	reducible = input.dup
	reduce(reducible)
end

def solution_2(input)
	lengths = []
	('a'..'z').each do |char|
		lengths.push(solution_1(input.gsub(/#{char}|#{char.upcase}/, "")))
	end
	lengths.min
end

input = File.new("input").read.chomp
puts solution_1(input)
puts solution_2(input)
