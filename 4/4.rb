require "date"

class LogLine
	attr_reader :relevant_date, :value, :kind
	
	def initialize(line)
		parts = line.sub("[", "").split ("] ")
		
		@relevant_date = DateTime.parse(parts[0])
		# handle shifts starting before midnight
		if relevant_date.hour != 0
			@relevant_date = relevant_date.next_day
		end
		
		@kind = to_kind(parts[1])
		if kind == :identifier
			@value = /#(\d+)\s/.match(parts[1])[1].to_i
		else
			@value = @relevant_date.minute
		end
		
		@relevant_date = "#{relevant_date.month}-#{relevant_date.day}"
	end
	
	def to_kind(str)
		return :awake if str == "wakes up"
		return :asleep if str == "falls asleep"
		:identifier
	end
end

def guard_times(input)
	guard_data = input.group_by(&:relevant_date)
	guard_times = {}
	guard_data.each do |date, date_logs|
		guard_id = date_logs.find{ |log| log.kind == :identifier }.value
		guard_times[guard_id] = guard_times[guard_id] || Hash.new(0)
		asleep_at = nil
		date_logs.each do |log|
			if log.kind == :asleep
				asleep_at = log.value
			elsif log.kind == :awake
				(asleep_at..log.value-1).each { |v| guard_times[guard_id][v] += 1 }
			end
		end
	end
	
	guard_times.reject { |_, times| times.empty? }
end

def solution_1(input)
	id, times = guard_times(input).max_by { |id, times| times.values.reduce(:+) }
	id * times.max_by(&:last).first
end

def solution_2(input)
	times = guard_times(input)
	id = times.map do |id, times|
		minute, frequency = times.max_by(&:last)
		[id, frequency]
	end.max_by(&:last).first
	id * times[id].max_by(&:last).first
end

input = File.new("input").read.chomp.split("\n").sort.map{|s| LogLine.new(s)}
puts solution_1(input)
puts solution_2(input)
