file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def to_snafu(num):
    snafu = []
    carry = 0
    while num > 0 or carry != 0:
        num += carry
        curr = num % 5
        num = int(num / 5)
        if curr > 2:
            carry = 1
            curr = curr - 5
        else:
            carry = 0

        if curr == -1:
            curr = "-"
        elif curr == -2:
            curr = "="

        snafu.append(str(curr))

    return "".join(snafu[::-1])

def from_snafu(snafu):
    mult = 1
    num = 0
    for i in range(len(snafu) - 1, -1, -1):
        char = snafu[i]
        if char == "-":
            char = -1
        elif char == "=":
            char = -2
        else:
            char = int(char)

        num += char * mult
        mult *= 5

    return num

res = 0
for line in lines:
    res += from_snafu(line)

print("P1:", to_snafu(res))
