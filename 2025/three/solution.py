class JoltChain:
    def __init__(self, max_len):
        self.max_len = max_len
        self.chain = []
        self._next_upgrade = None

    def _find_next_upgrade(self):
        self._next_upgrade = None

        for idx in range(len(self.chain) - 1):
            digit = self.chain[idx]
            if digit == 9:
                continue

            if self.chain[idx + 1] > digit:
                self._next_upgrade = idx
                return

    def add_to_chain(self, num):
        if num < 0 or num > 9:
            raise ValueError("Chain must contain single digits only")

        if len(self.chain) < self.max_len:
            self.chain.append(num)

            if len(self.chain) == self.max_len:
                self._find_next_upgrade()
        else:
            if self._next_upgrade is None:
                if num > self.chain[-1]:
                    del self.chain[-1]
                    self.chain.append(num)
                    self._find_next_upgrade()
            else:
                del self.chain[self._next_upgrade]
                self.chain.append(num)
                self._find_next_upgrade()

    @property
    def joltage(self):
        mult = 1
        total = 0

        for digit in reversed(self.chain):
            total += digit * mult
            mult *= 10

        return total


class Jolter:
    @staticmethod
    def max_joltage(max_len: int, bank: str):
        chain = JoltChain(max_len=max_len)

        if len(bank) < max_len:
            raise ValueError(f"Need at least {max_len} batteries to create a joltage")

        for i in bank:
            chain.add_to_chain(int(i))

        return chain.joltage


if __name__ == "__main__":
    with open("input", "r") as f:
        one = 0
        two = 0
        for line in f:
            line = line.strip()
            one += Jolter.max_joltage(max_len=2, bank=line)
            two += Jolter.max_joltage(max_len=12, bank=line)

        print("Part one:", one)
        print("Part two:", two)
