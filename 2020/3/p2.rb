started = Time.now
input = File.open("input").lines.map(&:chomp).map(&:chars)

height = input.length
width = input[0].length

tree_hits = []

[[1,1],[3,1],[5,1],[7,1],[1,2]].each do |x_inc, y_inc|
  x = 0
  y = 0

  trees_hit = 0

  until y >= height
    trees_hit += input[y][x] == "#" ? 1 : 0

    x = (x + x_inc) % width
    y = (y + y_inc)
  end

  tree_hits << trees_hit
end

#puts tree_hits.reduce(:*)
puts Time.now - started
