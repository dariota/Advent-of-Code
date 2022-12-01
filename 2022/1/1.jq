# Run with jq -Rs -f 1.jq input
[split("\n\n")[] | split("\n")] | map([.[] | select(. != "") | tonumber]) | map(add) | max
