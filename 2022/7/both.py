import functools
import operator

file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def dir(structure, current_path):
    dir = structure

    for path_part in current_path:
        # Create dirs only when we need them to simplify parsing
        if not path_part in dir:
            dir[path_part] = {}
        dir = dir[path_part]

    return dir


def is_dir(value):
    return not isinstance(value, int)


def dir_size(dir):
    size = 0
    for value in dir.values():
        if is_dir(value):
            size += dir_size(value)
        else:
            size += value

    return size


def sum_dirs(structure):
    my_size = dir_size(structure)
    if my_size > 100000:
        my_size = 0

    return my_size + functools.reduce(operator.add, map(sum_dirs, filter(is_dir, structure.values())), 0)


def least_dir(structure, min_size):
    my_size = dir_size(structure)
    if my_size < min_size:
        return None

    smallest_child = list(filter(lambda size: size != None, map(lambda dir: least_dir(dir, min_size), filter(is_dir, structure.values()))))
    if smallest_child != []:
        return min(smallest_child)
    else:
        return my_size


current_path = []
structure = {}

for line in input:
    parts = line.split(" ")
    if parts[0] == "$":
        if parts[1] == "ls":
            continue

        if parts[2] == "/":
            current_path = []
        elif parts[2] == "..":
            current_path.pop()
        else:
            current_path.append(parts[2])
    elif parts[0] != "dir":
        # If we're not running a command, we're seeing ls output, and we can ignore
        # dir creation because we do it just in time
        dir(structure, current_path)[parts[1]] = int(parts[0])

print("P1: %s" % sum_dirs(structure))

unused_space = 70000000 - dir_size(structure)
space_needed = 30000000 - unused_space
print("P2: %s" % least_dir(structure, space_needed))
