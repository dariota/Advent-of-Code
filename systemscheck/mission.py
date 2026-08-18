import itertools
import re
import sys

from collections import defaultdict

time_disabled = defaultdict(int)
disabled_at = {}
disable_count = [(0, 0)]

pattern = re.compile(r'^t=(\d+) #(\d+) (\w+)$')

with open(sys.argv[1]) as f:
    for line in f:
        last_time, last_disabled = disable_count[-1]

        time, core_id, action = pattern.match(line).group(1, 2, 3)
        time = int(time)
        core_id = int(core_id)
        enabled = action == "enabled"

        if enabled:
            time_disabled[core_id] = max(time - disabled_at[core_id], time_disabled[core_id])
            del disabled_at[core_id]
        else:
            disabled_at[core_id] = time

        if last_time == time:
            disable_count.pop()

        disable_delta = -1 if enabled else 1
        disable_count.append((time, last_disabled + disable_delta))

end_time = time + 1
for core_id, disable_time in disabled_at.items():
    time_disabled[core_id] = max(end_time - disable_time, time_disabled[core_id])

print("Longest single disabled duration", max((duration, core_id) for core_id, duration in time_disabled.items())[0])

disable_count.append((end_time, len(time_disabled.keys())))
max_disabled = 0
max_disable_length = 0
for ((first_time, first_disable), (second_time, second_disable)) in itertools.pairwise(disable_count):
    disable_length = second_time - first_time

    if first_disable > max_disabled:
        max_disabled = first_disable
        max_disable_length = disable_length
    elif first_disable == max_disabled:
        max_disable_length = max(disable_length, max_disable_length)

print("Longest single duration at minimum capacity", max_disable_length)
