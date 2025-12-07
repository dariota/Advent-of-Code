import random

from solution import IngredientList

from pytest_unordered import unordered


def test_id_in_ranges_is_fresh():
    ing_list = IngredientList([
        "3-5",
        "7-9",
    ])

    for i in [3, 4, 5, 7, 8, 9]:
        assert ing_list._is_fresh(i)


def test_id_not_in_ranges_is_not_fresh():
    ing_list = IngredientList([
        "3-5",
        "7-9",
    ])

    for i in [1, 2, 6, 10]:
        assert not ing_list._is_fresh(i)


def test_id_in_multiple_ranges_is_fresh():
    ing_list = IngredientList([
        "3-5",
        "4-6",
    ])

    for i in [4, 5]:
        assert ing_list._is_fresh(i)


def test_counts_fresh_ingredients():
    _, fresh_count = IngredientList.parse([
        "3-5",
        "10-14",
        "16-20",
        "12-18",
        "",
        "1",
        "5",
        "8",
        "11",
        "17",
        "32",
    ])

    assert fresh_count == 3


def test_combines_touching_ranges():
    assert IngredientList([
        "3-5",
        "6-8",
    ])._ranges == [range(3, 9)]  # python range excludes end


def test_doesnt_combine_ranges_with_a_gap():
    assert IngredientList([
        "3-5",
        "7-8",
    ])._ranges == unordered([range(3, 6), range(7, 9)])


def test_combines_overlapping_ranges():
    assert IngredientList([
        "3-5",
        "4-6",
    ])._ranges == [range(3, 7)]


def test_combines_fully_contained_ranges():
    assert IngredientList([
        "3-10",
        "5-8",
        "4-9",
        "6-9",
    ])._ranges == [range(3, 11)]


def test_combines_ranges_with_same_start():
    assert IngredientList([
        "3-10",
        "3-12",
    ])._ranges == [range(3, 13)]


def test_combines_ranges_with_same_end():
    assert IngredientList([
        "3-10",
        "5-10",
    ])._ranges == [range(3, 11)]


def test_combines_shuffled_complex_ranges():
    id_ranges = [
        "3-10",
        "8-9",
        "6-13",
        "11-15",
        "16-20",
        "22-30",
    ]
    random.shuffle(id_ranges)
    # First bunch of ranges combine to one long range, then the gap breaks into a separate range
    expected_ranges = [
        range(3, 21),
        range(22, 31),
    ]

    assert IngredientList(id_ranges)._ranges == unordered(expected_ranges)


def test_sample_input_valid_count_matches():
    assert IngredientList(["3-5", "10-14", "16-20", "12-18"]).valid_count == 14


def test_sample_input_valid_ids_match():
    assert IngredientList(["3-5", "10-14", "16-20", "12-18"])._ranges == unordered([range(3, 6), range(10, 21)])
