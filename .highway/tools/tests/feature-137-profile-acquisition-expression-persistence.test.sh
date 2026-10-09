#!/usr/bin/env bash
# Verifies Feature 137 Profile acquisition, expression, persistence, and ownership boundaries.
# Superseded behavior: a prior draft locked skill version 5.4.0, website-only acquisition,
# enrichment-category coverage, and acceptance-as-persistence. The accepted amendment is MAJOR
# 6.0.0 and narrows those guarantees. Feature 138 further replaces the projection and persistence sentences (D3.5).
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
		echo "FAIL: Profile skill contains forbidden '$text'"
		fail=1
	fi
}

if ! grep -Eq '^# highway-profile$' "$PROFILE"; then
	echo "FAIL: Profile skill title is not the top-level heading highway-profile"
	fail=1
fi
if grep -Eq '^## highway-profile$' "$PROFILE"; then
	echo "FAIL: Profile skill still uses the second-level highway-profile heading"
	fail=1
fi

for required in \
	'version: 11.1.0' \
	'User requests, proposal evidence, supplied organizational material' \
	'public organizational' \
	'Profile Context' \
	'facts derived from' \
	'Evaluate each source across all unresolved Profile domains' \
	'Do you already have something I can' \
	'Canonical questions are Profile-owned fallbacks' \
	'Expression guides representation, not truth' \
	'Expression guidance is transient' \
	'Profile-owned expression guidance does not control' \
	'Acquisition is limited to Profile evidence' \
	'Identity establishes who the organization is' \
	'A domain is complete when accumulated evidence supports one cohesive organizational narrative' \
	'Competitive Path describes the broad organizational approach' \
	'Controls, NFRs, safeguards, architecture, implementation requirements, or plans' \
	'turn a principle into an enforceable Control' \
	'Acceptance authorizes the mutation but is not successful persistence' \
	'Retain only the accepted cohesive domain narrative' \
	'Content mutations do not change the retained Profile schema version.'; do
	require_text "$required"
done

for forbidden in \
	'version: 5.3.0' \
	'version: 5.4.0' \
	'use supported existing-information or website acquisition when available' \
	'ask for the public website using the accepted Repository Name' \
	'Future State, Impact' \
	'Customer / Participant, Offering, Market / Reach' \
	'People, Trust' \
	'category names are neither presented nor retained' \
	'accepted website-derived organizational evidence' \
	'Competitive Path begins from accepted Vision or sufficient accepted evidence' \
	'sharpen principles already implicit' \
	'A complete discovered Identity follows its accuracy-oriented validation path' \
	'- Identity validation:' \
	'Accepted evidence is persisted before dependent readiness or owner results' \
	'When Profile materially assembles or interprets Identity from website discovery or multiple evidence sources'; do
	require_absent "$forbidden"
done

for forbidden in \
	'## Clarifications' \
	'persisted tone field' \
	'persisted voice field' \
	'persisted source-precedence field'; do
	require_absent "$forbidden"
done

for generated in \
	.agents/skills/highway-profile/SKILL.md \
	.claude/skills/highway-profile/SKILL.md \
	.github/skills/highway-profile/SKILL.md \
	.cursor/skills/highway-profile/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$generated" ]] || ! cmp -s "$PROFILE" "$REPO_ROOT/$generated"; then
		echo "FAIL: generated Profile adapter is stale: $generated"
		fail=1
	fi
done

# Superseded behavior: feature 137 treated profile-record.md as unchanged. Feature 138 owns that template (D3.5).
for protected in \
	.highway/governance/constitution.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/skills/highway-objectives/SKILL.md \
	.highway/skills/highway-clarify/SKILL.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q . && ! grep -qF 'Version change: 6.1.0' "$HIGHWAY_ROOT/governance/constitution.md"; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 137 Profile acquisition, expression, persistence, and ownership contract passes'
