test_input = File.readlines("input.test", chomp: true)
input = File.readlines("input", chomp: true)

def reflective_at(pattern, pos)
    distance = [pos, pattern.length - 2 - pos].min

    (0..distance).all? do |offset|
      yield(pattern[pos - offset], pattern[pos + offset + 1])
    end
end

def find_reflection(pattern, clean)
  binarised = pattern.map { |line| line.chars.reduce(0) { |acc, char| (acc << 1) + (char == '#' ? 1 : 0) } }

  (0...binarised.length-1).find do |ind|
    used = clean

    reflective_at(binarised, ind) do |a, b|
      match = a ^ b
      # If it's an exact match, keep checking
      next true if match.zero?

      # If it's off by one and we haven't used our smudge, use it and keep checking
      if popcount(match) == 1 && !used
        next used = true
      end

      false
    end && used
  end
end

def rotate(pattern)
  pattern.map(&:chars).transpose.map { |l| l.reverse.join("") }
end

# https://stackoverflow.com/a/1641048
def popcount(x)
  m1 = 0x55555555
  m2 = 0x33333333
  m4 = 0x0f0f0f0f
  x -= (x >> 1) & m1
  x = (x & m2) + ((x >> 2) & m2)
  x = (x + (x >> 4)) & m4
  x += x >> 8
  return (x + (x >> 16)) & 0x3f
end

def solution(input, is_clean)
  patterns = input.chunk(&:empty?).reject(&:first).map(&:last)
  patterns.sum do |pattern|
    horizontal = find_reflection(pattern, is_clean)
    if !horizontal.nil?
     (horizontal + 1) * 100
    else
      find_reflection(rotate(pattern), is_clean) + 1
    end
  end
end

puts "Problem 1 (test): #{solution(test_input, true)}"
puts "Problem 1: #{solution(input, true)}"
puts "Problem 2 (test): #{solution(test_input, false)}"
puts "Problem 2: #{solution(input, false)}"
