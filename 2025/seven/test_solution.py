import pytest

from solution import Tachyon

def test_merges_beams():
    # Hits the top splitter (1)
    # Hits both splitters in the next row (+2)
    # Beams merge and hit last splitter (+1)
    assert Tachyon.parse([
        "..S..",
        "..^..",
        ".^.^.",
        "..^..",
    ]).splits == 4


def test_deduplicates_splitters():
    assert Tachyon.parse([
        "..S..",
        "..^..", # Hit by first beam
        ".^...", # Hit after split from row 1
        "..^..", # Hit after split from row 2
        "...^.", # Hit after split from row 1 AND 3
    ]).splits == 4


def test_splitters_block_beams():
    assert Tachyon.parse([
        "..S..",
        "..^..",
        "..^..",
    ]).splits == 1


def test_beams_hit_splitters_directly_below():
    assert Tachyon.parse([
        "..S..",
        ".^.^.",
        "^.^.^",
    ]).splits == 1


def test_counts_unbranched_timelines():
    assert Tachyon.parse([
        "..S..",
    ]).timelines == 1


def test_counts_simple_timelines():
    assert Tachyon.parse([
        "..S..",
        "..^..",
    ]).timelines == 2  # left and right


def test_counts_branching_timelines():
    assert Tachyon.parse([
        "..S..",
        "..^..",  # 2 timelines (left and right)
        ".^...",  # 1 timeline splits, 3 timelines
        "..^..",  # 1 timeline splits, 4 timelines
        "...^.",  # 2 timelines split (straight down, cascading from left), 6 timelines
    ]).timelines == 6


def test_passes_sample_input():
    beams = Tachyon.parse([
        ".......S.......",
        "...............",
        ".......^.......",
        "...............",
        "......^.^......",
        "...............",
        ".....^.^.^.....",
        "...............",
        "....^.^...^....",
        "...............",
        "...^.^...^.^...",
        "...............",
        "..^...^.....^..",
        "...............",
        ".^.^.^.^.^...^.",
        "...............",
    ])

    assert beams.splits == 21
    assert beams.timelines == 40


def test_raises_if_multiple_beams_are_present_at_the_start():
    with pytest.raises(ValueError, match="Multiple beams"):
        Tachyon.parse([
            "..S..",
            "^.S.^",
        ])


def test_raises_if_no_beams_are_present_at_the_start():
    with pytest.raises(ValueError, match="No beam"):
        Tachyon.parse([
            ".....",
            "^...^",
        ])


def test_raises_if_splitters_are_touching():
    # Behaviour is undefined if a beam spawns directly into a splitter
    with pytest.raises(ValueError, match="Adjacent splitters"):
        Tachyon.parse([
            "S..^^.",
        ])
