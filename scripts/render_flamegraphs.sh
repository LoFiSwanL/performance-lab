#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
# A shared sample scale makes the two recorded profiles comparable.
n0=$(awk '{n += $NF} END {print n}' results/O0.folded)
n3=$(awk '{n += $NF} END {print n}' results/O3.folded)
total=$n0
if (( n3 > total )); then total=$n3; fi
for opt in 0 3; do
  n=$(awk '{n += $NF} END {print n}' "results/O${opt}.folded")
  perl tools/FlameGraph/flamegraph.pl \
    --title "CPU FlameGraph: -O${opt}" \
    --subtitle "${n} samples | shared full-width scale: ${total} samples | frames below 0.1% hidden" \
    --total "$total" --minwidth '0.1%' --height 22 --hash \
    --countname samples "results/O${opt}.folded" > "results/O${opt}_flamegraph.svg"
done
