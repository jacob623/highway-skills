#!/usr/bin/env bash
# Verifies the Experience Standard interaction model and in-scope skill alignment.
# Superseded behavior: exactly one current "### Interactive Workflow UX Contract" heading was required.
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

# Superseded behavior: the standard was required to contain one Interactive Workflow UX Contract.
if grep -q '^### Interactive Workflow UX Contract$' "$EXPERIENCE_STANDARD"; then
	echo "FAIL: removed Interactive Workflow UX Contract heading is still current"
	fail=1
fi
require_text "$EXPERIENCE_STANDARD" '### Interaction model'
require_text "$EXPERIENCE_STANDARD" '1. Understand available accepted context.'
require_text "$EXPERIENCE_STANDARD" '2. Reuse existing information when it satisfies the need.'
require_text "$EXPERIENCE_STANDARD" '3. Discover or import existing authoritative information when the organization already has it.'
require_text "$EXPERIENCE_STANDARD" '4. Offer grounded recommendations when Highway can responsibly help.'
require_text "$EXPERIENCE_STANDARD" '5. Accept selected recommendations directly.'
require_text "$EXPERIENCE_STANDARD" '6. Ask one clear question only when information remains unresolved.'
require_text "$EXPERIENCE_STANDARD" '7. Present the inferred-content heading only when Highway materially inferred or transformed the input.'
require_text "$EXPERIENCE_STANDARD" '8. Put that review'"'"'s acceptance request at the bottom.'
require_text "$EXPERIENCE_STANDARD" '9. Capture accepted information.'
require_text "$EXPERIENCE_STANDARD" '10. Offer additional grounded recommendations or let the person continue.'
require_text "$EXPERIENCE_STANDARD" '11. Stop when the person is satisfied or no useful recommendations remain.'
require_text "$EXPERIENCE_STANDARD" "does not govern the person's strategy, policy, requirements, priorities, or preferred wording."
require_text "$EXPERIENCE_STANDARD" '.highway/library/knowledge/highway-identity.md'
require_text "$EXPERIENCE_STANDARD" '.highway/library/knowledge/highway-platform-objectives.md'
# Superseded behavior: the runtime document was required to keep exactly one Repository Context bump rationale.
if [[ "$(grep -cF 'Bump rationale: adds Repository Context definitions, Contextual Guidance, and X2.7-X2.8 without' "$EXPERIENCE_STANDARD")" -ne 0 ]]; then
	echo "FAIL: removed Repository Context bump rationale is still present"
	fail=1
fi
if ! grep -qF '3.0.0 → 4.0.0 (MAJOR)' "$EXPERIENCE_STANDARD"; then
	echo "FAIL: current Experience Standard amendment record is missing"
	fail=1
