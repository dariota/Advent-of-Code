input = File.open("input").lines.map(&:chomp)

passports = input.slice_when { |_, j| j.empty? }
passport_kv_pairs = passports.map { |pass| pass.flat_map { |line| line.split(" ") } }
passport_keys = passport_kv_pairs.map { |pass| pass.map { |kv| kv.split(":").first } }

required_keys = %w[byr iyr eyr hgt hcl ecl pid]

valid_count = passport_keys.select { |keys| (required_keys - keys).empty? }.count

puts valid_count
