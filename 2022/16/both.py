import re
import functools
import heapq

file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

class Node:
    def __init__(self, label, flow_rate, edges):
        self.label = label
        self.flow_rate = int(flow_rate)
        self.edges = edges

    def optimise_edges(self, nodes):
        # Dijkstra adapted from https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm#Pseudocode
        self.optimised_edges = {}
        self.optimised_edges[self.label] = 0

        pq = []
        for node in nodes.values():
            if node.label != self.label:
                self.optimised_edges[node.label] = 31 # effectively infinite with 30 minute limit
            heapq.heappush(pq, (self.optimised_edges[node.label], node))

        while len(pq) > 0:
            prio, node = heapq.heappop(pq)
            if prio > self.optimised_edges[node.label]:
                # We've found a shorter path to this, ignore it
                continue

            for edge, dist in node.edges.items():
                dist_via = self.optimised_edges[node.label] + dist
                if dist_via < self.optimised_edges[edge]:
                    self.optimised_edges[edge] = dist_via
                    heapq.heappush(pq, (dist_via, nodes[edge]))

    @functools.total_ordering
    def __lt__(self, other):
        return False

    def __eq__(self, other):
        return True


    @classmethod
    def parse(cls, line):
        matches = re.match("Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)", line)
        if matches is None:
            print(line)
        label = matches[1]
        flow_rate = matches[2]
        edges = dict((edge, 1) for edge in matches[3].split(", "))
        return Node(label, flow_rate, edges)


# gather nodes
nodes = [Node.parse(line) for line in lines]
nodes = dict([(node.label, node) for node in nodes])

# calculate costs from non-0 nodes to all other non-0 nodes
important_nodes = {}
for node in nodes.values():
    if node.flow_rate > 0 or node.label == "AA":
        important_nodes[node.label] = node
        node.optimise_edges(nodes)

# remove all irrelevant paths
for node in nodes.values():
    if node.flow_rate == 0:
        for other_node in important_nodes.values():
            del other_node.optimised_edges[node.label]

class Move:
    def __init__(self, pressure_released, time_remaining, visited, agents):
        self.pressure_released = pressure_released
        self.time_remaining = time_remaining
        self.visited = visited
        self.agents = []
        for available_at, position in agents:
            heapq.heappush(self.agents, (available_at, position))

    def next_agent(self):
        available_at, position = heapq.heappop(self.agents)
        return (-available_at, position)

    def add_agent(self, available_at, position):
        # Why is there no max heap
        heapq.heappush(self.agents, (-available_at, position))

    def potential(self, nodes):
        # If every valve was opened the next time an agent was available to open them, even if they
        # were opening some other valve at that time, how much pressure would we release?
        max_potential = 0

        for node in nodes.values():
            if node.label in self.visited:
                continue

            max_value = 0
            for available_at, pos in self.agents:
                available_at = -available_at
                time_remaining = available_at - nodes[pos].optimised_edges[node.label] - 1
                if node.flow_rate * time_remaining > max_value:
                    max_value = node.flow_rate * time_remaining
            max_potential += max_value

        return self.pressure_released + max_potential
    

def solve(agents):
    agents = [(-available_at, pos) for available_at, pos in agents]
    visited = set(map(lambda agent: agent[1], agents))
    moves = [Move(0, 30, visited, agents)]
    max_move = moves[0]
    while len(moves) > 0:
        move = moves.pop(-1)
        if move.pressure_released > max_move.pressure_released:
            max_move = move

        if move.potential(important_nodes) < max_move.pressure_released:
            continue

        next_agent = move.next_agent()
        next_time = move.time_remaining
        if next_agent[0] < move.time_remaining:
            next_time = next_agent[0]

        for next_label, cost in important_nodes[next_agent[1]].optimised_edges.items():
            if next_label in move.visited:
                continue

            next_node = important_nodes[next_label]
            time_after_action = next_time - cost - 1 # 1 == cost to open
            if time_after_action <= 0:
                continue
            
            visited = set(move.visited)
            visited.add(next_label)
            next_move = Move(move.pressure_released + next_node.flow_rate * time_after_action, next_time, visited, move.agents)
            next_move.add_agent(time_after_action, next_label)
            moves.append(next_move)

    return max_move

print("P1: %s" % solve([(30, 'AA')]).pressure_released)
print("P2: %s" % solve([(26, 'AA'), (26, 'AA')]).pressure_released)
