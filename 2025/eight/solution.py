from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass
from functools import reduce
from typing import NamedTuple


@dataclass
class JunctionBox:
    box_id: int
    network_id: int

    x: int
    y: int
    z: int

    def distance_to(self, other: "JunctionBox") -> float:
        return (self.x - other.x)**2 + (self.y - other.y)**2 + (self.z - other.z)**2

    def __hash__(self):
        return self.box_id

    def __repr__(self):
        return f"JunctionBox(box_id={self.box_id}, x={self.x}, y={self.y}, z={self.z})"


def _construct_networks(lines: list[str]):
    # box id -> junction
    junctions = {}
    # network id -> set[junction]
    networks = {}

    for box_id, line in enumerate(lines):
        x, y, z = map(int, line.split(","))
        box = JunctionBox(box_id, box_id, x, y, z)
        junctions[box.box_id] = box
        networks[box.network_id] = {box}

    return junctions, networks


def _get_distances(junctions: list[JunctionBox]):
    distances = []

    for ind, junction in enumerate(junctions):
        for other in junctions[ind+1:]:
            distances.append((junction.distance_to(other), (junction, other)))

    return list(reversed(sorted(distances)))


def _connect_networks(networks: dict[int, set[JunctionBox]], junction: JunctionBox, other: JunctionBox):
    if junction.network_id == other.network_id:
        return

    first_id, second_id = junction.network_id, other.network_id
    lower_id, higher_id = (first_id, second_id) if first_id < second_id else (second_id, first_id)

    to_merge = networks.pop(higher_id)
    for box in to_merge:
        box.network_id = lower_id

    networks[lower_id] |= to_merge


def solve(lines: list[str], connection_count: int):
    part_one, part_two = None, None

    junctions, networks = _construct_networks(lines)

    distances = _get_distances(list(junctions.values()))

    connections_made = 0
    while len(networks) > 1:
        connections_made += 1
        _, (junction, other) = distances.pop()
        _connect_networks(networks, junction, other)

        if connections_made == connection_count:
            part_one = reduce(lambda a, b: a * b, sorted(map(len, networks.values()))[-3:])

    part_two = junction.x * other.x

    return part_one, part_two


if __name__ == "__main__":
    with open("input", "r") as f:
        lines = [line.strip() for line in f]
        one, two = solve(lines, 1000)
        print("Part one:", one)
        print("Part two:", two)