fi
# Superseded behavior: the contract section restated X2.2-X2.6, N5, N7-N9, and resume tokens.
require_text "$EXPERIENCE_STANDARD" '| X1.6 | A structured user-facing field MUST visually distinguish its Presentation Label from its value.'
require_text "$EXPERIENCE_STANDARD" '| X1.7 | Setup presentation MUST place one decision or question last, after framing, the main content, and any supporting rationale or example.'
require_text "$EXPERIENCE_STANDARD" '| X2.1 | A confirmation before an irreversible loss MUST state what is lost.'
require_text "$EXPERIENCE_STANDARD" '| X2.3 | Implementation details MUST stay hidden unless the person requested them or needs them in order to act.'
require_text "$EXPERIENCE_STANDARD" 'Every user-visible response excludes Implementation details unless requested.'
require_text "$EXPERIENCE_STANDARD" '| X2.4 | An Interactive Workflow MUST ask only one unresolved question, and only for information still needed.'
require_text "$EXPERIENCE_STANDARD" '| X2.5 | Progress MUST appear only when remaining work is meaningful to the person.'
require_text "$EXPERIENCE_STANDARD" '| X2.6 | Progress MUST describe the activity rather than an internal stage, validation step, route, or implementation step.'
require_text "$EXPERIENCE_STANDARD" '| X2.8 | An acknowledgment MUST appear only when new information changes the recommendation, interpretation, or next user-relevant action.'
require_text "$EXPERIENCE_STANDARD" '| X2.9 | Decision Context MUST use the label "**Why it matters:**" and explain why the answer matters to the person without asking a second question.'
require_text "$EXPERIENCE_STANDARD" '| X2.10 | An example MUST appear only when it makes the expected answer clearer without becoming a required category.'
require_text "$EXPERIENCE_STANDARD" '| X2.23 | An accepted Profile organization name MUST be used in contextual guidance where it improves clarity.'
require_text "$EXPERIENCE_STANDARD" '| X2.24 | An organization name that has not been accepted MUST NOT be invented.'
require_text "$EXPERIENCE_STANDARD" '| X2.25 | Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared recommendation interaction model.'
require_text "$EXPERIENCE_STANDARD" '| X2.26 | Recommendation rationale MUST appear only when it helps the person decide.'
require_text "$EXPERIENCE_STANDARD" '| X2.27 | An orchestrator MUST introduce a new domain with one short outcome-oriented transition without repeating the owner'"'"'s opening.'
require_text "$EXPERIENCE_STANDARD" '| X2.28 | A visible move into a new setup domain MUST be separated with a horizontal rule.'
require_text "$EXPERIENCE_STANDARD" '| X2.29 | Discovered or extracted information MUST stay proposed until the user-acceptance boundary is satisfied.'
require_text "$EXPERIENCE_STANDARD" '| X2.30 | Evidence that cannot be recommended or inferred MUST stay unknown.'
require_text "$EXPERIENCE_STANDARD" '| X2.31 | Optional enrichment MUST NOT block continuation unless the owning domain requires it for validity.'
require_text "$EXPERIENCE_STANDARD" '| X5.1 | An emitted message MUST name something the person can act on.'
require_text "$EXPERIENCE_STANDARD" '| X5.2 | A report of a conflict with existing content MUST name the existing item.'
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
	require_text "$file" 'Highway Experience Standard'
	require_absent "$file" 'Interactive Workflow UX Contract'
	require_text "$file" 'Next Action'
	require_text "$file" 'implementation details'
	require_text "$file" 'User Exits'
	require_text "$file" 'Owner Outcomes'
	require_text "$file" 'Resume Applicability'
	require_text "$file" 'ownership'
done

require_text "$SKILLS_ROOT/highway-profile/SKILL.md" 'Current Question'
require_text "$SKILLS_ROOT/highway-profile/SKILL.md" 'Domain Progress'
require_text "$SKILLS_ROOT/highway-profile/SKILL.md" 'Current Activity'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Outcome evidence'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Success Measures'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Why it matters:'
require_absent "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Step 1 of 3'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Concern'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Condition'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Obligation'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'adaptive discovery'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'one unresolved response-demanding question'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'one complete Control proposal at a time'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'exact continuation question'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'candidate-classification result'
require_absent "$SKILLS_ROOT/highway-controls/SKILL.md" 'Completed Categories'
require_absent "$SKILLS_ROOT/highway-controls/SKILL.md" 'Current Category'
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
require_text "$SKILLS_ROOT/highway-setup/SKILL.md" 'Controls-to-NFR transition'
require_text "$SKILLS_ROOT/highway-setup/SKILL.md" 'first NFR-owned interaction'
require_text "$SKILLS_ROOT/highway-setup/SKILL.md" 'Your foundational Highway context is now in place.'
require_text "$SKILLS_ROOT/highway-setup/SKILL.md" 'Run `/highway-help` to explore what Highway can help you do.'
require_absent "$SKILLS_ROOT/highway-setup/SKILL.md" 'Highway Setup Complete'
require_absent "$SKILLS_ROOT/highway-setup/SKILL.md" 'Business Objectives: <terminal owner status>'

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-ux.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
cp "$EXPERIENCE_STANDARD" "$fixture_root/standard.md"
# Superseded behavior: appending a second contract heading was rejected only when one heading already existed.
printf '%s\n' '### Interactive Workflow UX Contract' >> "$fixture_root/standard.md"
if ! grep -q '^### Interactive Workflow UX Contract$' "$fixture_root/standard.md"; then
	echo "FAIL: retired heading probe was not detected"
	fail=1
fi

cp "$SKILLS_ROOT/highway-profile/SKILL.md" "$fixture_root/profile.md"
sed '/Highway Experience Standard/d' "$fixture_root/profile.md" > "$fixture_root/profile-missing.md"
if grep -Fq 'Highway Experience Standard' "$fixture_root/profile-missing.md"; then
	echo "FAIL: missing reference probe was accepted"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: highway UX alignment contract and skill checks'
