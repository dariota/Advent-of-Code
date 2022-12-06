import re
import copy

file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def move_crates(moves, stacks, reverse_crates):
    for move in moves:
        matches = re.search(r"move (\d+) from (\d+) to (\d+)", move)
        count, src, dest = map(int, matches.groups())
        moving_crates = stacks[src - 1][-count:]
        if reverse_crates:
            moving_crates.reverse()

        stacks[dest - 1] += moving_crates
        del stacks[src - 1][-count:]

def solve(part, stacks, moves, reverse):
    my_stacks = copy.deepcopy(stacks)
    move_crates(moves, my_stacks, reverse)
    print("P%s: " % str(part), end="")
    list(map(lambda stack: print(stack.pop(), end=""), my_stacks))
    print("")

stack_end = input.index("")

stack_count = int((len(input[0]) + 1) / 4)
stacks = list(map(lambda x: [], range(0, stack_count)))
for input_ind in range(stack_end - 1, -1, -1):
    line = input[input_ind]
    for i in range(0, stack_count):
        char = line[i * 4 + 1]
        if char != " ":
            stacks[i].append(char)

moves = input[stack_end + 1:]

solve(1, stacks, moves, True)
solve(2, stacks, moves, False)
