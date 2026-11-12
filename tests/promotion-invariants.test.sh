#!/usr/bin/env bash
# Invariants for the promoted skill suite: identifiers, one Decision per Discovery,
# a conceptual Reference Architecture, and catalog status vocabularies.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: --probe source-document observes a missing invariant token; --neutralise restores it.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
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
		printf '%s\n' 'missing invariant' >"$probe_path"
	else
		printf '%s\n' 'RA plus those eight hex digits' >"$probe_path"
	fi
	grep -Fq 'RA plus those eight hex digits' "$probe_path"
	status=$?
	rm -f "$probe_path"
	exit "$status"
fi

require_text() {
	local file="$1" text="$2"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: missing $file"
		fail=1
		return
	fi
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: $file missing '$text'"
		fail=1
	fi
}

ARCH="$(fl_skill_text_file "$HW_SKILLS/highway-architecture")"
ADR="$(fl_skill_text_file "$HW_SKILLS/highway-adr")"
OBJ="$(hw_template objective-catalog)"
REQ="$(fl_skill_text_file "$HW_SKILLS/highway-request")"
IMPL="$(fl_skill_text_file "$HW_SKILLS/highway-implementation")"
CAP="$(hw_template capability-catalog)"

require_text "$ARCH" "The id is \`RA\` plus those eight hex digits."
require_text "$ARCH" "Do not name a platform, product, vendor, or specific technology"
require_text "$ADR" "One Discovery has one ADR."
require_text "$OBJ" "active or removed"
require_text "$REQ" "Status is \`accepted\` or \`removed\`."
require_text "$IMPL" "CAP plus eight hex digits"
if grep -Fq 'Next ID:' "$CAP"; then
	echo "FAIL: $CAP still allocates Next ID"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: promotion-invariants.test.sh"
