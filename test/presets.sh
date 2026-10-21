#!/bin/sh
# Every preset must load, pass clean code and fail on a base rule (no-console).
set -eu
cd "$(dirname "$0")/.."
for preset in oxlint/*.json; do
  oxlint -c "$preset" test/ok.ts >/dev/null || { echo "FAIL $preset: clean code rejected"; exit 1; }
  if oxlint -c "$preset" test/bad.ts >/dev/null 2>&1; then
    echo "FAIL $preset: no-console not enforced"; exit 1
  fi
  echo "ok $preset"
done
