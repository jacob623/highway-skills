#!/usr/bin/env bash
# Verifies the compact Feature 141 Experience Standard amendment and protected paths.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

for token in \
	'**Layer 2 - Experience.** Version `11.0.0`.' \
	'**Version**: `11.0.0` | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-08' \
	'## Interaction Model' \
	'## Conversational Clarification' \
	'## Contribution Opportunity' \
	'## Constructive Advisory' \
	'## Recommendation Sets' \
	'## Interaction Boundaries' \
	'| X2.36 |' \
	'| X2.37 |' \
	'| X2.38 |' \
	'| X2.41 |'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done

# Superseded behavior: 33 rules at version 9.1.0, before Feature 150 added X2.42-X2.57.
if [[ "$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")" -ne 59 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 49 rules'
	fail=1
fi

for retired in X2.8 X2.14 X2.23 X2.25 X2.26 X2.39 X2.40; do
	if grep -qF "| $retired |" "$STANDARD"; then
		echo "FAIL: retired rule remains active: $retired"
		fail=1
	fi
done

for forbidden in 'Highway Skills Constitution' 'P namespace' '## Tier Definitions' '[auto]' '[agent-checkable]' '[human-review]' '## Versioning Policy' '## Self-Application'; do
	if grep -qF "$forbidden" "$STANDARD"; then
		echo "FAIL: runtime governance metadata remains: $forbidden"
		fail=1
	fi
done

for forbidden in \
	'Historical amendment record' \
	'## Candidates' \
	'#### Collaborative Development (Non-Normative Guidance)' \
	'#### Contextual Re-evaluation (Non-Normative Guidance)' \
	'#### Conversational Voice (Non-Normative Guidance)' \
	'#### Conversational Presence (Non-Normative Guidance)'; do
	if grep -Fq "$forbidden" "$STANDARD"; then
		echo "FAIL: removed runtime material remains: $forbidden"
		fail=1
	fi
done

for protected in \
	.highway/skills/highway-objectives/SKILL.md \
	.highway/skills/highway-controls/SKILL.md \
	.highway/skills/highway-nfrs/SKILL.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/tools/tests/experience-standard-amendment.test.sh \
	.highway/tools/tests/experience-standard-convergence.test.sh \
	.highway/governance/constitution.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q . && [[ "$protected" != .highway/tools/tests/* ]] && ! grep -qF 'Version change: 6.1.0' "$HIGHWAY_ROOT/governance/constitution.md"; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience Standard amendment passes'
