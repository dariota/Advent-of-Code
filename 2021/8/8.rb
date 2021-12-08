class Notes
  BASE_MAPPING = {
    0 => "abcefg",
    1 => "cf",
    2 => "acdeg",
    3 => "acdfg",
    4 => "bcdf",
    5 => "abdfg",
    6 => "abdefg",
    7 => "acf",
    8 => "abcdefg",
    9 => "abcdfg",
  }.each_with_object({}) { |pair, hsh| hsh[pair.first] = pair.last.split("").to_a }
  INVERSE_MAPPING = BASE_MAPPING.invert

  attr_reader :output

  def initialize(input, output)
    @input = input.map { |arr| arr.split("") }
    @output = output
  end

  def find_mapping
    to_decode = @input.sort_by(&:length)
    decoding = to_decode.delete_at(0)
    known_mapping = {}
    potential_mappings = potential_mapping(decoding, known_mapping)

    to_decode.each do |decoding|
      new_mappings = potential_mapping(decoding, known_mapping)
      potential_mappings = potential_mappings.flat_map do |mapping|
        non_conflicting_mappings = new_mappings.select { |new_mapping| mapping.all? { |k,v| new_mapping[k] == v || !new_mapping.key?(k)} }
        non_conflicting_mappings.map { |new_mapping| new_mapping.merge(mapping) }
      end
      known_mapping = potential_mappings.first.dup.keep_if do |k,v|
        potential_mappings.all? { |mapping| mapping[k] == v }
      end
    end
    raise @input unless potential_mappings.count == 1

    potential_mappings.first
  end

  def decode
    mapping = find_mapping
    output.map { |segments| INVERSE_MAPPING[segments.split("").map { |k| mapping[k] }.sort] }.reduce { |ac, i| ac = ac * 10 + i }
  end

  private def potential_mapping(input, known_mapping)
    candidate_values = BASE_MAPPING.select { |k,v| v.length == input.length }
    permutations = input.reject { |k| known_mapping.key?(k) }.permutation

    mappings_by_candidate = candidate_values.values.map do |candidate|
      unknown_candidate = candidate.reject { |k| known_mapping.values.include?(k) }
      permutations.map { |perm| perm.zip(unknown_candidate) }
    end
    mappings_by_candidate.flat_map { |candidate_mappings| candidate_mappings.flat_map { |mapping| Hash[mapping] } }.uniq
  end

  def self.parse(line)
    inputs, outputs = line.split(" | ")
    Notes.new(inputs.split(" "), outputs.split(" "))
  end
end

def problem_1(signals)
  outputs = signals.flat_map(&:output)
  unique_lengths = [2, 4, 3, 7]
  outputs.count { |output| unique_lengths.include?(output.length) }
end

def problem_2(signals)
  signals.map(&:decode).sum
end

signals = File.readlines("input", chomp: true).map { |line| Notes.parse(line) }

puts "Problem 1: #{problem_1(signals)}"
puts "Problem 2: #{problem_2(signals)}"
