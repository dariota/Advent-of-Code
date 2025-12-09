import pytest

from solution import Worksheet


def test_calculates_column_operations_and_sums():
    worksheet = Worksheet([
        "1 2 7",
        "2 2 1",
        "* * +",
    ])

    assert worksheet.calculate() == 14


def test_passes_sample_input():
    worksheet = Worksheet([
        "123 328  51 64 ",
        " 45 64  387 23 ",
        "  6 98  215 314",
        "*   +   *   +  ",
    ])

    assert worksheet.calculate() == 4277556


def test_calculates_cephalopoddily():
    worksheet = Worksheet([
        "123 328  51 64 ",
        " 45 64  387 23 ",
        "  6 98  215 314",
        "*   +   *   +  ",
    ])

    assert worksheet.cephalocalc() == 3263827


@pytest.mark.parametrize("operator,expected", [("*", 8544), ("+", 381)])
def test_calculates_single_cephalopod_column(operator, expected):
    worksheet = Worksheet([
        "123",
        " 45",
        "  6",
        f"{operator}  ",
    ])

    assert worksheet.cephalocalc() == expected
