# Run with jq -Rs -f 2.jq input
[limit(3; [split("\n\n")[] | split("\n")] | map([.[] | select(. != "") | tonumber]) | map(add) | sort | reverse | .[])] | add
