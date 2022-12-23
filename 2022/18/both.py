file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def adjacencies(pos):
    x, y, z = pos
    return [
            (x    , y    , z - 1),
            (x    , y    , z + 1),
            (x    , y - 1, z    ),
            (x    , y + 1, z    ),
            (x - 1, y    , z    ),
            (x + 1, y    , z    )
           ]

placed = set()
min_x = max_x = min_y = max_y = min_z = max_z = None
exposed = 0
for line in lines:
    x, y, z = list(map(int, line.split(",")))
    if min_x is None or x < min_x:
        min_x = x
    if max_x is None or x > max_x:
        max_x = x
    if min_y is None or y < min_y:
        min_y = y
    if max_y is None or y > max_y:
        max_y = y
    if min_z is None or z < min_z:
        min_z = z
    if max_z is None or z > max_z:
        max_z = z

    pos = (x, y, z)
    touching = sum([1 if adj in placed else 0 for adj in adjacencies(pos)])
    exposed = exposed - touching + 6 - touching
    placed.add(pos)

print("P1:", exposed)

# List of lists of lists representing 3D space, covering min_coord - 1 to min_coord + 1 on every axis
# This ensures a layer around the shape to fill in, so any air must be inside it
space = []
x_dim = max_x - min_x
y_dim = max_y - min_y
z_dim = max_z - min_z
for x in range(0, x_dim + 3):
    space.append([[False] * (z_dim + 3) for y in range(0, y_dim + 3)])

for pos in placed:
    space_x = pos[0] + (1 - min_x)
    space_y = pos[1] + (1 - min_y)
    space_z = pos[2] + (1 - min_z)
    space[space_x][space_y][space_z] = True

# Starting from a corner, fill in every square reachable within the space
front = { (0,0,0) }
space[0][0][0] = True
while len(front) != 0:
    next_front = set()
    for pos in front:
        for x, y, z in adjacencies(pos):
            if x < 0 or y < 0 or z < 0:
                continue
            if x >= len(space) or y >= len(space[x]) or z >= len(space[x][y]):
                continue
            if not space[x][y][z]:
                next_front.add((x, y, z))
    
    for pos in next_front:
        space[pos[0]][pos[1]][pos[2]] = True
    front = next_front

# For every item in the space that's not full, remove count of reachable sides from total
# as these are necessarily within the shape
trapped_faces = 0
for x in range(len(space)):
    x_val = space[x]
    for y in range(len(x_val)):
        y_val = x_val[y]
        for z in range(len(y_val)):
           z_val = y_val[z]
           if not z_val:
               for other_x, other_y, other_z in adjacencies((x,y,z)):
                   if space[other_x][other_y][other_z]:
                       trapped_faces += 1

print("P2:", exposed - trapped_faces)
