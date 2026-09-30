#!/usr/bin/env bash
# Verifies Feature 094 adaptive Control collection and review contracts.
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
	"evidence" \
	"Concern" \
	"Condition" \
	"Obligation" \
	"Action Status: Succeeded|Declined|Aborted|Blocked" \
	"Collection Result: Continue|Finished" \
	"Declined" \
	"Aborted" \
	"perform no Control write" \
	"Controls Readiness Result" \
	"Status: Empty" \
	"Status: Empty" \
	"Next Action:" \
	"Title" \
	"Statement" \
	"Why it matters" \
	"Would you like to accept this Control?" \
	"Selected recommendations are captured directly" \
	"immediately" \
	"authoritative baseline" \
	"duplicate" \
	"one Add MINOR" \
	"revalidate" \
	"user-override" \
	"Reuse writes no record" \
	"deterministic initial" \
	"candidate derivation" \
	"NFR owner" \
	"## Provenance" \
	"Ask for missing information, not missing phrasing"; do
	require_text "$SKILL" "$text"
done

if grep -Eq 'Process these categories in order|Security; Availability and Resilience|Completed Categories|Current Category' "$SKILL"; then
	echo "FAIL: legacy category-driven onboarding remains in the Controls setup path"
	fail=1
fi

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
