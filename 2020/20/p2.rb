started = Time.now

class Transform
  attr_reader :rotation, :flip, :other_flip
  
  def initialize(rotation, flip, other_flip = false)
    @rotation = rotation
    @flip = flip
    @other_flip = other_flip
  end

  def self.distinct
    [false, true].product((0..3).to_a).map do |flip, rotation|
      new(rotation, flip)
    end
  end

  def self.all
    [false, true].product([false, true], (0..3).to_a).map do |flip, other_flip, rotation|
      new(rotation, flip, other_flip)
    end
  end
end

class Tile
  attr_reader :id, :matching, :variations

  def initialize(id, pattern)
    @id = id
    @variations = all_variations(pattern)
    @matching = []
  end

  def border_values
    @border_values ||= variations.map(&:right).uniq
  end

  def all_variations(pattern)
    Transform.distinct.map do |transformation|
      hsh = Tile.transform(pattern, transformation)
      PlacedTile.new(Tile.extract_borders(hsh), Tile.extract_pattern(hsh), self)
    end.uniq
  end

  def self.transform(pattern, transformation)
    pattern_length = pattern.length

    transformed = []
    default_val = '.'.ord
    pattern_length.times { transformed << String.new('.' * pattern_length, capacity: pattern_length) }
    dec_length = pattern_length - 1
    rotation = transformation.rotation
    flip = transformation.flip
    other_flip = transformation.other_flip
    pattern.each_index do |y|
      y_row = pattern[y]
      pattern_length.times do |x|
        curr_byte = y_row.getbyte(x)
        next if curr_byte == default_val

        # precomputed 90 degree rotations
        case rotation
        when 0
          mapped_y = y
          mapped_x = x
        when 1
          mapped_y = x
          mapped_x = dec_length - y
        when 2
          mapped_y = dec_length - y
          mapped_x = dec_length - x
        when 3
          mapped_y = dec_length - x
          mapped_x = y
        end

        if flip
          mapped_y = dec_length - mapped_y
        end

        if other_flip
          mapped_x = dec_length - mapped_x
        end

        transformed[mapped_y].setbyte(mapped_x, curr_byte)
      end
    end

    transformed
  end

  def self.parse(tile)
    id = tile.first.split(" ")[1].to_i

    pattern = tile[1..]
    pattern = pattern[0...-1] if pattern[-1].empty?

    new(id, pattern)
  end

  def self.extract_pattern(pattern)
    pattern[1..-2].map { |line| line[1..-2] }
  end

  def self.extract_borders(pattern)
    multi_encode({
      top: pattern[0],
      left: pattern.map { |line| line[0] }.join(''),
      right: pattern.map { |line| line[-1] }.join(''),
      bottom: pattern[-1],
    })
  end

  def self.multi_encode(borders)
    encoded = {}
    borders.each do |k, v|
      encoded[k] = encode(v)
    end
    encoded
  end

  def self.encode(line)
    line.gsub('.', '0').gsub('#', '1').to_i(2)
  end
end

class PlacedTile
  attr_reader :id, :borders, :pattern

  def initialize(borders, pattern, canonical)
    @id = canonical.id
    @borders = borders
    @pattern = pattern
    @canonical = canonical
  end

  def matching
    @canonical.matching
  end

  def top
    @top ||= borders[:top]
  end

  def left
    @left ||= borders[:left]
  end

  def right
    @right ||= borders[:right]
  end

  def bottom
    @bottom ||= borders[:bottom]
  end

  def hash
    @hash ||= begin
      ((top & 0xFF) << 24) |
        ((right & 0xFF) << 16) |
        ((bottom & 0xFF) << 8) |
        (left & 0xFF)
    end
  end

  def eql?(other)
    other.is_a?(PlacedTile) &&
      other.left == left &&
      other.top == top &&
      other.bottom == bottom &&
      other.right == right
  end
end

input = File.open("input").lines.map(&:chomp).slice_when { |line| line.empty? }.to_a

tiles = input.map { |tile| Tile.parse(tile) }

tile_hash = {}
tiles.each { |tile| tile_hash[tile.id] = tile }
border_mapping = {}
tiles.each do |tile|
  tile.border_values.each do |value|
    border_mapping[value] ||= []
    border_mapping[value] << tile.id
  end
end
border_mapping.select { |_,v| v.size > 1 }.each do |value, ids|
  ids.each do |id|
    tile_hash[id].matching.concat(ids - [id])
  end
end
tiles.each { |tile| tile.matching.uniq! }

square_side = Math.sqrt(input.count).round
raise "Non square number of tiles #{input.count}" unless square_side * square_side == input.count

def fill(tiling, used_ids, tiles, x, y)
  return true if y == tiling.length

  left_tile = tiling[y][x - 1] if x > 0
  top_tile = tiling[y - 1][x] if y > 0

  candidate_ids = if left_tile && top_tile
    left_tile.matching & top_tile.matching
  elsif left_tile
    left_tile.matching
  elsif top_tile
    top_tile.matching
  else
    raise "no nearby tiles?"
  end
  candidate_ids = candidate_ids.reject { |id| used_ids[id] }
  return false if candidate_ids.empty?

  candidate_tiles = tiles.select { |tile| candidate_ids.include?(tile.id) }.flat_map(&:variations)
  if left_tile
    candidate_tiles.select! { |tile| tile.left == left_tile.right }
  end
  if top_tile
    candidate_tiles.select! { |tile| tile.top == top_tile.bottom }
  end

  return false if candidate_tiles.empty?

  candidate_tiles.each do |tile|
    used_ids[tile.id] = true
    tiling[y][x] = tile

    next_x = (x + 1) % tiling.length
    next_y = next_x.zero? ? y + 1 : y
    return true if fill(tiling, used_ids, tiles, next_x, next_y)

    tiling[y].delete_at(x)
    used_ids[tile.id] = false
  end

  false
end

def stitch(tiling)
  stitched = []
  tiling.each do |row|
    stitched_block = row.first.pattern.map(&:dup)
    row[1..].each do |block|
      block.pattern.each_index do |ind|
        stitched_block[ind] += block.pattern[ind]
      end
    end
    stitched << stitched_block
  end
  stitched.flatten
end

corners = tiles.select { |tile| tile.matching.count == 2 }
image = nil
tiling = []
square_side.times { tiling << [] }
max_id = tiles.max_by(&:id).id
corners.each do |corner|
  used_ids = Array.new(max_id)
  used_ids[corner.id] = true
  corner.variations.each do |variation|
    tiling[0][0] = variation
    if fill(tiling, used_ids, tiles, 1, 0)
      image = stitch(tiling)
      break
    end
  end
  break if image
end
raise "should have found an image" unless image

def find_monsters(image)
  monsters = 0
  monster_top = /..................#./
  monster_middle = /#....##....##....###/
  monster_bottom = /.#..#..#..#..#..#.../
  image.each_index do |y|
    next if y.zero? || y == image.length - 1

    pos = 0
    while pos = image[y].index(monster_middle, pos)
      if image[y - 1].index(monster_top, pos) == pos &&
          image[y + 1].index(monster_bottom, pos) == pos
        monsters += 1
      end
      pos += 1
    end
  end

  monsters
end

monster_size = 15
Transform.all.map do |transform|
  image = Tile.transform(image, transform)
  monster_count = find_monsters(image)
  next if monster_count.zero?

  puts image.map(&:chars).flatten.select { |c| c == "#" }.length - monster_size * monster_count
  break
end

puts Time.now - started
