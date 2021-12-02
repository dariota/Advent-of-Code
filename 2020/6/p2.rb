started = Time.now
input = File.open("input").lines.map(&:chomp)

groups = input.slice_when { |_, j| j.empty? }.map { |group| group.reject { |response| response.empty? } }

count = groups.map do |group|
  selected = Hash.new(0)
  group.map do |response|
    response.chars.each do |char|
      selected[char] = selected[char] + 1
    end
  end
  selected.select { |k,v| v == group.count }.count
end.sum

#puts "#{count}"
puts Time.now - started
