#!/usr/bin/env bash
# Verifies the shared Interactive Workflow UX Contract and in-scope skill alignment.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: governance-document, skill-document, disposable-fixture
# Seeded failure probe: duplicate and missing-reference fixtures must be rejected.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXPERIENCE_STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
SKILLS_ROOT="$HIGHWAY_ROOT/skills"
fail=0
# shellcheck source=tools/tests/test-helpers.sh
source "$SCRIPT_DIR/test-helpers.sh"

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

require_text "$EXPERIENCE_STANDARD" '### Interactive Workflow UX Contract'
contract_count="$(grep -c '^### Interactive Workflow UX Contract$' "$EXPERIENCE_STANDARD")"
if [[ "$contract_count" -ne 1 ]]; then
	echo "FAIL: expected exactly one Interactive Workflow UX Contract"
	fail=1
fi
require_text "$EXPERIENCE_STANDARD" 'single reusable interpretive and organizational guidance section'
require_text "$EXPERIENCE_STANDARD" 'X2.2-X2.6, N5 applicability'
require_text "$EXPERIENCE_STANDARD" 'Guided information-collection workflow'
require_text "$EXPERIENCE_STANDARD" 'Long-running activity'
require_text "$EXPERIENCE_STANDARD" 'Implementation details'
require_text "$EXPERIENCE_STANDARD" 'does not create additional X-rule obligations'
require_text "$EXPERIENCE_STANDARD" 'sole normative interaction authority'
require_text "$EXPERIENCE_STANDARD" 'As an application of X2.2'
require_text "$EXPERIENCE_STANDARD" 'As applications of X2.3 and X2.6'
require_text "$EXPERIENCE_STANDARD" 'As an application of X2.4'
require_text "$EXPERIENCE_STANDARD" 'this is an ownership convention, not a new X rule'
require_text "$EXPERIENCE_STANDARD" 'X2.2-X2.6'
require_text "$EXPERIENCE_STANDARD" '| X2.2 | An Interactive Workflow MUST prioritize the user'
require_text "$EXPERIENCE_STANDARD" '| X2.3 | An Interactive Workflow MUST NOT begin with implementation details'
require_text "$EXPERIENCE_STANDARD" '| X2.4 | A guided information-collection workflow MUST ask only the next required question'
require_text "$EXPERIENCE_STANDARD" '| X2.5 | A long-running activity MUST disclose current progress'
require_text "$EXPERIENCE_STANDARD" '| X2.6 | A progress message MUST describe activity rather than implementation'
require_text "$EXPERIENCE_STANDARD" '| X2.7 | An Interactive Workflow MUST ground recommendations in relevant Repository Context'
require_text "$EXPERIENCE_STANDARD" '| X2.8 | An Interactive Workflow MUST acknowledge information that produces a Material Influence'
require_text "$EXPERIENCE_STANDARD" '### Contextual Guidance'
require_text "$EXPERIENCE_STANDARD" 'does not promote, advertise, or restate unrelated Highway capabilities'
require_text "$EXPERIENCE_STANDARD" '| X1.6 | A structured user-facing field MUST visually distinguish its Presentation Label from its value.'
require_text "$EXPERIENCE_STANDARD" '| X2.9 | A guided information-collection workflow MUST provide Decision Context'
require_text "$EXPERIENCE_STANDARD" '| X2.10 | A guided information-collection workflow MUST provide a Relevant Example'
require_text "$EXPERIENCE_STANDARD" 'N7'
require_text "$EXPERIENCE_STANDARD" 'N8'
require_text "$EXPERIENCE_STANDARD" 'N9'
require_text "$EXPERIENCE_STANDARD" 'Constitution'
require_text "$EXPERIENCE_STANDARD" 'Presentation Labels affect presentation only'
require_text "$EXPERIENCE_STANDARD" 'Contextual Acknowledgments continue under X2.8'
require_text "$EXPERIENCE_STANDARD" 'User Exit'
require_text "$EXPERIENCE_STANDARD" 'Owner Outcome'
require_text "$EXPERIENCE_STANDARD" 'Persisted owner evidence'
require_text "$EXPERIENCE_STANDARD" 'Transient interaction state'
require_text "$EXPERIENCE_STANDARD" 'New interaction'
require_text "$EXPERIENCE_STANDARD" 'Not Applicable'
require_text "$EXPERIENCE_STANDARD" 'first incomplete applicable domain'
require_text "$EXPERIENCE_STANDARD" 'meaningful ordered work or long-running activity exists'
require_text "$EXPERIENCE_STANDARD" 'no meaningful ordered work or long-running activity exists'
require_text "$EXPERIENCE_STANDARD" '#### Illustrative Examples (Non-Normative)'
require_text "$EXPERIENCE_STANDARD" '| User Exit | `pause`, `cancel`, `stop responding` |'
require_text "$EXPERIENCE_STANDARD" '| Owner Outcome | `declined`, `aborted`, `blocked` |'
require_text "$EXPERIENCE_STANDARD" '| Resume Applicability | `Persisted owner evidence`, `Transient interaction state`, `New interaction`, `Not Applicable` |'
contract_line="$(grep -n '^### Interactive Workflow UX Contract$' "$EXPERIENCE_STANDARD" | cut -d: -f1)"
examples_line="$(grep -n '^#### Illustrative Examples (Non-Normative)$' "$EXPERIENCE_STANDARD" | cut -d: -f1)"
x4_line="$(grep -n '^### X4 —' "$EXPERIENCE_STANDARD" | cut -d: -f1)"
if [[ "$examples_line" -le "$contract_line" || "$examples_line" -ge "$x4_line" ]]; then
	echo 'FAIL: illustrative examples are not within or immediately beneath the contract section'
	fail=1
