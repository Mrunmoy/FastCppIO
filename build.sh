#!/usr/bin/env bash
set -euo pipefail

# Configurable via env:
#   BUILD_DIR (default: build)
#   N         (default: 5000000)
#   INPUT     (default: input.txt)
BUILD_DIR="${BUILD_DIR:-build}"
N="${N:-5000000}"
INPUT="${INPUT:-input.txt}"

echo "==> Configuring (Release)"
cmake -S . -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release

echo "==> Building"
cmake --build "$BUILD_DIR" -j

# Generate input if missing or too short
if [ ! -f "$INPUT" ] || [ "$(wc -l < "$INPUT")" -lt "$N" ]; then
  echo "==> Generating input file: $INPUT ($N lines)"
  if command -v seq >/dev/null 2>&1; then
    seq 1 "$N" > "$INPUT"
  else
    python3 - <<PY > "$INPUT"
for i in range(1, $N+1):
    print(i)
PY
  fi
fi

SLOW="./$BUILD_DIR/io_benchmark_slow"
FAST="./$BUILD_DIR/io_benchmark_fast"

echo "==> Running SLOW (default iostream)"
# Discard stdout (millions of numbers), capture stderr (Elapsed: ...)
SLOW_OUT=$({ "$SLOW" "$N" < "$INPUT" 1>/dev/null; } 2>&1)
echo "$SLOW_OUT"
SLOW_MS=$(awk '/Elapsed:/ {print $2}' <<< "$SLOW_OUT")

echo "==> Running FAST (sync_with_stdio(false); cin.tie(nullptr);)"
FAST_OUT=$({ "$FAST" "$N" < "$INPUT" 1>/dev/null; } 2>&1)
echo "$FAST_OUT"
FAST_MS=$(awk '/Elapsed:/ {print $2}' <<< "$FAST_OUT")

if [[ -n "${SLOW_MS:-}" && -n "${FAST_MS:-}" ]]; then
  IMPROVEMENT=$(awk -v s="$SLOW_MS" -v f="$FAST_MS" \
    'BEGIN { if (s > 0) printf "%.1f", (s-f)/s*100; else print "0.0" }')
  echo
  echo "--- Benchmark Summary ---"
  echo "Slow : ${SLOW_MS} ms"
  echo "Fast : ${FAST_MS} ms"
  echo "Improvement: ${IMPROVEMENT}% faster"
else
  echo "Warning: could not parse timing lines." >&2
fi

echo "Done."
