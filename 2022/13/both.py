import json
import functools
import operator

file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def valid_pair(left, right):
    if isinstance(left, int) and isinstance(right, int):
        if left < right:
            return -1
        elif left == right:
            return 0
        else:
            return 1
    elif isinstance(left, list) and not isinstance(right, list):
        return valid_pair(left, [right])
    elif not isinstance(left, list) and isinstance(right, list):
        return valid_pair([left], right)
    else:
        left_size = len(left)
        right_size = len(right)
        for i in range(left_size):
            if i >= right_size:
                return 1

            compare_result = valid_pair(left[i], right[i])
            if compare_result != 0:
                return compare_result

        if left_size < right_size:
            return -1
        elif left_size == right_size:
            return 0
        else:
            return 1


def p1(pairs):
    sums = functools.reduce(
        operator.add,
        map(
            lambda index_pair: index_pair[0] + 1 if valid_pair(index_pair[1][0], index_pair[1][1]) == -1 else 0,
            enumerate(pairs)
        )
    )
    print("P1: %s" % sums)


def p2(pairs):
    unpacked = []
    for pair in pairs:
        unpacked.append(pair[0])
        unpacked.append(pair[1])

    unpacked.append([[2]])
    unpacked.append([[6]])
    unpacked.sort(key=functools.cmp_to_key(valid_pair))
    print("P2: %s" % ((unpacked.index([[2]]) + 1) * (unpacked.index([[6]]) + 1)))


pairs = []
for i in range(0, len(input), 3):
    pairs.append((json.loads(input[i]), json.loads(input[i + 1])))

p1(pairs)
p2(pairs)
