#!/usr/bin/env bash
# Verifies Feature 134 Profile Contribution Opportunity behavior.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
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
		echo "FAIL: protected or superseded wording remains '$text'"
		fail=1
	fi
}

require_text 'Contribution Opportunity'
require_text 'X2.37'
require_text 'materially shaped'
require_text 'equivalent opportunity'
require_text 'add, correct, remove, extend, or redirect'
require_text 'nothing else'
require_text 'remains transient'
require_text 'does not authorize persistence'
require_text 'does not repeat substantially identical cohesive final-form domain prose'
require_text 'Vision, Competitive Path, and Guiding Principles'
# Superseded behavior: a complete discovered Identity skipped a distinct Contribution Opportunity.
require_text 'A user-supplied domain-complete Identity that Profile does not materially reshape may proceed directly to its accuracy-oriented validation path'
require_text 'the only response-demanding question'
require_text 'Identity accuracy'
require_text 'The Contribution Opportunity is the only response-demanding question in its turn and remains separate from domain acceptance and other unresolved discovery questions.'
require_text '### Where you'
require_text '### How you'
require_text '### What will guide'

if [[ "$(grep -c '^## Enrichment$' "$PROFILE")" -ne 1 ]]; then
	echo 'FAIL: Profile skill must contain exactly one Enrichment section'
	fail=1
fi
if grep -Fq 'Contribution Opportunity authorizes acceptance' "$PROFILE"; then
	echo 'FAIL: Contribution Opportunity is coupled to acceptance'
	fail=1
fi

for protected in \
	.highway/governance/constitution.md \
	.highway/library/templates/output/profile-record.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/skills/highway-objectives/SKILL.md \
	.highway/skills/highway-controls/SKILL.md \
	.highway/skills/highway-nfrs/SKILL.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q .; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 134 Profile Contribution Opportunity contract passes'
