from itertools import filterfalse, takewhile

class IngredientList:
    @classmethod
    def parse(cls, lines):
        lines = iter(lines)
        ranges = list(takewhile(lambda s: s != "", lines))
        ids = [int(i) for i in filterfalse(lambda s: s == "", lines)]

        ingredient_list = cls(ranges)
        return ingredient_list, sum(1 for ingredient in ids if ingredient_list._is_fresh(ingredient))

    def __init__(self, ranges):
        initial_ranges = []

        for id_range in ranges:
            low, high = map(int, id_range.split("-"))
            initial_ranges.append(range(low, high + 1))
        assert ranges == [f"{id_range.start}-{id_range.stop - 1}" for id_range in initial_ranges]

        initial_ranges = iter(sorted(initial_ranges, key=lambda r: r.start))

        # combine overlapping ranges
        self._ranges = []

        next_range = next(initial_ranges)
        for id_range in initial_ranges:
            if id_range.start <= next_range.stop:
                next_range = range(next_range.start, max(next_range.stop, id_range.stop))
            else:
                self._ranges.append(next_range)
                next_range = id_range

        self._ranges.append(next_range)
        breakpoint()

    def _is_fresh(self, ingredient):
        return any(ingredient in id_range for id_range in self._ranges)

    @property
    def valid_count(self):
        return sum(id_range.stop - id_range.start for id_range in self._ranges)



if __name__ == "__main__":
    with open("input", "r") as f:
        ingredient_list, fresh_count = IngredientList.parse([line.strip() for line in f])
        print("Part one:", fresh_count)
        print("Part two:", ingredient_list.valid_count)
