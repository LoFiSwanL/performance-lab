#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
PERF=${PERF:-perf}
ROUNDS=${ROUNDS:-8000}
mkdir -p results
for rep in 1 2 3; do
  if [ "$rep" = 2 ]; then order='3 0'; else order='0 3'; fi
  for opt in $order; do
    echo "time/stat/energy: O${opt}, repetition ${rep}"
    /usr/bin/time --verbose -o "results/O${opt}_time${rep}.txt" "./build/lab_O${opt}" "$ROUNDS" > "results/O${opt}_run${rep}.out"
    "$PERF" stat -d -o "results/O${opt}_stat${rep}.txt" -- "./build/lab_O${opt}" "$ROUNDS" > "results/O${opt}_stat${rep}.out"
    python3 scripts/energy.py "results/O${opt}_energy${rep}" "./build/lab_O${opt}" "$ROUNDS"
  done
done
