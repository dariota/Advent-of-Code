input = File.open("input").lines.map(&:chomp)

groups = input.slice_when { |_, j| j.empty? }

count = groups.map do |group|
  selected = {}
  group.map do |response|
    response.chars.each do |char|
      selected[char] = 1
    end
  end
  selected.keys.count
end.sum

puts count
