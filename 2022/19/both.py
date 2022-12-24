import math
import re
from enum import Enum

file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

class Resource(Enum):
    ORE = 0
    CLAY = 1
    OBSIDIAN = 2
    GEODE = 3

class Blueprint:
    def __init__(self, number, ore_cost, clay_cost, obsid_cost, geode_cost):
        self.number = number

        self.costs = [0] * 4
        self.costs[Resource.ORE.value] = ore_cost
        self.costs[Resource.CLAY.value] = clay_cost
        self.costs[Resource.OBSIDIAN.value] = obsid_cost
        self.costs[Resource.GEODE.value] = geode_cost

        self.max_bots = [0] * 4
        self.max_bots[Resource.ORE.value] = max(self.costs[Resource.CLAY.value], self.costs[Resource.OBSIDIAN.value][0], self.costs[Resource.GEODE.value][0])
        self.max_bots[Resource.CLAY.value] = self.costs[Resource.OBSIDIAN.value][1]
        self.max_bots[Resource.OBSIDIAN.value] = self.costs[Resource.GEODE.value][1]
        self.max_bots[Resource.GEODE.value] = 1000000

        self.max_geodes_seen = 0


    def max_geodes(self, turn, bots, resources, max_turns):
        turns_remaining = max_turns - turn
        if turns_remaining * bots[Resource.GEODE.value] + resources[Resource.GEODE.value] + int(((turns_remaining - 1) * (turns_remaining)) / 2) <= self.max_geodes_seen:
            return 0
        if turn == max_turns:
            geodes = resources[Resource.GEODE.value]
            if geodes > self.max_geodes_seen:
                self.max_geodes_seen = geodes
            return geodes

        max_geodes_in_branch = 0
        any_progress = False
        # Skip ahead to the next action we can take, starting with the highest value bot
        # to maximise branch value early.
        for resource in range(len(resources) - 1, -1, -1):
            time_to_build = self.__time_to_build(resource, bots, resources)
            # Can't build this one either at all, or soon enough to matter
            if time_to_build is None or turn + time_to_build > max_turns:
                continue

            # We've done something, and doing something will always be the same or better
            # than doing nothing in that time, so we can skip the waiting state.
            any_progress = True

            # Fast forward to our next action
            after_production = self.__advance_by(time_to_build, bots, resources)
            self.__build(1, resource, bots, after_production)
            max_geodes_in_branch = max(max_geodes_in_branch, self.max_geodes(turn + time_to_build, bots, after_production, max_turns))

            # Unwind the action to continue the search from here
            self.__build(-1, resource, bots, after_production)

        if not any_progress:
            after_production = self.__advance_by(turns_remaining, bots, resources)
            max_geodes_in_branch = max(max_geodes_in_branch, self.max_geodes(turn + turns_remaining, bots, after_production, max_turns))

        return max_geodes_in_branch


    def __advance_by(self, turns, bots, resources):
            return [resources[x] + bots[x] * turns for x in range(len(resources))]


    def __time_to_build(self, resource, bots, resources):
        if bots[resource] >= self.max_bots[resource]:
            return None

        time_to_mine = None
        if resource == Resource.ORE.value:
            missing_ore = self.costs[resource] - resources[Resource.ORE.value]
            time_to_mine = math.ceil(missing_ore / bots[Resource.ORE.value])
        elif resource == Resource.CLAY.value:
            missing_ore = self.costs[resource] - resources[Resource.ORE.value]
            time_to_mine = math.ceil(missing_ore / bots[Resource.ORE.value])
        elif resource == Resource.OBSIDIAN.value:
            if bots[Resource.ORE.value] == 0 or bots[Resource.CLAY.value] == 0:
                return None

            missing_ore = self.costs[resource][0] - resources[Resource.ORE.value]
            missing_clay = self.costs[resource][1] - resources[Resource.CLAY.value]
            time_to_mine = max(math.ceil(missing_ore / bots[Resource.ORE.value]),
                               math.ceil(missing_clay / bots[Resource.CLAY.value]))
        else:
            if bots[Resource.OBSIDIAN.value] == 0:
                return None

            missing_ore = self.costs[resource][0] - resources[Resource.ORE.value]
            missing_obsidian = self.costs[resource][1] - resources[Resource.OBSIDIAN.value]
            time_to_mine = max(math.ceil(missing_ore / bots[Resource.ORE.value]),
                               math.ceil(missing_obsidian / bots[Resource.OBSIDIAN.value]))

        return max(1, time_to_mine + 1)


    def __build(self, count, resource, bots, resources):
        bots[resource] += count

        if resource == Resource.ORE.value:
            resources[Resource.ORE.value] -= count * self.costs[resource]
        elif resource == Resource.CLAY.value:
            resources[Resource.ORE.value] -= count * self.costs[resource]
        elif resource == Resource.OBSIDIAN.value:
            resources[Resource.ORE.value] -= count * self.costs[resource][0]
            resources[Resource.CLAY.value] -= count * self.costs[resource][1]
        else:
            resources[Resource.ORE.value] -= count * self.costs[resource][0]
            resources[Resource.OBSIDIAN.value] -= count * self.costs[resource][1]


    @classmethod
    def parse(cls, line):
        matches = re.match('Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian.', line)
        return Blueprint(int(matches[1]), int(matches[2]), int(matches[3]), (int(matches[4]), int(matches[5])), (int(matches[6]), int(matches[7])))


total_quality = 0
blueprints = []
for line in lines:
    bp = Blueprint.parse(line)
    blueprints.append(bp)
    quality = bp.max_geodes(1, [1, 0, 0, 0], [1, 0, 0, 0], 24)
    total_quality += bp.number * quality

print("P1: %s" % total_quality)

geode_product = 1
for bp in blueprints[0:3]:
    geode_product *= bp.max_geodes(1, [1, 0, 0, 0], [1, 0, 0, 0], 32)

print("P2: %s" % geode_product)
