import pytest

from solution import PaperGrid


def test_constructs_empty_adjacency_grid():
    paper_grid = PaperGrid([".."] * 3)
    paper_grid._calculate_adjacency()

    assert paper_grid.adjacency_grid == [[0, 0], [0, 0], [0, 0]]


def test_marks_adjacent_squares():
    paper_grid = PaperGrid([
        "......",
        "..@@@.",
        "..@@@.",
        "..@@@.",
        "......",
    ])
    paper_grid._calculate_adjacency()

    assert paper_grid.adjacency_grid == [
      [0, 1, 2, 3, 2, 1],
      [0, 2, 3, 5, 3, 2],
      [0, 3, 5, 8, 5, 3],
      [0, 2, 3, 5, 3, 2],
      [0, 1, 2, 3, 2, 1],
    ]


def test_returns_reachable_rolls():
    paper_grid = PaperGrid([
        "..@@.@@@@.",
        "@@@.@.@.@@",
        "@@@@@.@.@@",
        "@.@@@@..@.",
        "@@.@@@@.@@",
        ".@@@@@@@.@",
        ".@.@.@.@@@",
        "@.@@@.@@@@",
        ".@@@@@@@@.",
        "@.@.@@@.@.",
    ])

    assert paper_grid.remove_rolls() == 13


def test_removes_removable_rolls():
    paper_grid = PaperGrid(["@@@@"] * 4)

    paper_grid.remove_rolls()
    assert paper_grid._grid == [[False, True, True, False], [True] * 4, [True] * 4, [False, True, True, False]]


def test_removes_rolls_reachable_on_subsequent_iterations():
    paper_grid = PaperGrid([
        "@@@@",
        "@.@@",
        "@.@@",
        "@@@@",
    ])

    paper_grid.remove_all_rolls()
    assert paper_grid._grid == [[False] * 4] * 4


def test_remove_all_returns_total_reachable_rolls():
    paper_grid = PaperGrid([
        "..@@.@@@@.",
        "@@@.@.@.@@",
        "@@@@@.@.@@",
        "@.@@@@..@.",
        "@@.@@@@.@@",
        ".@@@@@@@.@",
        ".@.@.@.@@@",
        "@.@@@.@@@@",
        ".@@@@@@@@.",
        "@.@.@@@.@.",
    ])

    assert paper_grid.remove_all_rolls() == 43
    

@pytest.mark.parametrize("grid,reachable", [([".@@"], 2), (["..@"], 1)])
def test_doesnt_count_empty_squares_as_reachable(grid, reachable):
    assert PaperGrid(grid).remove_rolls() == reachable
