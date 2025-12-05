class Lock:
    def __init__(self):
        self.position = 50
        self.zeroes = 0
        self.passes = 0

    def spin(self, instruction: str):
        direction = instruction[0]
        magnitude = int(instruction[1:])

        if magnitude <= 0:
            raise ValueError(f"Invalid magnitude {magnitude}")

        if direction not in ["L", "R"]:
            raise ValueError(f"Invalid direction {direction}")

        self.passes += magnitude // 100
        magnitude %= 100

        if direction == "L":
            if self.position and magnitude >= self.position:
                self.passes += 1
            magnitude *= -1
        elif self.position + magnitude >= 100:
            self.passes += 1

        self.position = (self.position + magnitude + 100) % 100

        if self.position == 0:
            self.zeroes += 1


if __name__ == "__main__":
    lock = Lock()

    with open("input", "r") as f:
        for line in f:
            lock.spin(line)

    print("Part one:", lock.zeroes)
    print("Part two:", lock.passes)

