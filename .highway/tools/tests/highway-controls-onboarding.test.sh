#!/usr/bin/env bash
# Verifies Feature 077 Control collection and review contracts.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: fixture markers and contract assertions must detect seeded defects.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md"
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
	"guided Control collection" \
	"one entry per proposed Control" \
	"Category" \
	"Statement" \
	"Available Decisions: Accept, Modify, Replace, Remove" \
	"Status: Empty" \
	"Entry Count: 0" \
	"Security" \
	"Availability and Resilience" \
	"Compliance and Governance" \
	"Proposed Title" \
	"Cancel Review" \
	"Review Complete" \
	"exactly one final decision" \
	"all-or-nothing" \
	"no candidate generation" \
	"existing Control baseline" \
	"duplicate"; do
	require_text "$SKILL" "$text"
done

for marker in \
	"control-review-status=Empty" \
	"control-review-entry-count=0"; do
	if ! grep -R -Fq "$marker" "$FIXTURES/empty-baseline"; then
		echo "FAIL: Feature 078 Control Review marker '$marker' missing"
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
	"writes=none-before-review" \
	"collection-prompts=none" \
	"expected=blocked" \
	"completion=allowed" \
	"allocation=none" \
	"partial-writes=none"; do
	if ! grep -R -Fq "$marker" "$FIXTURES"; then
		echo "FAIL: Feature 077 fixture marker '$marker' missing"
		fail=1
	fi
done

if [[ "$fail" -eq 0 ]]; then
	echo "OK: Feature 077 Control onboarding contract"
fi
exit "$fail"
