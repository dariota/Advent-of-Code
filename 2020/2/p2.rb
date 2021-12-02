started = Time.now
input = File.open("input").lines.map(&:chomp)

result = input.map do |pw_line|
  match_data = pw_line.match(/^(\d+)\-(\d+) (\w): (\w+)$/)
  first_ind = match_data[1].to_i - 1
  second_ind = match_data[2].to_i - 1
  required_char = match_data[3]
  pw = match_data[4]

  chars_found = [pw[first_ind], pw[second_ind]]
  if chars_found.include?(required_char) && chars_found.uniq.size == 2
    1
  else
    0
  end
end.sum

#puts result
puts Time.now - started
