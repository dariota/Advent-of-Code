import pytest 

from solution import Lock


@pytest.fixture
def lock():
    return Lock()


class TestLock:
    def test_lock_starts_at_fifty(self, lock):
        assert lock.position == 50

    def test_left_wraps(self, lock):
        lock.spin("L55")
        
        assert lock.position == 95

    def test_right_wraps(self, lock):
        lock.spin("R55")
        assert lock.position == 5

    def test_counts_times_at_zero(self, lock):
        assert lock.zeroes == 0

        lock.spin("R10")
        assert lock.zeroes == 0

        lock.spin("L60")
        assert lock.zeroes == 1

        lock.spin("L100")
        assert lock.zeroes == 2

    def test_passes_sample_input(self, lock):
        inputs = ["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]
        position = [82, 52, 0, 95, 55, 0, 99, 0, 14, 32]
        passes = [1, 1, 2, 2, 3, 4, 4, 5, 5, 6]

        for spin, expected_position, expected_passes in zip(inputs, position, passes):
            lock.spin(spin)
            assert lock.position == expected_position, f"Expected {expected_position} after {spin} but was {lock.position}"
            assert lock.passes == expected_passes, f"Expected {expected_passes} after {spin} but was {lock.passes} at {lock.position}"

        assert lock.zeroes == 3

    def test_counts_times_passing_zero(self, lock):
        assert lock.passes == 0

        lock.spin("R51")
        assert lock.passes == 1

        lock.spin("L2")
        assert lock.passes == 2

    def test_counts_multiple_passes_in_one_spin(self, lock):
        lock.spin("R151")
        assert lock.passes == 2

        lock.spin("L152")
        assert lock.passes == 4

    def test_landing_on_zero_counts_as_a_pass(self, lock):
        lock.spin("R50")
        assert lock.passes == 1

    @pytest.mark.parametrize("spin", ["10", "L", "R", "U", "10R", "R10R", "R-3", "L0"])
    def test_raises_with_invalid_spin(self, lock, spin):
        with pytest.raises(ValueError):
            lock.spin(spin)
