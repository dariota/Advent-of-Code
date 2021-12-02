started = Time.now
input = File.open("input").lines.map(&:chomp)

memory = {}

floating_bits = []
mask = nil

def set_address(memory, address, floating_bits, value, entry = "")

  bit = floating_bits.first
  if bit
    or_mask = 0xFFFFFFFFF & (1 << bit)
    and_mask = 0xFFFFFFFFF & ~or_mask
    set_address(memory, address | or_mask, floating_bits[1..], value, entry + " ")
    set_address(memory, address & and_mask, floating_bits[1..], value, entry + " ")
  else
    memory[address] = value
  end
end

instructions = input[0..]
instructions.each do |instruction|
  if instruction.start_with?("mem")
    instruction_matches = instruction.match(/^mem\[(\d+)\] = (\d+)$/)
    address = instruction_matches[1].to_i
    value = instruction_matches[2].to_i

    set_address(memory, address | mask, floating_bits, value)
  elsif instruction.start_with?("mask")
    raw_mask = instruction.split(" = ").last
    mask = raw_mask.gsub('X', '0').to_i(2)
    floating_bits = []
    last_index = -1
    next_index = nil
    until (next_index = raw_mask.index('X', last_index + 1)).nil?
      floating_bits << (raw_mask.length - 1 - next_index)
      last_index = next_index
    end
    raise "No floating bits after #{instruction}" if floating_bits.empty?
  else
    puts "Instruction: '#{instruction}' invalid"
    raise ArgumentError
  end
end

#puts memory.values.sum
puts Time.now - started
