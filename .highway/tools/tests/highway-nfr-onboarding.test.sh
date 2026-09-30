#!/usr/bin/env bash
# Verifies Feature 077 NFR candidate review and readiness contracts.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: fixture markers and contract assertions must detect seeded defects.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
FIXTURES="$HIGHWAY_ROOT/tools/tests/fixtures/controls-nfr-onboarding"
fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

for text in \
	"setup" \
	"configure" \
	"pending Control-derived candidates" \
	"accept, modify, replace, reject, or skip" \
	"Are there any qualities or operational expectations you'd like future solutions to meet?" \
	"Collection Result: Continue|Finished" \
	"Action Status: Succeeded|Declined|Aborted|Blocked" \
	"does not include a created-NFR-ID list" \
	"captured as your NFR" \
	"Why it matters" \
	"Would you like to accept this NFR?" \
	"Direct capture skips the inferred-content review" \
	"Explicitly selected recommendations" \
	"pending Control-derived candidates" \
	"direct capture" \
	"controls: []" \
	"In Progress" \
	"Not Applicable" \
	"Blocked"; do
	require_text "$SKILL" "$text"
done
for text in \
	"candidate state" \
	"exactly once" \
	"Collection Result: Finished" \
	"zero candidates" \
	"non-empty reason" \
	"no partial NFR relationship"; do
	require_text "$SKILL" "$text"
done

for marker in \
	"nfr-review-status=Empty" \
	"nfr-review-entry-count=0"; do
	if ! grep -R -Fq "$marker" "$FIXTURES/empty-baseline"; then
		echo "FAIL: Feature 078 NFR Review marker '$marker' missing"
		fail=1
	fi
done

for scenario in empty-baseline valid-existing malformed duplicate undecided injected-failure; do
	if [[ ! -f "$FIXTURES/$scenario/state.txt" ]]; then
		echo "FAIL: missing Feature 077 fixture scenario: $scenario"
		fail=1
	fi
done

for marker in \
	"expected=guided-collection" \
	"expected=existing-actions" \
	"expected=blocked" \
	"reviewability=independent" \
	"expected=completion-fails" \
	"expected=rollback"; do
	if ! grep -R -Fq "$marker" "$FIXTURES"; then
		echo "FAIL: Feature 077 fixture marker '$marker' missing"
		fail=1
	fi
done

if [[ "$fail" -eq 0 ]]; then
	echo "OK: Feature 077 NFR onboarding contract"
fi
exit "$fail"
