class Claim
	PARSE_PATTERN = /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/
	attr_reader :id, :x, :y, :w, :h
	attr_accessor :overlapped

	def initialize(str)
		values = Claim::PARSE_PATTERN.match(str)
		@overlapped = false
		@id = values[1].to_i
		@x = values[2].to_i
		@y = values[3].to_i
		@w = values[4].to_i
		@h = values[5].to_i
	end
end

def fill_cloth(claims)
	cloth = Hash.new(0)
	overlap_bitmap = {}
	claims.each { |id, claim|
		(0..claim.w-1).each { |w|
			(0..claim.h-1).each { | h|
				key = [claim.x + w, claim.y + h]
				cloth[key] = cloth[key] + 1
				if overlap_bitmap.key? key
					claims[overlap_bitmap[key]].overlapped = true
					claim.overlapped = true
				end
				overlap_bitmap[key] = id
			}
		}
	}
	cloth
end

def parse_claims(file)
	Hash[file.read.chomp.split("\n").map{|str| Claim.new(str)}.map{|claim| [claim.id, claim]}]
end

def solution_1(cloth)
	cloth.select{ |_,v| v >= 2 }.length
end

def solution_2(claims)
	claims.values.reject(&:overlapped).first
end

claims = parse_claims(File.new("input"))
cloth = fill_cloth(claims)

puts solution_1(cloth)
puts solution_2(claims).id
