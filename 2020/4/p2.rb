started = Time.now
input = File.open("input").lines.map(&:chomp)

passports = input.slice_when { |_, j| j.empty? }
passport_kv_pairs = passports.map { |pass| pass.flat_map { |line| line.split(" ") } }
required_keys = %w[byr iyr eyr hgt hcl ecl pid]
valid_count = passport_kv_pairs.select do |pass_arr|
  pass = pass_arr.inject({}) do |hsh, kv|
    key, value = kv.split(":")
    hsh[key] = value
    hsh
  end
  next false unless (required_keys - pass.keys).empty?

  eye_colours = %w[amb blu brn gry grn hzl oth]

  (1920..2002).cover?(pass["byr"].to_i) &&
    (2010..2020).cover?(pass["iyr"].to_i) &&
    (2020..2030).cover?(pass["eyr"].to_i) &&
    (pass["hgt"].end_with?("cm") && (150..193).cover?(pass["hgt"].to_i) ||
     pass["hgt"].end_with?("in") && (59..76).cover?(pass["hgt"].to_i)) &&
    pass["hcl"].match?(/^#[0-9a-f]{6,6}$/) &&
    eye_colours.include?(pass["ecl"]) &&
    pass["pid"].match?(/^\d{9,9}$/)
end.count

#puts valid_count
puts Time.now - started
