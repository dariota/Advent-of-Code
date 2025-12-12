import pytest

from solution import JunctionBox, solve


def box(x, y, z):
    return JunctionBox(box_id=1, network_id=1, x=x, y=y, z=z)


class TestJunctionBox:
    def test_calculates_straight_line_distance(self):
        assert box(x=47, y=3, z=7).distance_to(box(x=85, y=92, z=75)) == 13989


    def test_calculates_simpler_straight_line_distance(self):
        assert box(x=0, y=0, z=0).distance_to(box(x=1, y=2, z=3)) == 14


class TestSolve:
    def test_solves_sample_input(self):
        assert solve([
            "162,817,812",
            "57,618,57",
            "906,360,560",
            "592,479,940",
            "352,342,300",
            "466,668,158",
            "542,29,236",
            "431,825,988",
            "739,650,466",
            "52,470,668",
            "216,146,977",
            "819,987,18",
            "117,168,530",
            "805,96,715",
            "346,949,466",
            "970,615,88",
            "941,993,340",
            "862,61,35",
            "984,92,344",
            "425,690,689",
        ], 10) == (40, 25272)
