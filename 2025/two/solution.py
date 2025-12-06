def _invalid_id(to_check: int):
    window = 1
    while window * window < to_check:
        window *= 10

    remainder = to_check % window
    return remainder >= window / 10 and (to_check // window) == remainder


def _second_invalid_id(to_check: int):
    window = 1
    while window * window < to_check:
        window *= 10

        expected_digits = to_check % window
        remainder = to_check // window

        if expected_digits >= window / 10:
            # Otherwise there's one or more leading zeroes
            while remainder:
                if remainder % window != expected_digits:
                    break

                remainder = remainder // window
                if not remainder:
                    return True

    return False


class IdRange:
    def __init__(self, min_id: int, max_id: int):
        self.min_id = min_id
        self.max_id = max_id

    @property
    def _id_range(self):
        return range(self.min_id, self.max_id + 1)

    @property
    def invalid_id_sum(self):
        return sum(i for i in self._id_range if _invalid_id(i))

    @property
    def second_invalid_id_sum(self):
        return sum(i for i in self._id_range if _second_invalid_id(i))

    @classmethod
    def parse(cls, line: str):
        min_id, max_id = line.split("-")
        return cls(int(min_id), int(max_id))


if __name__ == "__main__":
    with open("input", "r") as f:
        for line in f:
            id_ranges = [IdRange.parse(id_range) for id_range in line.split(",")]
            print("Part one:", sum(id_range.invalid_id_sum for id_range in id_ranges))
            print("Part two:", sum(id_range.second_invalid_id_sum for id_range in id_ranges))

