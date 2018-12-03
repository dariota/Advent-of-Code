class Claim
	PARSE_PATTERN = /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/
	attr_reader :id, :x, :y, :w, :h
	
	def initialize(str)
		values = Claim::PARSE_PATTERN.match(str)
		@id = values[1].to_i
		@x = values[2].to_i
		@y = values[3].to_i
		@w = values[4].to_i
		@h = values[5].to_i
	end
end

def fill_cloth(claims)
	cloth = Hash.new(0)
	claims.each { |claim|
		(0..claim.w-1).each { |w|
			(0..claim.h-1).each { | h|
				key = [claim.x + w, claim.y + h]
				cloth[key] = cloth[key] + 1
			}
		}
	}
	cloth
end

def parse_claims(file)
	claims = file.read.chomp.split("\n").map{|str| Claim.new(str)}
end

def solution_1(filename)
	claims = parse_claims(File.new(filename))
	cloth = fill_cloth(claims)
	cloth.select{ |_,v| v >= 2 }.length
end

puts solution_1("input")
