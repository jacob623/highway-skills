#!/usr/bin/env bash
# Verifies the compact Experience Standard and in-scope skill alignment.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: governance-document, skill-document, disposable-fixture
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXPERIENCE_STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
SKILLS_ROOT="$HIGHWAY_ROOT/skills"
fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

require_absent() {
	local file="$1" text="$2"
	if grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' unexpectedly present in $file"
		fail=1
	fi
}

for token in \
	'## Interaction Model' \
	'## Runtime Authority' \
	'## Conversational Clarification' \
	'## Contribution Opportunity' \
	'## Constructive Advisory' \
	'## Interaction Boundaries' \
	'## Recommendation Sets' \
	'### X5 - Addressability of Emitted Messages' \
	'Incorporates clear input directly' \
	"Let the person's response reshape the Working Idea" \
	'non-authoritative until' \
	'Present a Converged Proposal only after owner completeness, conversational convergence, and a' \
	'Working Idea development'; do
	require_text "$EXPERIENCE_STANDARD" "$token"
done

# Superseded behavior: 33 rules, before Feature 150 added X2.42-X2.57.
# Superseded behavior: Interaction Model step 9 converged on owner completeness and conversational
# convergence alone; Feature 150 adds a Substantive Contribution from the person as a third condition.
if [[ "$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$EXPERIENCE_STANDARD")" -ne 59 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 49 rules'
	fail=1
fi
for old_section in \
	'### Interactive Workflow UX Contract' \
	'#### Collaborative Development (Non-Normative Guidance)' \
	'#### Contextual Re-evaluation (Non-Normative Guidance)' \
	'#### Conversational Voice (Non-Normative Guidance)' \
	'#### Conversational Presence (Non-Normative Guidance)' \
	'## Candidates'; do
	require_absent "$EXPERIENCE_STANDARD" "$old_section"
done

skills='highway-profile highway-objectives highway-controls highway-nfrs highway-new highway-discovery highway-adr highway-clarify'
for skill in $skills; do
	file="$SKILLS_ROOT/$skill/SKILL.md"
	require_text "$file" 'Highway Experience Standard'
	require_absent "$file" 'Interactive Workflow UX Contract'
	require_text "$file" 'ownership'
done

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-ux.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
cp "$EXPERIENCE_STANDARD" "$fixture_root/standard.md"
printf '%s\n' '### Interactive Workflow UX Contract' >> "$fixture_root/standard.md"
if ! grep -q '^### Interactive Workflow UX Contract$' "$fixture_root/standard.md"; then
	echo 'FAIL: retired heading probe was not detected'
	fail=1
fi

cp "$SKILLS_ROOT/highway-profile/SKILL.md" "$fixture_root/profile.md"
sed '/Highway Experience Standard/d' "$fixture_root/profile.md" > "$fixture_root/profile-missing.md"
if grep -Fq 'Highway Experience Standard' "$fixture_root/profile-missing.md"; then
	echo 'FAIL: missing reference probe was accepted'
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo 'PASS: highway UX alignment contract and skill checks'
