file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

score = 0
for game in input:
    theirs = ord(game[0]) - ord('A')
    outcome = ord(game[2]) - ord('X')
    score += outcome * 3 + 1
    if outcome == 0:
        score += (theirs + 2) % 3
    elif outcome == 1:
        score += theirs
    else:
        score += (theirs + 1) % 3

print(score)
