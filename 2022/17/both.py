file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

class Room:
    def __init__(self, width):
        self.contents = {}
        self.width = width
        self.max_height = 0
        self.max_heights = [0] * width
        self.seen_states = {}
        self.height_increases = []
        self.cycle_at = None

    def can_move(self, edges, translation, base_pos):
        for edge in edges:
            translated = (base_pos[0] + edge[0] + translation[0], base_pos[1] - edge[1] + translation[1])
            # Hitting a wall?
            if translated[0] < 0 or translated[0] >= self.width:
                return False
            # Hitting the floor?
            if translated[1] < 0:
                return False
            # Hitting something in the room?
            if translated in self.contents:
                return False

        return True

    def place(self, rock, position, rock_id, stream_pos):
        initial_height = self.max_height
        state = (tuple(self.max_heights), rock_id, stream_pos)
        if state in self.seen_states:
            self.cycle_at = self.seen_states[state]
            return

        # Position is top left of rock increasing downwards, even if top left is empty
        for y in range(len(rock.shape)):
            room_y = position[1] - y
            if room_y + 1 > self.max_height:
                initial_height = self.max_height
                self.max_height = room_y + 1
                height_change = self.max_height - initial_height
                for i in range(len(self.max_heights)):
                    self.max_heights[i] += height_change
            for x in range(len(rock.shape[y])):
                if rock.shape[y][x]:
                    if self.max_height - (room_y + 1) < self.max_heights[x + position[0]]:
                        self.max_heights[x + position[0]] = self.max_height - (room_y + 1)
                    self.contents[(x + position[0], room_y)] = rock.shape[y][x]
        self.seen_states[state] = len(self.height_increases)
        self.height_increases.append(self.max_height - initial_height)

    def print(self):
        printable = {}
        for pos in self.contents.keys():
            if pos[1] in printable:
                printable[pos[1]].add(pos[0])
            else:
                printable[pos[1]] = { pos[0] }

        for y in range(self.max_height, -1, -1):
            print("|", end="")
            for x in range(self.width):
                if y in printable and x in printable[y]:
                    print("#", end="")
                else:
                    print(".", end="")
            print("|")
        print("+%s+" % "".join(["-"] * self.width), end="\n\n")


class Rock:
    def __init__(self, shape):
        self.shape = [[char == "#" for char in row] for row in shape]
        self.height = len(shape)
        self.bottom_edge = []
        self.right_edge = []
        self.left_edge = []

        # Raytrace to bottom edge for collisions
        for x in range(len(self.shape[0])):
            for y in range(len(self.shape) - 1, -1, -1):
                if self.shape[y][x]:
                    self.bottom_edge.append((x, y))
                    break

        # Repeat for left
        for y in range(len(self.shape)):
            for x in range(len(self.shape[0])):
                if self.shape[y][x]:
                    self.left_edge.append((x, y))
                    break

        # Repeat for right
        for y in range(len(self.shape)):
            for x in range(len(self.shape[0]) - 1, -1, -1):
                if self.shape[y][x]:
                    self.right_edge.append((x, y))
                    break


    def drop(self, room, jetstream, rock_id):
        interest = not self.shape[0][0] and self.shape[0][1]
        # Start pos is top left of the rock
        pos = (2, room.max_height + 3 + self.height - 1)
        down = (0, -1)
        falling = True
        while falling:
            movement = next(jetstream)
            edges = self.left_edge if movement[0] == -1 else self.right_edge
            if room.can_move(edges, movement, pos):
                pos = (pos[0] + movement[0], pos[1] + movement[1])
            falling = room.can_move(self.bottom_edge, down, pos)
            if falling:
                pos = (pos[0], pos[1] - 1)

        room.place(self, pos, rock_id, jetstream.pos)


    def __repr__(self):
        shape = "\n".join([''.join(["#" if full else " " for full in row]) for row in self.shape])
        return "Shape - left bounds(%s) bottom bounds(%s) right bounds(%s):\n%s\n" % (self.left_edge, self.bottom_edge, self.right_edge, shape)

class Jetstream:
    def __init__(self, stream):
        self.stream = [(-1, 0) if char == "<" else (1, 0) for char in stream]
        self.pos = 0

    def __iter__(self):
        return self

    def __next__(self):
        move = self.stream[self.pos]
        self.pos = (self.pos + 1) % len(self.stream)
        return move

rocks = [Rock(["####"]), Rock([" # ", "###", " # "]), Rock(["  #", "  #", "###"]), Rock(["#"] * 4), Rock(["##"] * 2)]
stream = Jetstream(lines[0])
room = Room(7)

dropped = 0
while not room.cycle_at:
    rock_id = dropped % len(rocks)
    rock = rocks[rock_id]
    rock.drop(room, stream, rock_id)
    dropped += 1

def height_at(room, already_dropped, cycle_count):
    cycle_len = len(room.height_increases) - room.cycle_at
    remaining = cycle_count - already_dropped
    full_cycles = int(remaining / cycle_len)
    extra = remaining % cycle_len
    cycle_value = 0
    extra_value = 0
    for i in range(room.cycle_at, len(room.height_increases)):
        cycle_value += room.height_increases[i]
    for i in range(extra):
        extra_value += room.height_increases[i + room.cycle_at]

    return room.max_height + full_cycles * cycle_value + extra_value

print("P1: %s" % height_at(room, dropped - 1, 2022))
print("P2: %s" % height_at(room, dropped - 1, 1000000000000))