fi
for skill in highway-profile highway-objectives highway-controls highway-nfrs highway-new highway-discovery highway-adr highway-clarify; do
	file="$SKILLS_ROOT/$skill/SKILL.md"
	require_absent "$file" 'This contract is the single reusable interpretive and organizational guidance section'
done
duplicate_count="$(grep -RIl 'This contract is the single reusable interpretive and organizational guidance section' "$SKILLS_ROOT" "$HIGHWAY_ROOT/library" "$HIGHWAY_ROOT/catalog" 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$duplicate_count" -ne 0 ]]; then
	echo "FAIL: found $duplicate_count complete contract duplicate(s) outside the Experience Standard"
	fail=1
fi

skills='highway-profile highway-objectives highway-controls highway-nfrs highway-new highway-discovery highway-adr highway-clarify'
for skill in $skills; do
	file="$SKILLS_ROOT/$skill/SKILL.md"
	require_text "$file" 'Interactive Workflow UX Contract'
	require_text "$file" 'Next Action'
	require_text "$file" 'implementation details'
	require_text "$file" 'User Exits'
	require_text "$file" 'Owner Outcomes'
	require_text "$file" 'Resume Applicability'
	require_text "$file" 'ownership'
done

require_text "$SKILLS_ROOT/highway-profile/SKILL.md" 'Current Question'
require_text "$SKILLS_ROOT/highway-profile/SKILL.md" 'Completed Questions Count'
require_text "$SKILLS_ROOT/highway-profile/SKILL.md" 'Remaining Questions Count'
require_text "$SKILLS_ROOT/highway-profile/SKILL.md" 'Current Activity'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'objective statement'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'success measures'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'rationale approval'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Step 1 of 3'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Completed Categories'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Current Category'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Current Proposal'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Remaining Proposals'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Current Candidate'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Remaining Candidates'
require_text "$SKILLS_ROOT/highway-nfrs/SKILL.md" 'one candidate decision at a time'
require_text "$SKILLS_ROOT/highway-nfrs/SKILL.md" 'Candidate Position'
require_text "$SKILLS_ROOT/highway-new/SKILL.md" 'Current Domain'
require_text "$SKILLS_ROOT/highway-new/SKILL.md" 'Completed Domains'
require_text "$SKILLS_ROOT/highway-new/SKILL.md" 'Remaining Domains'
require_text "$SKILLS_ROOT/highway-new/SKILL.md" 'first incomplete evidence domain'
require_text "$SKILLS_ROOT/highway-discovery/SKILL.md" 'user-relevant analysis activity'
require_text "$SKILLS_ROOT/highway-adr/SKILL.md" 'user-relevant ADR activity'
require_text "$SKILLS_ROOT/highway-clarify/SKILL.md" 'one open finding question at a time'
require_text "$SKILLS_ROOT/highway-clarify/SKILL.md" 'Finding Position'
require_text "$SKILLS_ROOT/highway-clarify/SKILL.md" 'Remaining Findings'

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-ux.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
cp "$EXPERIENCE_STANDARD" "$fixture_root/standard.md"
printf '%s\n' '### Interactive Workflow UX Contract' >> "$fixture_root/standard.md"
if [[ "$(grep -c '^### Interactive Workflow UX Contract$' "$fixture_root/standard.md")" -eq 1 ]]; then
	echo "FAIL: duplicate contract probe was accepted"
	fail=1
fi

cp "$SKILLS_ROOT/highway-profile/SKILL.md" "$fixture_root/profile.md"
sed '/Interactive Workflow UX Contract/d' "$fixture_root/profile.md" > "$fixture_root/profile-missing.md"
if grep -Fq 'Interactive Workflow UX Contract' "$fixture_root/profile-missing.md"; then
	echo "FAIL: missing reference probe was accepted"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: highway UX alignment contract and skill checks'
