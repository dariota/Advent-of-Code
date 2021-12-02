input = File.open("input").lines.first.split(",").map(&:to_i)

rolling = {}
input.each_index do |ind|
  #puts "Turn #{ind + 1}: #{input[ind]}"
  rolling[input[ind]] = ind + 1
  #puts "rolling[#{input[ind]}] = #{ind + 1}"
end
current_turn = rolling.values.max + 1
last_spoken = input.last

started = Time.now
until current_turn == 2021
  previous_spoken_turn = rolling[last_spoken]
  #puts "last number: #{last_spoken}, last turn spoken: #{previous_spoken_turn}"
  next_number = if previous_spoken_turn
    current_turn - previous_spoken_turn - 1
  else
    0
  end
  #puts "Turn #{current_turn}: #{next_number}"
  #puts "rolling[#{last_spoken}]: #{current_turn - 1}"
  rolling[last_spoken] = current_turn - 1
  last_spoken = next_number
  current_turn += 1
end

puts last_spoken
puts Time.now - started
