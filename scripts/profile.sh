#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
PERF=${PERF:-perf}
ROUNDS=${ROUNDS:-8000}
mkdir -p results
for opt in 0 3; do
  "$PERF" record -e cpu-clock -F 199 -g --call-graph dwarf -o "results/O${opt}.perf.data" -- "./build/lab_O${opt}" "$ROUNDS" > "results/O${opt}_profile.stdout.txt" 2> "results/O${opt}_record.txt"
  "$PERF" report --no-inline -i "results/O${opt}.perf.data" --stdio > "results/O${opt}_report.txt"
  "$PERF" script --no-inline -F -period -i "results/O${opt}.perf.data" > "results/O${opt}_stacks.txt"
  perl tools/FlameGraph/stackcollapse-perf.pl "results/O${opt}_stacks.txt" > "results/O${opt}.folded"
done
bash scripts/render_flamegraphs.sh
