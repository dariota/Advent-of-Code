require 'set'

e2e_started = Time.now
class Tile

  def self.parse(tile, shared_borders)
    id = tile.first.split(" ")[1].to_i

    pattern = tile[1..]
    pattern = pattern[0...-1] if pattern[-1].empty?

    top = pattern[0].chars
    shared_borders[encode(top)] << id
    shared_borders[encode_reverse(top)] << id

    left = pattern.map { |line| line[0] }
    shared_borders[encode(left)] << id
    shared_borders[encode_reverse(left)] << id

    right = pattern.map { |line| line[-1] }
    shared_borders[encode(right)] << id
    shared_borders[encode_reverse(right)] << id

    bottom = pattern[-1].chars
    shared_borders[encode(bottom)] << id
    shared_borders[encode_reverse(bottom)] << id

    id
  end

  def self.encode(line)
    encoded = 0
    mul = 1
    line.reverse_each do |char|
      if char == '#'
        encoded |= mul
      end
      mul <<= 1
    end

    encoded
  end

  def self.encode_reverse(line)
    encoded = 0
    mul = 1
    line.each do |char|
      if char == '#'
        encoded |= mul
      end
      mul <<= 1
    end

    encoded
  end
end

input = File.open("input").lines.map(&:chomp).slice_when { |line| line.empty? }.to_a

tile_hash = Hash.new do |hsh, k|
  hsh[k] = []
end
shared_borders = Hash.new do |hsh, k|
  hsh[k] = []
end
input.each { |tile| Tile.parse(tile, shared_borders) }

shared_borders.each do |border, v|
  next if v.length == 1

  v.each do |id|
    tile_hash[id].concat(v.reject { |i| i == id })
  end
end

result = tile_hash.select! { |id, matches| matches.uniq!; matches.size == 2 }
result = result.reduce(1) { |memo, obj| memo * obj[0] }

puts Time.now - e2e_started
puts result
