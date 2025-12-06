import pytest

from solution import IdRange


@pytest.mark.parametrize("invalid_id", [11, 22, 99, 1010, 1188511885, 222222, 446446, 38593859])
def test_counts_duplicate_digits_as_invalid(invalid_id):
    assert IdRange(invalid_id, invalid_id).invalid_id_sum == invalid_id

def test_sums_invalid_ids():
    assert IdRange(11, 22).invalid_id_sum == 33

def test_passes_sample_input():
    assert sum(
        IdRange(min_id, max_id).invalid_id_sum
        for min_id, max_id in [(11, 22), (95, 115), (998, 1012), (1188511880, 1188511890), (222220, 222224), (1698522, 1698528), (446443, 446449), (38593856, 38593862)]
    ) == 1227775554 

def test_initialises_from_string():
    id_range = IdRange.parse("95-115")
    
    assert id_range.min_id == 95
    assert id_range.max_id == 115

@pytest.mark.parametrize("invalid_id", [11, 22, 99, 111, 999, 1010, 1188511885, 222222, 446446, 38593859, 565565, 824824824, 2121212121])
def test_counts_repeated_digits_as_invalid(invalid_id):
    assert IdRange(invalid_id, invalid_id).second_invalid_id_sum == invalid_id

def test_passes_second_sample_input():
    assert sum(
        IdRange(min_id, max_id).second_invalid_id_sum
        for min_id, max_id in [(11, 22), (95, 115), (998, 1012), (1188511880, 1188511890), (222220, 222224), (1698522, 1698528), (446443, 446449), (38593856, 38593862), (565653, 565659), (824824821, 824824827), (2121212118, 2121212124)]
    ) == 4174379265 
