#!/usr/bin/env bash
# Discovers and runs every *.test.sh under tools/tests/, prints a pass/fail summary, and exits
# non-zero if any test fails.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pass=0
fail=0
failed_names=()

shopt -s nullglob
for test_file in "$SCRIPT_DIR"/*.test.sh; do
	name="$(basename "$test_file")"
	echo "==> Running $name"
	if bash "$test_file"; then
		echo "PASS: $name"
		pass=$((pass + 1))
	else
		echo "FAIL: $name"
		fail=$((fail + 1))
		failed_names+=("$name")
	fi
	echo
done
shopt -u nullglob

echo "--------------------------------------"
echo "Summary: $pass passed, $fail failed"
if (( fail > 0 )); then
	echo "Failed tests:"
	for n in "${failed_names[@]}"; do
		echo "  - $n"
	done
	exit 1
fi
exit 0
