class PaperGrid:
    def __init__(self, grid: list[str]):
        self.reachable_rolls = 0

        self._rows = len(grid)
        self._cols = len(grid[0])
        self._grid = [[char == "@" for char in row] for row in grid]

    def _iterate_grid(self):
        for row_idx, row in enumerate(self._grid):
            for col_idx, col in enumerate(row):
                if not col:
                    continue

                yield row_idx, col_idx, col

    def _iterate_adjacent(self, row, col):
        for adj_row in range(row - 1, row + 2):
            for adj_col in range(col - 1, col + 2):
                if adj_row < 0 or adj_col < 0 or adj_row >= self._rows or adj_col >= self._cols:
                    continue

                if adj_row == row and adj_col == col:
                    continue

                yield adj_row, adj_col

    def _calculate_adjacency(self):
        self.adjacency_grid = [[0] * self._cols for _ in range(self._rows)]

        for row_idx, col_idx, col in self._iterate_grid():
            for adj_row, adj_col in self._iterate_adjacent(row_idx, col_idx):
                self.adjacency_grid[adj_row][adj_col] += 1

    def remove_rolls(self):
        self._calculate_adjacency()

        removed_rolls = 0
        for row_idx, col_idx, _ in self._iterate_grid():
            if self.adjacency_grid[row_idx][col_idx] < 4:
                self._grid[row_idx][col_idx] = False
                removed_rolls += 1

        self.reachable_rolls += removed_rolls
        return removed_rolls

    def remove_all_rolls(self):
        while self.remove_rolls():
            pass

        return self.reachable_rolls


if __name__ == "__main__":
    with open("input", "r") as f:
        grid = PaperGrid([line.strip() for line in f])
        print("Part one:", grid.remove_rolls())
        print("Part two:", grid.remove_all_rolls())
