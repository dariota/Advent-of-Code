input = File.open("input").lines.map(&:to_i)
started = Time.now

start = 0

numbers = input.sort.push(input.max + 3)

paths = Hash.new(0)
paths[0] = 1
until numbers.empty?
  range = (start..start + 3)
  reachable = numbers.select { |number| range.cover?(number) }
  reachable.each do |number| 
    paths[number] += paths[start]
  end

  start = numbers.slice!(0)
end

ended = Time.now

#puts paths[start]
puts ended - started
