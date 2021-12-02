input = File.open("input").lines.map(&:chomp)

heading = 90
coords = { x: 0, y: 0 }

heading_to_offset = {
  0 => [0, 1],
  90 => [1, 0],
  180 => [0, -1],
  270 => [-1, 0],
}

input.each do |instruction|
  move = instruction[0]
  units = instruction[1..].to_i

  case move
  when "N"
    coords[:y] += units
  when "E"
    coords[:x] += units
  when "S"
    coords[:y] -= units
  when "W"
    coords[:x] -= units
  when "R"
    heading += units
  when "L"
    heading -= units
  when "F"
    x_mul, y_mul = heading_to_offset[heading % 360]
    coords[:x] += x_mul * units
    coords[:y] += y_mul * units
  end
end

puts coords[:x].abs + coords[:y].abs
