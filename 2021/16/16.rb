class Stream
  attr_reader :position

  def initialize(hex_string)
    binary = hex_string.to_i(16).to_s(2)
    padding = "0" * (hex_string.length * 4 - binary.length)

    @content = padding + binary
    @position = 0
  end

  def advance(length)
    chunk = @content[@position...(@position + length)]
    @position += length
    chunk.to_i(2)
  end

  def to_s
    "#{@content}\n" +
      " " * @position +
      "^"
  end
end

class Packet

  attr_reader :version, :type, :content

  TYPE_MAPPING = {
    0 => :sum,
    1 => :product,
    2 => :minimum,
    3 => :maximum,
    4 => :literal,
    5 => :greater,
    6 => :less,
    7 => :equal,
  }


  def initialize(version, type, content)
    @version = version
    @type = type
    @content = content

    validate_type!
  end

  def value
    case type
    when :literal
      content
    when :sum
      content.map(&:value).sum
    when :product
      content.map(&:value).reduce(:*)
    when :minimum
      content.map(&:value).min
    when :maximum
      content.map(&:value).max
    when :greater
      (content.first.value > content.last.value) ? 1 : 0
    when :less
      (content.first.value < content.last.value) ? 1 : 0
    when :equal
      (content.first.value == content.last.value) ? 1 : 0
    end
  end

  def validate_type!
    case type
    when :sum, :product, :minimum, :maximum
      raise "#{type} needs a subpacket" unless content.is_a?(Array) && content.any?
    when :greater, :less, :equal
      raise "#{type} needs exactly two subpackets" unless content.is_a?(Array) && content.count == 2
    end
  end

  def self.parse(string_or_stream)
    stream = if string_or_stream.is_a?(Stream)
      # When parsing a nested packet we want to pick up where we left off, and let the next packet parsed pick up where
      # we left off, which the stream will manage for us.
      string_or_stream
    else
      # Otherwise, we're just starting to parse and need to manage the stream from here
      Stream.new(string_or_stream)
    end

    version = stream.advance(3)
    type = TYPE_MAPPING[stream.advance(3)]

    parse_type(version, type, stream)
  end

  def self.parse_type(version, type, stream)
    if type == :literal
      content = 0
      until stream.advance(1) == 0
        content += stream.advance(4)
        content = content << 4
      end
      content += stream.advance(4)

      Packet.new(version, type, content)
    else # operator
      if stream.advance(1) == 0
        subpacket_length = stream.advance(15)
        start_position = stream.position
        subpackets = []

        until stream.position >= start_position + subpacket_length
          subpackets << parse(stream)
        end

        raise "Read too far" unless stream.position == start_position + subpacket_length

        Packet.new(version, type, subpackets)
      else
        subpacket_count = stream.advance(11)
        subpackets = []

        until subpackets.count == subpacket_count
          subpackets << parse(stream)
        end

        Packet.new(version, type, subpackets)
      end
    end
  end
end

def problem_1(input)
  def sum_versions(packet)
    if packet.type == :literal
      packet.version
    else
      packet.version + packet.content.map { |subpacket| sum_versions(subpacket) }.sum
    end
  end

  sum_versions(Packet.parse(input))
end

def problem_2(input)
  Packet.parse(input).value
end

input = File.readlines("input", chomp: true).first

puts "Problem 1: #{problem_1(input)}"
puts "Problem 2: #{problem_2(input)}"
