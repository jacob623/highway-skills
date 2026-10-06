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
	'Version change: 8.4.0 -> 8.4.1 (PATCH)' \
	'**Version**: 8.4.1 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-05' \
	'## Interaction Model' \
	'## Conversational Clarification' \
	'## Contribution Opportunity' \
	'## Constructive Advisory' \
	'## Evolution-Aware Guidance' \
	'## Recommendation Sets' \
	'## Interaction Boundaries' \
	'| X2.36 |' \
	'| X2.37 |' \
	'| X2.38 |' \
	'| X2.39 |' \
	'| X2.40 |' \
	'| X2.41 |'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done

if [[ "$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")" -ne 45 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 45 rules'
	fail=1
fi

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
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q . && [[ "$protected" != .highway/tools/tests/* ]]; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience Standard amendment passes'
