file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

changes = {}

cycle = 1
for line in input:
    if line == "noop":
        cycle += 1
    else:
        op, val = line.split(" ")
        cycle += 2
        changes[cycle] = int(val)

def p1(changes, max_cycle):
    strength = 1
    cumulative_signal_strength = 0
    for i in range(1, max_cycle + 1):
        if i in changes:
            strength += changes[i]

        if (i - 20) % 40 == 0:
            cumulative_signal_strength += i * strength

    print("P1: %s" % cumulative_signal_strength)


def p2(changes, max_cycle):
    print("P2:")
    pixel_pos = 1
    for i in range(0, max_cycle):
        if i + 1 in changes:
            pixel_pos += changes[i + 1]

        draw_pos = i % 40
        end = "" if draw_pos != 39 else "\n"
        char = "#" if (draw_pos >= pixel_pos - 1 and draw_pos <= pixel_pos + 1) else " "
        print(char, end=end)


p1(changes, cycle)
p2(changes, cycle)
