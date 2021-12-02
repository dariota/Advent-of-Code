input = File.open("input").lines.map(&:chomp).slice_when { |line| line.empty? }.to_a

first_hand = input[0][1..-2].map(&:to_i)
second_hand = input[1][1..-1].map(&:to_i)

until first_hand.empty? || second_hand.empty?
  first_card = first_hand.slice!(0)
  second_card = second_hand.slice!(0)

  if first_card > second_card
    first_hand.concat([first_card, second_card])
  else
    second_hand.concat([second_card, first_card])
  end
end

first_hand = first_hand.empty? ? second_hand : first_hand
hand_size = first_hand.size
sum = 0

(1..hand_size).each do |mul|
  sum += first_hand[hand_size - mul] * mul
end

puts sum
