file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

class NumNode:
    def __init__(self, val):
        self.val = val

    def set_prev(self, node):
        self.prev = node

    def set_next(self, node):
        self.next = node

    def advance(self, node_count):
        sign = 1 if self.val > 0 else -1
        move = (abs(self.val) % (node_count - 1)) * sign
        inv_move = (node_count - 1 - move) * sign * -1

        move = move if abs(move) < abs(inv_move) else inv_move
        if move == 0:
            return

        self.prev.next = self.next
        self.next.prev = self.prev

        if move < 0:
            node = self.previous_by(abs(move))
            self.next = node
            self.prev = node.prev
            node.prev = self
            self.prev.next = self
        else:
            node = self.next_by(move)
            self.prev = node
            self.next = node.next
            node.next = self
            self.next.prev = self

    def previous_by(self, n):
        node = self
        for _ in range(n):
            node = node.prev

        return node

    def next_by(self, n):
        node = self
        for _ in range(n):
            node = node.next

        return node


def parse_nodes(lines):
    zero_node = None
    nodes = []
    prev = None
    for line in lines:
        node = NumNode(int(line))
        if prev:
            prev.set_next(node)
            node.set_prev(prev)

        prev = node
        nodes.append(node)
        if node.val == 0:
            zero_node = node

    nodes[0].set_prev(nodes[-1])
    nodes[-1].set_next(nodes[0])

    return (zero_node, nodes)


def sum_coords(node):
    coords = 0
    for _ in range(3):
        node = node.next_by(1000)
        coords += node.val

    return coords


def p1(lines):
    zero_node, nodes = parse_nodes(lines)
    for node in nodes:
        node.advance(len(nodes))

    print("P1:", sum_coords(zero_node))

def p2(lines):
    zero_node, nodes = parse_nodes(lines)
    for node in nodes:
        node.val *= 811589153

    for _ in range(10):
        for node in nodes:
            node.advance(len(nodes))

    print("P2:", sum_coords(zero_node))

p1(lines)
p2(lines)
