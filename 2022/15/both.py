import re

file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

def manhattan(x1, y1, x2, y2):
    return abs(x1 - x2) + abs(y1 - y2)


def union(ranges, bounds=None):
    min_val = None if bounds is None else bounds[0]
    max_val = None if bounds is None else bounds[1]

    # From https://stackoverflow.com/a/15273749 with added bounds
    unioned = []
    for begin, end in sorted(ranges):
        if (min_val and end <= min_val) or (max_val and begin > max_val):
            continue

        begin = min_val if min_val is not None and min_val > begin else begin
        end = max_val if max_val is not None and max_val < end else end

        if unioned and unioned[-1][1] >= begin:
            unioned[-1][1] = max(unioned[-1][1], end)
        else:
            unioned.append([begin, end])

    return unioned

# Assumes distinct
def size(ranges):
    return sum([x[1] - x[0] for x in ranges])


class Sensor:
    def __init__(self, pos, beacon_pos):
        self.x, self.y = list(map(int, pos))
        self.beacon_x, self.beacon_y = list(map(int, beacon_pos))
        self.detected_range = manhattan(self.x, self.y, self.beacon_x, self.beacon_y)

    def beaconless_range(self, y):
        to_line = manhattan(self.x, self.y, self.x, y)
        width = self.detected_range - to_line
        if width <= 0:
            return None

        return (self.x - width, self.x + width + 1)

    @classmethod
    def parse(cls, line):
        matches = re.search("x=(-?\d+), y=(-?\d+).*x=(-?\d+), y=(-?\d+)", line)
        return Sensor((matches.group(1), matches.group(2)), (matches.group(3), matches.group(4)))


def p1(sensors):
    y_pos = 2000000
    ranges = []
    for sensor in sensors:
        bounds = sensor.beaconless_range(y_pos)
        if bounds:
            ranges.append(bounds)

    ranges = union(ranges)

    beacons = set()
    for sensor in sensors:
        if sensor.beacon_y == y_pos:
            if any(map(lambda bounds: sensor.beacon_x >= bounds[0] and sensor.beacon_x < bounds[1], ranges)):
                beacons.add(sensor.beacon_x)

    print("P1: %s" % (size(ranges) - len(beacons)))


def p2(sensors):
    max_y = 4000000
    for y in range(max_y - 1, -1, -1):
        ranges = []
        for sensor in sensors:
            bounds = sensor.beaconless_range(y)
            if bounds:
                ranges.append(bounds)

        ranges = union(ranges, (0, max_y))
        if len(ranges) != 1:
            print("P2: %s" % (ranges[0][1] * max_y + y))
            return


sensors = [Sensor.parse(line) for line in lines]
p1(sensors)
p2(sensors)
