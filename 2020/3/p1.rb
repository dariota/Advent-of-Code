input = File.open("input").lines.map(&:chomp).map(&:chars)

height = input.length
width = input[0].length

x = 0
y = 0
x_inc =  3
y_inc = 1

trees_hit = 0

until y == height
  trees_hit += input[y][x] == "#" ? 1 : 0

  x = (x + x_inc) % width
  y = (y + y_inc)
end

puts trees_hit
