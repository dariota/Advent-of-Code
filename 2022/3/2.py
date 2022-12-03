file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def char_to_prio(char):
    if char >= 'a':
        return ord(char) - ord('a')
    else:
        return ord(char) - ord('A') + 26

prio_sum = 0
for group_number in range(0, len(input), 3):
    rucksacks = input[group_number:group_number+3]

    shared = [0] * 52
    for rucksack in rucksacks:
        prios = [False] * 52
        for char in rucksack:
            prio = char_to_prio(char)
            if not prios[prio]:
                shared[prio] += 1
                prios[prio] = True

    prio_sum += shared.index(3) + 1

print(prio_sum)
