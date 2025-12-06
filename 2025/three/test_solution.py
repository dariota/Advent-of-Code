import pytest

from solution import Jolter, JoltChain

@pytest.mark.parametrize("sample,expected", [("987654321111111", 98), ("811111111111119", 89), ("234234234234278", 78), ("818181911112111", 92)])
def test_finds_highest_joltage_in_sample_inputs(sample, expected):
    assert Jolter.max_joltage(max_len=2, bank=sample) == expected

def test_raises_for_short_input():
    with pytest.raises(ValueError):
        Jolter.max_joltage(max_len=2, bank="9")

def test_finds_highest_joltage_amongst_lower_values_scannable():
    assert Jolter.max_joltage(max_len=2, bank="89898") == 99


@pytest.fixture
def chain():
    return JoltChain(max_len=3)

class TestJoltChain:
    def test_always_adds_to_chain_when_below_max_length(self, chain):
        for i in range(1, chain.max_len + 1):
            chain.add_to_chain(1)
            assert chain.chain == [1] * i, f"Added 1 {i} times, expected {[1] * i} but was {chain.chain}"

    def test_adds_to_chain_from_right_when_value_increases(self, chain):
        for _ in range(3):
            chain.add_to_chain(1)

        chain.add_to_chain(2)
        assert chain.chain == [1, 1, 2]

        chain.add_to_chain(3)
        assert chain.chain == [1, 2, 3]

        chain.add_to_chain(2)
        assert chain.chain == [2, 3, 2]

    def test_doesnt_change_when_value_is_unchanged(self, chain):
        for i in [2, 1, 1]:
            chain.add_to_chain(i)

        chain.add_to_chain(1)
        assert chain.chain == [2, 1, 1]

    def test_drops_low_value_digits_within_the_chain(self, chain):
        for i in [2, 1, 3]:
            chain.add_to_chain(i)

        chain.add_to_chain(2)
        assert chain.chain == [2, 3, 2]

        chain.add_to_chain(3)
        assert chain.chain == [3, 2, 3]

        chain.add_to_chain(4)
        assert chain.chain == [3, 3, 4]

    def test_adds_small_numbers_to_increase_higher_radix_values(self, chain):
        for i in [8, 9, 9]:
            chain.add_to_chain(i)

        chain.add_to_chain(1)
        assert chain.chain == [9, 9, 1]
