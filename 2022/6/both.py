file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def find_start(transmission, characters_needed):
    chars = {}
    for char in transmission[0:characters_needed]:
        if char in chars:
            chars[char] += 1
        else:
            chars[char] = 1

    chars_processed = characters_needed
    while chars_processed < len(transmission) and len(chars) < characters_needed:
        char = transmission[chars_processed]
        if char in chars:
            chars[char] += 1
        else:
            chars[char] = 1

        removed_char = transmission[chars_processed - characters_needed]
        if chars[removed_char] == 1:
            del chars[removed_char]
        else:
            chars[removed_char] -= 1

        chars_processed += 1

    return chars_processed

print("P1: %s" % str(find_start(input[0], 5)))
print("P2: %s" % str(find_start(input[0], 14)))
