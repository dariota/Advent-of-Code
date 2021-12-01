def solution_1(input)
	has_2 = 0
	has_3 = 0
	input.map { |word|
		counts = Hash.new(0)
		word.chars.map { |c|
			counts[c] = counts[c] + 1
		}
		has_2 += 1 if counts.values.any? { |val| val == 2}
		has_3 += 1 if counts.values.any? { |val| val == 3}
	}
	has_2 * has_3
end

def solution_2(input)
	mismatch_pos = nil
	seen = {}
	word = input.find { |word|
		seen[word] = true
		other_word = input.find { |other_word|
			next if seen[other_word]
			mismatch_pos = nil
			(0..word.length-1).all? { |ind|
				if word[ind] != other_word[ind] && !mismatch_pos
					mismatch_pos = ind
				else
					word[ind] == other_word[ind]
				end
			}
		}
	}
	
	word[mismatch_pos] = ""
	word
end

input = File.new("input").read.chomp.split("\n")
puts solution_1(input)
puts solution_2(input)
