#!/usr/bin/env bash
# Verifies independent NFR onboarding and readiness contracts.
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
	"## Response Support Text" \
	"## Recommendation Development" \
	"### Control-Informed Recommendations" \
	"## NFR Coverage Areas" \
	"## Recommendation Generation" \
	"## Coverage Evaluation" \
	"## Recommendation Presentation" \
	"## Recommendation Exploration" \
	"## Additional Suggestions" \
	"## Recommendation Boundaries" \
	"## NFR Development Lifecycle" \
	"## NFR Queue And Acceptance Boundaries" \
	"## Interpretation Confidence" \
	"## NFR Contribution Guidance" \
	"## NFR Portfolio Assessment Guidance" \
	"Accepted Controls may strongly influence NFR recommendations." \
	"Controls do not create NFRs" \
	"Controls do not transfer ownership" \
	"Controls do not create candidate state" \
	"Every accepted Control should be evaluated as a potential source of NFR recommendations." \
	"Controls participate in recommendation generation." \
	"Control influence is recommendation-oriented, not lifecycle-oriented." \
	"Control" \
	"Automatic NFR" \
	"Selecting recommendations does not begin review." \
	"Selection alone does not begin proposal development." \
	"The queue may continue growing while recommendation exploration remains active." \
	"Review of selected NFRs begins only when:" \
	"Recommendation exhaustion occurs when:" \
	"Recommendations currently under evaluation are not queue members." \
	"Queued recommendations are recommendations the person has selected." \
	"Only queued recommendations are eligible for queue processing." \
	"Queue processing has not started." \
	"unreviewed Working Ideas until review begins." \
	"Recommendation selection continues queue construction." \
	"Review of selected NFRs" \
	"Collection Result: Continue does not require" \
	"review to have started." \
	"#### Illustrative Recommendation Presentation Example" \
	"#### Illustrative Recommendation Exploration Example" \
	"#### Illustrative Queue Interaction" \
	"**What would you add, correct, or remove?**" \
	"If this is accurate, just say so." \
	"If you're not sure, just say \"I don't know,\" and we'll work through it together." \
	"If none of these fit, feel free to suggest your own operational expectation." \
	"If you'd like additional suggestions, just let me know." \
	"Once queue processing begins, recommendation exploration is closed." \
	"Queue membership does not allocate identifiers." \
	"Queue membership does not mutate records." \
	"independently managed NFRs" \
	"Are there any qualities or operational expectations you'd like future solutions to meet?" \
	"Collection Result: Continue|Finished" \
	"Action Status: Succeeded|Declined|Aborted|Blocked" \
	"does not include a created-NFR-ID list" \
	"Why it matters" \
	"NFR Coverage Areas" \
	"NFR queue" \
	"Queue membership is not NFR capture" \
	"Converged NFR proposal" \
	"explicitly accepted" \
	"explicit review requests" \
	"Portfolio assessment is advisory" \
	"Control context remains recommendation context" \
	"controls: []" \
	"Missing" \
	"Blocked"; do
	require_text "$SKILL" "$text"
done
for text in \
	"Readiness is independent of Control collection" \
	"without requiring Control-originated state" \
	"Collection Result: Finished"; do
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
