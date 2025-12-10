from collections import defaultdict
from typing import NamedTuple


class Beam(NamedTuple):
    row: int
    col: int


class Tachyon:
    @classmethod
    def parse(cls, lines: list[str]):
        beam = None
        splitters = defaultdict(list)

        for row, line in enumerate(lines):
            if "^^" in line:
                raise ValueError("Adjacent splitters in input")
            
            for col, char in enumerate(line):
                if char == "S":
                    if beam is not None:
                        raise ValueError("Multiple beams present in input")
                    beam = Beam(row=row, col=col)
                elif char == "^":
                    splitters[col].append(row)

        if not beam:
            raise ValueError("No beam present in input")
        
        return cls(beam=beam, splitters=splitters)

    def __init__(self, beam: Beam, splitters: dict[int, list[int]]):
        """
        splitters -- Map from column to rows in that column containing splitters
        """
        self.timelines = 0
        self._hit_splitters = set()

        self._beam_timelines = {beam: 1}
        self._splitters = {col: list(sorted(rows)) for col, rows in splitters.items()}

        self._propagate_beams()

    def _propagate_beams(self):
        while self._beam_timelines:
            next_beams = defaultdict(int)

            for beam, timelines in self._beam_timelines.items():
                splitter = next((row for row in self._splitters.get(beam.col, []) if row > beam.row), None)

                if splitter is not None:
                    self._hit_splitters.add((splitter, beam.col))

                    next_beams[Beam(row=splitter, col=beam.col - 1)] += timelines
                    next_beams[Beam(row=splitter, col=beam.col + 1)] += timelines
                else:
                    self.timelines += timelines

            self._beam_timelines = next_beams

    @property
    def splits(self):
        return len(self._hit_splitters)


if __name__ == "__main__":
    with open("input", "r") as f:
        beams = Tachyon.parse([line.strip() for line in f])
        print("Part one:", beams.splits)
        print("Part two:", beams.timelines)
