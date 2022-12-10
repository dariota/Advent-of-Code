file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

class Rope:
    def __init__(self):
        self.head = (0,0)
        self.tail = (0,0)
        self.to_update = { self.tail }


    def add_rope(self, rope):
        self.to_update = rope


    def move_head(self, direction, movement):
        #print("Moving head %s by %s starting at %s" % (direction, movement, self.head))
        for _ in range(0, movement):
            head_x, head_y = self.head

            if direction == "U":
                self.head = (head_x, head_y + 1)
            elif direction == "R":
                self.head = (head_x + 1, head_y)
            elif direction == "L":
                self.head = (head_x - 1, head_y)
            else:
                self.head = (head_x, head_y - 1)

            #print("Head %s" % (self.head,), end=" ")
            self.update_tail()

    
    def set_head(self, new_head):
        self.head = new_head
        self.update_tail()


    def update_tail(self):
        head_x, head_y = self.head
        tail_x, tail_y = self.tail

        x_inc = int((head_x - tail_x) / 2)
        y_inc = int((head_y - tail_y) / 2)
        total_movement = abs(x_inc) + abs(y_inc)

        if total_movement > 0 and head_x != tail_x and head_y != tail_y:
            # Need to move diagonally
            x_inc = 1 if head_x > tail_x else -1
            y_inc = 1 if head_y > tail_y else -1

        self.tail = (tail_x + x_inc, tail_y + y_inc)
        #print("Tail %s" % (self.tail,))

        if type(self.to_update) == Rope:
            self.to_update.set_head(self.tail)
        else:
            self.to_update.add(self.tail)


def p1(input):
    rope = Rope()

    for line in input:
        direction, movement = line.split(" ")
        rope.move_head(direction, int(movement))

    print("P1: %s" % len(rope.to_update))


def p2(input):
    head = Rope()
    tail = head

    # This looks incorrect since there should be 10 knots, but each rope has a head and tail,
    # so the 9th rope's tail is the 10th knot.
    for i in range(0,8):
        new = Rope()
        tail.add_rope(new)
        tail = new

    for line in input:
        direction, movement = line.split(" ")
        head.move_head(direction, int(movement))

    print("P2: %s" % len(tail.to_update))


p1(input)
p2(input)
