import re

from functools import reduce


def _operator(op):
    if op == "+":
        return lambda a, b: a + b
    elif op == "*":
        return lambda a, b: a * b
    else:
        raise ValueError(f"Unknown operator {op}")


class Worksheet:
    def __init__(self, lines: list[str]):
        self._lines = lines

    def calculate(self):
        lines = [re.sub(r"\s+", " ", line.strip()).split(" ") for line in self._lines]
        values = [[int(i) if i not in ["+", "*"] else i for i in line] for line in lines]

        total = 0

        for col in range(len(values[0])):
            reducer = _operator(values[-1][col])
            total += reduce(reducer, (row[col] for row in values[:-1]))

        return total

    def cephalocalc(self):
        grand_total = 0
        running_total = 0

        for col in range(len(self._lines[0])):
            if (operator := self._lines[-1][col]) != " ":
                grand_total += running_total
                running_total = 0 if operator == "+" else 1
                reducer = _operator(operator)

            number = None
            for row in range(len(self._lines) - 1):
                if self._lines[row][col] == " ":
                    continue
                
                number = (number or 0) * 10 + int(self._lines[row][col])

            if number is not None:
                running_total = reducer(running_total, number)

        # Running total is normally added when we reach the next operator, but there's none at the end
        return grand_total + running_total


if __name__ == "__main__":
    with open("input", "r") as f:
        # drop the newlines, without using strip so lines maintain the same length
        worksheet = Worksheet([line[:-1] for line in f])
        print("Part one:", worksheet.calculate())
        print("Part two:", worksheet.cephalocalc())
