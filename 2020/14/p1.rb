input = File.open("input").lines.map(&:chomp)

memory = {}

and_mask = 0xFFFF
or_mask = 0

instructions = input[0..]
instructions.each do |instruction|
  if instruction.start_with?("mem")
    instruction_matches = instruction.match(/^mem\[(\d+)\] = (\d+)$/)
    address = instruction_matches[1].to_i
    value = instruction_matches[2].to_i

    masked_value = (value | or_mask) & and_mask
    memory[address] = masked_value
  elsif instruction.start_with?("mask")
    raw_mask = instruction.split(" = ").last
    and_mask = raw_mask.gsub('X', '1').to_i(2)
    or_mask = raw_mask.gsub('X', '0').to_i(2)
  else
    puts "Instruction: '#{instruction}' invalid"
    raise ArgumentError
  end
end

puts memory.values.sum
