file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def bounds(lines):
    min_x, min_y, max_x, max_y = (500, 0, 500, None)

    for line in lines:
        for coord in line.split(" -> "):
            x, y = coord.split(",")
            if min_x > int(x):
                min_x = int(x)
            if max_x < int(x):
                max_x = int(x)
            if min_y > int(y):
                min_y = int(y)
            if max_y is None or max_y < int(y):
                max_y = int(y)

    return (min_x, min_y, max_x, max_y)


def build_grid(lines, bounds):
    min_x, min_y, max_x, max_y = bounds

    grid = [] 
    for _y in range(min_y, max_y + 1):
        row = []
        for _x in range(min_x, max_x + 1):
            row.append(False)
        grid.append(row)

    for line in lines:
        coords = list(map(lambda coord: list(map(int, coord.split(","))), line.split(" -> ")))
        for i in range(1, len(coords)):
            previous_x, previous_y = list(map(int, coords[i - 1]))
            current_x, current_y = list(map(int, coords[i]))
            from_x, to_x = (previous_x, current_x) if current_x > previous_x else (current_x, previous_x)
            from_y, to_y = (previous_y, current_y) if current_y > previous_y else (current_y, previous_y)
            for y in range(from_y, to_y + 1):
                for x in range(from_x, to_x + 1):
                    grid[y - min_y][x - min_x] = True

    return grid


# False if we've fallen out
# True if we've landed
def drop_sand(grid, start_x, start_y):
    if grid[start_y][start_x]:
        return False

    next_y = start_y + 1
    if next_y >= len(grid):
        return False

    bottom_left = None if start_x - 1 < 0 else grid[next_y][start_x - 1]
    bottom_right = None if start_x + 1 >= len(grid[next_y]) else grid[next_y][start_x + 1]
    bottom = grid[next_y][start_x]

    # we can fall, so fall
    if not bottom:
        return drop_sand(grid, start_x, next_y)

    if bottom and bottom_left and bottom_right:
        grid[start_y][start_x] = "o"
        return True
    elif not bottom_left:
        if bottom_left is None:
            return False
        else:
            return drop_sand(grid, start_x - 1, next_y)
    elif not bottom_right:
        if bottom_right is None:
            return False
        else:
            return drop_sand(grid, start_x + 1, next_y)


def p1(lines):
    grid_bounds = bounds(lines)
    grid = build_grid(lines, grid_bounds)
    drop_x = 500 - grid_bounds[0]

    sand_dropped = 0
    while drop_sand(grid, drop_x, 0):
        sand_dropped += 1

    print("P1: %s" % (sand_dropped,))


def p2(lines):
    min_x, min_y, max_x, max_y = bounds(lines)
    width = max_x - min_x
    height = max_y - min_y + 2
    drop_x = 500 - min_x
    padding = height - 2
    left_padding = padding - drop_x + 2
    right_padding = padding - (width - (drop_x + 1)) + 1
    left_padding = left_padding if left_padding > 0 else 0
    right_padding = right_padding if right_padding > 0 else 0

    grid = build_grid(lines, (min_x - left_padding, min_y, max_x + right_padding, max_y + 2))
    for x in range(0, len(grid[0])):
        grid[len(grid) - 1][x] = True
    drop_x = 500 - min_x + left_padding
    sand_dropped = 0
    while drop_sand(grid, drop_x, 0):
        sand_dropped += 1

    print("P2: %s" % (sand_dropped,))


p1(lines)
p2(lines)
