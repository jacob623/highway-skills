#!/usr/bin/env bash
# Verifies that Controls and NFRs are independent owners.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact
# Seeded failure probe: source ownership markers and retained relationship checks must fail on regressions.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONTROL_SKILL="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md"
NFR_SKILL="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
CONTROL_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/control-record.md"
NFR_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/nfr-record.md"
fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

for forbidden in \
	"candidate-generation" \
	"nfr-candidate-state" \
	"Control-Derived NFR" \
	"pending Control-derived" \
	'originating `CTLXXXXXX`'; do
	if grep -Fq "$forbidden" "$CONTROL_SKILL" || grep -Fq "$forbidden" "$NFR_SKILL"; then
		echo "FAIL: obsolete candidate ownership reference remains: $forbidden"
		fail=1
	fi
done

for required in \
	"Control Development Lifecycle" \
	"Control Queue and Acceptance Boundaries" \
	"Selected recommendations enter the active development queue" \
	"Control capture has no NFR side effect" \
	"independently managed NFRs"; do
	require_text "$CONTROL_SKILL" "$required"
done

for required in \
	"Status: Complete|Missing|Blocked" \
	"Readiness is independent of Control collection" \
	"without requiring Control-originated state" \
	"controls: []"; do
	require_text "$NFR_SKILL" "$required"
done

if [[ -e "$HIGHWAY_ROOT/catalog/nfr-candidate-state.md" ]]; then
	echo "FAIL: obsolete NFR candidate-state artifact still exists"
	fail=1
else
	echo "PASS: candidate-state artifact is absent"
fi

require_text "$CONTROL_TEMPLATE" "nfrs: []"
require_text "$NFR_TEMPLATE" "controls: []"

# Retained relationship semantics remain identifier-only and user-owned.
if grep -Fq 'nfrs: [NFR000001]' "$SCRIPT_DIR/fixtures/relationship-integrity/valid/controls/CTL000001.md" &&
	grep -Fq 'controls: [CTL000001]' "$SCRIPT_DIR/fixtures/relationship-integrity/valid/nfrs/NFR000001.md"; then
	echo "PASS: retained Control/NFR relationship fixtures remain unchanged"
else
	echo "FAIL: retained Control/NFR relationship fixtures changed"
	fail=1
fi

exit "$fail"
