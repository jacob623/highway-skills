#!/usr/bin/env bash
# Confirms highway-new stays reserved and does not collect a request.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: --probe source-document observes a missing reservation token; --neutralise restores it.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-new/SKILL.md"
fail=0

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
if [[ -n "$probe_class" && "$probe_class" != "source-document" ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi
if [[ -n "$probe_class" ]]; then
	probe_path="$(mktemp)"
	if [[ "$neutralise" -eq 0 ]]; then
		printf '%s\n' 'missing reservation' >"$probe_path"
	else
		printf '%s\n' 'highway-request' >"$probe_path"
	fi
	grep -Fq 'highway-request' "$probe_path"
	status=$?
	rm -f "$probe_path"
	exit "$status"
fi

require_text() {
	local text="$1"
	if ! grep -Fq "$text" "$SKILL"; then
		echo "FAIL: $SKILL missing '$text'"
		fail=1
	fi
}

require_text "Does not use a request."
require_text "highway-request"
require_text "Write nothing."
if grep -Fq 'requests/[ID].md' "$SKILL"; then
	echo "FAIL: highway-new still writes a request record"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: highway-new.test.sh"
