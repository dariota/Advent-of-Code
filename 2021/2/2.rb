def p1(command_pairs)
  horizontal = 0
  depth = 0

  command_pairs.each do |command, step|
    case command
    when "forward" then horizontal += step
    when "up" then depth -= step
    when "down" then depth += step
    end
  end
  
  puts "Problem 1: #{horizontal * depth}"
end

def p2(command_pairs)
  horizontal = 0
  depth = 0
  aim = 0

  command_pairs.each do |command, step|
    case command
    when "forward" then 
      horizontal += step
      depth += aim * step
    when "up" then aim -= step
    when "down" then aim += step
    end
  end
  
  puts "Problem 2: #{horizontal * depth}"
end

input = File.open("input").readlines.map(&:chomp)
command_pairs = input.map(&:split).map { |command, step| [command, step.to_i] }

p1(command_pairs)
p2(command_pairs)
