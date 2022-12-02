file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

score = 0
for game in input:
    theirs = ord(game[0]) - ord('A')
    mine = ord(game[2]) - ord('X')
    score += mine + 1
    if theirs == mine:
        score += 3
    elif ((theirs + 1) % 3) == mine:
        score += 6

print(score)
