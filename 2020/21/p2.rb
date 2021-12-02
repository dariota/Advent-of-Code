require 'set'

input = File.open("input").lines.map(&:chomp)

def parse_menu(line)
  parts = line.split(" (contains ")
  ingredients = parts[0].split(" ")
  allergens = parts[1].sub(")", "").split(", ")
  [ingredients, allergens]
end

all_ingredients = Hash.new(0)
allergen_potential = {}
input.each do |line|
  ingredients, allergens = parse_menu(line)
  ingredients.each { |ingredient| all_ingredients[ingredient] += 1 }

  #puts "ingredients: #{ingredients}, allergens: #{allergens}"
  allergens.each do |allergen|
    allergen_potential[allergen] = if allergen_potential.key?(allergen)
      old_list = allergen_potential[allergen] 
      #puts "subsequent time for #{allergen}, old list: #{old_list}, ingredients #{ingredients}, shortlist #{old_list & ingredients}"
      old_list & ingredients
    else
      #puts "first time for #{allergen}, seed list #{ingredients}"
      ingredients
    end
  end
end

next_certainty_list = allergen_potential.select { |_,v| v.size == 1 }.values.flatten
certainty_list = nil
until next_certainty_list == certainty_list
  certainty_list = next_certainty_list
  allergen_potential.each do |k,v|
    next if v.size == 1

    allergen_potential[k] = v - certainty_list
  end
  next_certainty_list = allergen_potential.select { |_,v| v.size == 1 }.values.flatten
end

puts allergen_potential.select { |_, v| v.size == 1 }.sort_by(&:first).map(&:last).join(",")
