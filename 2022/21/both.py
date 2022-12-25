file = open("input", "r")
lines = list(map(lambda s: s.rstrip('\n'), file.readlines()))
file.close()

class Monkey:
    def __init__(self, name, expr, others):
        self.name = name
        self.others = others
        self.included = None

        parts = expr.split(' ')

        if len(parts) == 1:
            self.oper = 0
            self.left = int(parts[0])
        else:
            self.oper = parts[1]
            self.left = parts[0]
            self.right = parts[2]

    def left_monkey(self):
        if self.oper == 0:
            raise Exception("I'm a constant")

        return self.others[self.left]

    def right_monkey(self):
        if self.oper == 0:
            raise Exception("I'm a constant")

        return self.others[self.right]

    def evaluate(self):
        if self.oper == 0:
            return self.left

        left = self.left_monkey().evaluate()
        right = self.right_monkey().evaluate()
        if self.oper == '+':
            return left + right
        elif self.oper == '-':
            return left - right
        elif self.oper == '*':
            return left * right
        else: # self.oper == '/'
            return int(left / right)

    def includes_me(self):
        if self.name == 'humn':
            return True

        if self.oper == 0:
            return False

        if self.included is None:
            self.included = self.left_monkey().includes_me() or self.right_monkey().includes_me()

        return self.included

    def hit_target(self, target):
        if self.name == 'humn':
            return target

        left_monkey = self.left_monkey()
        right_monkey = self.right_monkey()

        if right_monkey.includes_me():
            value = left_monkey.evaluate()
            if self.name == 'root':
                return right_monkey.hit_target(value)

            if self.oper == '+':
                return right_monkey.hit_target(target - value)
            elif self.oper == '-':
                return right_monkey.hit_target(value - target)
            elif self.oper == '*':
                return right_monkey.hit_target(int(target / value))
            else: # self.oper == '/'
                return right_monkey.hit_target(int(value / target))
        elif left_monkey.includes_me():
            value = right_monkey.evaluate()
            if self.name == 'root':
                return left_monkey.hit_target(value)

            if self.oper == '+':
                return left_monkey.hit_target(target - value)
            elif self.oper == '-':
                return left_monkey.hit_target(target + value)
            elif self.oper == '*':
                return left_monkey.hit_target(int(target / value))
            else: # self.oper == '/'
                return left_monkey.hit_target(target * value)



root_monkey = None
monkeys = {}
for line in lines:
    name, expr = line.split(': ')
    monkeys[name] = Monkey(name, expr, monkeys)
    if name == 'root':
        root_monkey = monkeys[name]

print("P1:", root_monkey.evaluate())
print("P2:", root_monkey.hit_target(None))
