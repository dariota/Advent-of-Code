file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

full_overlaps = 0
for line in input:
    pair = list(map(lambda s: list(map(lambda i: int(i), s.split("-"))), line.split(",")))
    if (pair[0][0] <= pair[1][0] and pair[0][1] >= pair[1][1] or
        pair[1][0] <= pair[0][0] and pair[1][1] >= pair[0][1]):
        full_overlaps += 1

print(full_overlaps)
