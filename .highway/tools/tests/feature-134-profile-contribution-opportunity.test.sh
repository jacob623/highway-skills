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
require_text 'materially shapes'
require_text 'equivalent opportunity'
require_text 'apply the shared Contribution Opportunity behavior when required by the Highway Experience Standard'
require_text 'remains transient'
require_text 'Vision, Competitive Path, and Guiding Principles'
# Superseded behavior: feature 134 locked generic Contribution Opportunity lifecycle sentences.
# Feature 138 keeps the Profile-specific exception and does not restate that shared lifecycle (D3.5).
# Superseded behavior: a complete discovered Identity skipped a distinct Contribution Opportunity.
require_text 'A person-supplied domain-complete contribution that Profile does not materially reshape may proceed through the shared direct or mature-contribution path'
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

# Superseded behavior: feature 134 treated profile-record.md as unchanged. Feature 138 owns that template (D3.5).
for protected in \
	.highway/governance/constitution.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/skills/highway-objectives/SKILL.md \
	.highway/skills/highway-controls/SKILL.md \
	.highway/skills/highway-nfrs/SKILL.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q . && ! grep -qF 'Version change: 6.1.0' "$HIGHWAY_ROOT/governance/constitution.md"; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 134 Profile Contribution Opportunity contract passes'
