def classify_line(line, character_pairs)
  stack = []

  line.split("").each do |char|
    if character_pairs.key?(char)
      if stack.pop != character_pairs[char]
        return [:invalid, char]
      end
    else
      stack.push(char)
    end
  end

  [:incomplete, stack]
end

def problem_1(classified_lines, scores)
  classified_lines
    .select { |category, _| category == :invalid }
    .map(&:last)
    .map { |char| scores[char] }
    .sum
end

def problem_2(classified_lines, scores)
  stacks = classified_lines
    .select { |category, _| category == :incomplete }
    .map(&:last)

  scores = stacks.map do |stack|
    score = 0
    until stack.empty?
      char = stack.pop
      score = score * 5 + scores[char]
    end
    score
  end.sort

  scores[scores.length / 2]
end

input = File.readlines("input", chomp: true)

corruption_scores = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137,
}

correction_scores = {
  "(" => 1,
  "[" => 2,
  "{" => 3,
  "<" => 4,
}

pairs = {
  ")" => "(",
  "]" => "[",
  "}" => "{",
  ">" => "<",
}

classified_input = input.map { |line| classify_line(line, pairs) }

puts "Problem 1: #{problem_1(classified_input, corruption_scores)}"
puts "Problem 2: #{problem_2(classified_input, correction_scores)}"
