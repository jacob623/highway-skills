#!/usr/bin/env bash
# Every harness switch is declared once in harness/src/switches.ts with help text, and appears in
# harness/README.md, so help and documentation cannot drift from the parser.
set -u
# Instrument class: static-document-contract
# Artifact classes: harness-switch-table, harness-readme
# Seeded failure probe: a switch line with an empty usage, or a switch missing from harness/README.md, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
SWITCHES="$HW_HARNESS/src/switches.ts"
README="$HW_HARNESS/README.md"
fail=0

if [[ ! -f "$SWITCHES" ]]; then
	echo "FAIL: harness/src/switches.ts does not exist"
	exit 1
fi

lines="$(grep -E '^[[:space:]]*\{ name: "--' "$SWITCHES")"
count="$(printf '%s\n' "$lines" | grep -c .)"
if [[ "$count" -lt 10 ]]; then
	echo "FAIL: harness/src/switches.ts declares $count switches; expected one per line"
	fail=1
fi

while IFS= read -r line; do
	[[ -n "$line" ]] || continue
	if [[ "$(printf '%s\n' "$line" | grep -o 'name: "' | grep -c .)" -ne 1 ]]; then
		echo "FAIL: a switches.ts line declares more than one switch: $line"
		fail=1
		continue
	fi
	name="$(printf '%s\n' "$line" | sed -E 's/.*name: "([^"]+)".*/\1/')"
	usage="$(printf '%s\n' "$line" | sed -nE 's/.*usage: "([^"]*)".*/\1/p')"
	if [[ -z "$usage" ]]; then
		echo "FAIL: switch $name has no help text"
		fail=1
	fi
	if [[ ! -f "$README" ]] || ! grep -qF -- "\`$name" "$README"; then
		echo "FAIL: switch $name does not appear in harness/README.md"
		fail=1
	fi
done <<<"$lines"

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: every harness switch has help text and appears in harness/README.md"
