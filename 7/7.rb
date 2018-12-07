def parse(str)
  str.sub("S", "").gsub(/[a-z.]/, "").split(" ")
end

def construct_dependencies(input)
  dependencies = {}
  input.each do |dependency, dependent|
    dependencies[dependency] ||= []
    dependencies[dependent] ||= []
    dependencies[dependent].push(dependency)
  end
  dependencies
end

def solution_1(input)
  order = ""
  # lazy deep dup
  dependencies = Marshal.load(Marshal.dump(input))
  until dependencies.empty?
    available = dependencies.select { |k, v| v.empty? }
    next_done, _ = available.sort_by(&:first).first
    dependencies.delete(next_done)
    order += next_done
    dependencies.each { |k, v| v.delete(next_done) }
  end
  order
end

input = construct_dependencies(File.new("input").read.chomp.split("\n").map { |str| parse(str) })
puts solution_1(input)
