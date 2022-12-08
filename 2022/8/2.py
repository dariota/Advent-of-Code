file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

grid = []
for line in input:
    row = []
    for char in line:
        row.append(int(char))

    grid.append(row)


def visible_vertically(grid, tree_height, row_iter, col_ind):
    num_visible = 0
    for row_ind in row_iter:
        num_visible += 1
        if grid[row_ind][col_ind] >= tree_height:
            break

    return num_visible


def visible_horizontally(grid, tree_height, row_ind, col_iter):
    num_visible = 0
    for col_ind in col_iter:
        num_visible += 1
        if grid[row_ind][col_ind] >= tree_height:
            break

    return num_visible


def scenic_score(grid, row_ind, col_ind):
    tree_height = grid[row_ind][col_ind]
    return (visible_vertically(grid, tree_height, range(row_ind - 1, -1, -1), col_ind) * # visible above
           visible_vertically(grid, tree_height, range(row_ind + 1, len(grid)), col_ind) * # visible below
           visible_horizontally(grid, tree_height, row_ind, range(col_ind - 1, -1, -1)) * # visible left
           visible_horizontally(grid, tree_height, row_ind, range(col_ind + 1, len(grid[row_ind])))) # visible right


max_scenic = 0
for row_ind in range(0, len(grid)):
    row = grid[row_ind]
    for col_ind in range(0, len(row)):
        score = scenic_score(grid, row_ind, col_ind)
        if score > max_scenic:
            max_scenic = score

print(max_scenic)
