import heapq

file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

# Adapted from https://en.wikipedia.org/wiki/A*_search_algorithm#Pseudocode
def reconstruct(cameFrom, current):
    path = [current]
    while current in cameFrom:
        current = cameFrom[current]
        path.append(current)

    path.reverse()
    return path


# Manhattan distance
def heuristic(a, b):
    return abs(a[0] - b[0]) + abs(a[1] - b[1])


def reachable(grid, current):
    positions = []
    my_height = grid[current[1]][current[0]]

    if current[0] != 0:
        neighbour = (current[0] - 1, current[1])
        if grid[neighbour[1]][neighbour[0]] <= my_height + 1:
            positions.append(neighbour)

    if current[0] != len(grid[0]) - 1:
        neighbour = (current[0] + 1, current[1])
        if grid[neighbour[1]][neighbour[0]] <= my_height + 1:
            positions.append(neighbour)

    if current[1] != 0:
        neighbour = (current[0], current[1] - 1)
        if grid[neighbour[1]][neighbour[0]] <= my_height + 1:
            positions.append(neighbour)

    if current[1] != len(grid) - 1:
        neighbour = (current[0], current[1] + 1)
        if grid[neighbour[1]][neighbour[0]] <= my_height + 1:
            positions.append(neighbour)

    return positions


def a_star(grid, start, goal):
    open_set = { start }
    came_from = {}

    cost_to_node = {}
    cost_to_node[start] = 0

    # need a min-heap
    min_cost_to_goal = []
    heapq.heappush(min_cost_to_goal, (heuristic(start, goal), start))

    while len(open_set) > 0:
        cost, current = heapq.heappop(min_cost_to_goal)
        if current not in open_set:
            continue

        if current == goal:
            return reconstruct(came_from, current)

        open_set.remove(current)
        for neighbour in reachable(grid, current):
            potential_cost = cost_to_node[current] + 1

            if (neighbour not in cost_to_node) or (potential_cost < cost_to_node[neighbour]):
                came_from[neighbour] = current
                cost_to_node[neighbour] = potential_cost
                heapq.heappush(min_cost_to_goal, (potential_cost + heuristic(neighbour, goal), neighbour))
                if not neighbour in open_set:
                    open_set.add(neighbour)

    return None

# parse grid as ord(chr), store as row,col
grid = []
start = None
goal = None
for row_ind in range(0, len(input)):
    row = input[row_ind]
    grid_row = []
    for col_ind in range(0, len(row)):
        char = row[col_ind]
        pos = (col_ind, row_ind)

        if char == "S":
            start = pos
            char = 'a'
        elif char == "E":
            goal = pos
            char = 'z'

        grid_row.append(ord(char))
    grid.append(grid_row)

def p1(grid, start, goal):
    # -1 because the problem either doesn't count the first or last step
    print("P1: %s" % (len(a_star(grid, start, goal)) - 1))


def p2(grid, goal):
    starts = []
    start_val = ord('a')
    for row_ind in range(0, len(grid)):
        row = grid[row_ind]
        for col_ind in range(0, len(row)):
            if row[col_ind] == start_val:
                starts.append((col_ind, row_ind))

    min_start = None
    for start in starts:
        path = a_star(grid, start, goal)
        if path is None:
            continue

        cost = len(path) - 1
        if min_start == None or cost < min_start:
            min_start = cost

    print("P2: %s" % min_start)


p1(grid, start, goal)
p2(grid, goal)
