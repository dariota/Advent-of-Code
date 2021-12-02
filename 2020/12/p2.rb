started = Time.now
input = File.open("input").lines.map(&:chomp)

coords = { x: 0, y: 0 }
# relative to ship
waypoint = { x: 10, y: 1 }

def rotate_waypoint(waypoint, rotation)
  x = waypoint[:x]
  y = waypoint[:y]
  case rotation
  when 90
    waypoint[:x] = y
    waypoint[:y] = -x
  when 180
    waypoint[:x] = -x
    waypoint[:y] = -y
  when 270
    waypoint[:x] = -y
    waypoint[:y] = x
  else raise "unexpected rotation #{rotation}"
  end
end

input.each do |instruction|
  move = instruction[0]
  units = instruction[1..].to_i

  case move
  when "N"
    waypoint[:y] += units
  when "E"
    waypoint[:x] += units
  when "S"
    waypoint[:y] -= units
  when "W"
    waypoint[:x] -= units
  when "R"
    rotate_waypoint(waypoint, units)
  when "L"
    rotate_waypoint(waypoint, 360 - units)
  when "F"
    coords[:x] += waypoint[:x] * units
    coords[:y] += waypoint[:y] * units
  end
end

#puts coords[:x].abs + coords[:y].abs
puts Time.now - started
