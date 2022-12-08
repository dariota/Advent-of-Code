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
    for row_ind in row_iter:
        if grid[row_ind][col_ind] >= tree_height:
            return False

    return True


def visible_horizontally(grid, tree_height, row_ind, col_iter):
    for col_ind in col_iter:
        if grid[row_ind][col_ind] >= tree_height:
            return False

    return True


visible_trees = 0
for row_ind in range(0, len(grid)):
    row = grid[row_ind]
    for col_ind in range(0, len(row)):
        tree_height = row[col_ind]
        if (visible_vertically(grid, tree_height, range(0, row_ind), col_ind) or # visible above
           visible_vertically(grid, tree_height, range(row_ind + 1, len(grid)), col_ind) or # visible below
           visible_horizontally(grid, tree_height, row_ind, range(0, col_ind)) or # visible left
           visible_horizontally(grid, tree_height, row_ind, range(col_ind + 1, len(row)))): # visible right
            visible_trees += 1

print(visible_trees)
