file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def char_to_prio(char):
    if char >= 'a':
        return ord(char) - ord('a')
    else:
        return ord(char) - ord('A') + 26

prio_sum = 0
for rucksack in input:
    prios = [False] * 52
    midpoint = int(len(rucksack) / 2)
    # Populate first compartment items
    for char in rucksack[0:midpoint:1]:
        prios[char_to_prio(char)] = True

    # Check second compartment items
    for char in rucksack[midpoint:len(rucksack):1]:
        if prios[char_to_prio(char)]:
            prio_sum += char_to_prio(char) + 1
            break

print(prio_sum)
