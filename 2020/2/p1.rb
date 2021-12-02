input = File.open("input").lines.map(&:chomp)

result = input.map do |pw_line|
  match_data = pw_line.match(/^(\d+)\-(\d+) (\w): (\w+)$/)
  min_matches = match_data[1].to_i
  max_matches = match_data[2].to_i
  required_char = match_data[3]
  pw = match_data[4]

  selected_chars = pw.chars.select { |c| c == required_char }
  if (min_matches..max_matches).cover?(selected_chars.size)
    1
  else
    0
  end
end.sum

puts result
