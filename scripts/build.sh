#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
mkdir -p build
CC=${CC:-cc}
for opt in 0 3; do
  "$CC" -std=c11 -Wall -Wextra -g -O"$opt" -fno-omit-frame-pointer src/main.c -o build/lab_O"$opt"
  "$CC" -std=c11 -O"$opt" -fno-omit-frame-pointer -S src/main.c -o build/lab_O"$opt".s
done
