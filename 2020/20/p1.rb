require 'set'

started = Time.now
class Tile
  attr_reader :id, :border_values, :matching

  def initialize(id, border_values)
    @id = id
    @border_values = border_values
    @matching = Set.new
  end

  def find_matches(shared_borders)
    return if matching.size > 2 

    border_values.each do |v|
      tiles = shared_borders[v]
      next if tiles.count == 1

      tiles.each { |v| matching.add(v) if v != id }
    end
  end

  def self.parse(tile)
    id = tile.first.split(" ")[1].to_i

    pattern = tile[1..]
    pattern = pattern[0...-1] if pattern[-1].empty?

    border_values = []
    top = pattern[0]
    border_values << encode(top)
    border_values << encode(top.reverse)
    left = pattern.map { |line| line[0] }.join('')
    border_values << encode(left)
    border_values << encode(left.reverse)
    right = pattern.map { |line| line[-1] }.join('')
    border_values << encode(right)
    border_values << encode(right.reverse)
    bottom = pattern[-1]
    border_values << encode(bottom)
    border_values << encode(bottom.reverse)

    new(id, border_values)
  end

  def self.encode(line)
    line.gsub('.', '0').gsub('#', '1').to_i(2)
  end
end

input = File.open("input").lines.map(&:chomp).slice_when { |line| line.empty? }.to_a

tiles = input.map { |tile| Tile.parse(tile) }
shared_borders = {}
tiles.each do |tile|
  tile.border_values.each do |v|
    shared_borders[v] ||= []
    shared_borders[v] << tile.id
  end
end

tiles.each do |tile|
  tile.find_matches(shared_borders)
end

result = tiles.select { |tile| tile.matching.size == 2 }.map(&:id).reduce(:*)
puts Time.now - started
puts result
