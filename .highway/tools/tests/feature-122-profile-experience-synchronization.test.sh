#!/usr/bin/env bash
# Verifies Feature 122 Profile conversational synchronization.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/profile-record.md"
fail=0

require_text() {
	local text="$1"
	if ! grep -Fq -- "$text" "$PROFILE"; then
		echo "FAIL: Profile skill missing '$text'"
		fail=1
	fi
}

require_absent() {
	local text="$1"
	if grep -Fq -- "$text" "$PROFILE"; then
		echo "FAIL: superseded Profile wording remains '$text'"
		fail=1
	fi
}

require_text 'Profile does not add a local acknowledgment stage, narrate'
require_text 'Interpretation, explanation, reflection, connections,'
require_text 'advisory commentary remain transient'
require_text 'Vision uses accepted Identity, accepted website-derived organizational evidence, existing accepted Vision evidence, and other accepted Profile context as grounding.'
require_text 'Competitive Path begins from accepted Vision or sufficient accepted evidence.'
require_text 'Guiding Principles uses accepted Identity, Vision, Competitive Path, and other accepted Profile context as grounding.'
require_text 'naturally connect the accepted Profile understanding to how it can inform later Highway guidance.'
require_text 'Material interpretation follows the Highway Experience Standard.'
require_text 'The validation question remains the single response-demanding decision in the recommendation turn.'
require_text 'One cohesive organizational narrative that meaningfully answers the domain'
require_text 'Profile does not impose a local brevity requirement that conflicts with shared Conversational Presence guidance.'
require_absent 'Profile does not require fixed recommendation sentence templates.'
require_absent 'X2.36'

for old_text in \
	'Acknowledge and Build are optional conversational context' \
	'when it adds decision value' \
	'contextualize the recommendation with accepted Identity or newly accepted direction when useful' \
	'contextualize the recommendation with accepted Vision when useful' \
	'contextualize the recommendation with the evolving Profile when useful' \
	'Synthesized Vision, Competitive Path, and Guiding Principles turns may contextualize the recommendation with an acknowledgment.' \
	'Advisory commentary is omitted when it would add no decision value.'; do
	require_absent "$old_text"
done

if [[ "$(grep -c '^## Enrichment$' "$PROFILE")" -ne 1 ]]; then
	echo 'FAIL: Profile skill must contain exactly one Enrichment section'
	fail=1
fi
if grep -Eq 'sentence count|paragraph count|minimum-response|smallest possible recommendation' "$PROFILE"; then
	echo 'FAIL: Profile skill contains a local conversational brevity constraint'
	fail=1
fi

for token in \
	'schema_version: 3.0.0' \
	'identity: not_discussed' \
	'vision: not_discussed' \
	'competitive_path: not_discussed' \
	'guiding_principles: not_discussed'; do
	grep -Fq "$token" "$TEMPLATE" || { echo "FAIL: Profile template missing preserved token '$token'"; fail=1; }
done

for protected in \
	.highway/skills/highway-objectives/SKILL.md \
	.highway/skills/highway-controls/SKILL.md \
	.highway/skills/highway-nfrs/SKILL.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/library/templates/output/profile-record.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q .; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 122 Profile synchronization contract passes'
