import operator
import functools

file = open("input", "r")
input = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

class Monkey:
    def __init__(self, items, operation, test, success, fail):
        self.__items = list(map(int, items.split(": ")[1].split(", ")))

        formula = operation.split(" = ")[1].split(" ")
        oper = operator.add if formula[1] == "+" else operator.mul
        def operation(old):
            l = old if formula[0] == "old" else int(formula[0])
            r = old if formula[2] == "old" else int(formula[2])
            return oper(l, r)
        self.__operation = operation

        self.__test = int(test.split(" by ")[1])

        self.__success_id = int(success.split(" monkey ")[1])

        self.__fail_id = int(fail.split(" monkey ")[1])
        
        self.__inspections = 0


    def catch(self, item):
        self.__items.append(item)


    def inspect(self, monkeys, limiter):
        self.__inspections += len(self.__items)

        for item in self.__items:
            worry = limiter(self.__operation(item))
            if worry % self.__test == 0:
                monkeys[self.__success_id].catch(worry)
            else:
                monkeys[self.__fail_id].catch(worry)

        self.__items = []


    def inspection_count(self):
        return self.__inspections


    def get_test_val(self):
        return self.__test


def parse_monkeys(input):
    monkeys = []
    for i in range(0, int((len(input) + 1) / 7)):
        base = i * 7
        monkey = Monkey(input[base + 1], input[base + 2], input[base + 3], input[base + 4], input[base + 5])
        monkeys.append(monkey)

    return monkeys


def run_rounds(monkeys, count, limiter):
    for i in range(0, count):
        for monkey in monkeys:
            monkey.inspect(monkeys, limiter)

    counts = list(map(Monkey.inspection_count, monkeys))
    counts.sort()
    return counts[-1] * counts[-2]


def p1(input):
    monkeys = parse_monkeys(input)
    limiter = lambda worry: int(worry / 3)
    print("P1: %s" % run_rounds(monkeys, 20, limiter))
    

def p2(input):
    monkeys = parse_monkeys(input)
    limit = functools.reduce(operator.mul, map(Monkey.get_test_val, monkeys))
    limiter = lambda worry: worry % limit
    print("P2: %s" % run_rounds(monkeys, 10000, limiter))


p1(input)
p2(input)
