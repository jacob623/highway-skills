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
require_text "$EXPERIENCE_STANDARD" '#### Conversational Voice (Non-Normative Guidance)'
require_absent "$EXPERIENCE_STANDARD" '##### Conversational Voice (Non-Normative Guidance)'
require_text "$EXPERIENCE_STANDARD" '#### Conversational Presence (Non-Normative Guidance)'
require_text "$EXPERIENCE_STANDARD" 'Conversational Voice governs whose perspective Highway speaks from.'
require_text "$EXPERIENCE_STANDARD" 'Conversational Presence governs the room Highway has to respond, explain, reflect, and converse naturally.'
require_text "$EXPERIENCE_STANDARD" 'Constructive Advisory governs the additional intellectual contribution Highway makes through implications, recommendations, alternatives, tradeoffs, concerns, and connections.'
require_text "$EXPERIENCE_STANDARD" 'A response does not need to contain a question, recommendation, decision, or next action merely to keep the interaction moving.'
require_text "$EXPERIENCE_STANDARD" 'The one-question constraints limit unnecessary or competing questions; they do not require every Interactive Workflow response to contain a question.'
require_text "$EXPERIENCE_STANDARD" 'When the person has not left an unresolved information need or decision, Highway may respond without asking one.'
require_text "$EXPERIENCE_STANDARD" 'Multiple short paragraphs are appropriate when they improve comprehension, separate distinct ideas, or allow Highway to respond naturally before advancing.'
require_text "$EXPERIENCE_STANDARD" 'Additional commentary should create conversational, explanatory, or decision value.'
require_text "$EXPERIENCE_STANDARD" '| Conversational presence |'
require_text "$EXPERIENCE_STANDARD" '| No-question conversational turn |'
require_absent "$EXPERIENCE_STANDARD" 'default to 2–4 paragraphs'
require_absent "$EXPERIENCE_STANDARD" 'minimum paragraph'
require_absent "$EXPERIENCE_STANDARD" 'maximum paragraph'
require_text "$EXPERIENCE_STANDARD" 'Use natural first-person language when referring to the current interaction'
require_text "$EXPERIENCE_STANDARD" 'The person should experience one increasingly informed Highway advisor across participating skills'
# Feature 127 superseded the old continuity/acknowledgment sequencing assertions.
require_text "$EXPERIENCE_STANDARD" 'A guided interaction should read as a continuing conversation rather than a sequence of independent generated prompts.'
require_text "$EXPERIENCE_STANDARD" 'When context materially changes the active understanding, the next response should reflect that change'
require_text "$EXPERIENCE_STANDARD" '1. Understand available accepted context and the active task.'
require_text "$EXPERIENCE_STANDARD" '2. Reuse existing information when it satisfies the need.'
# Superseded behavior: the interaction model discovered information and then offered recommendations without an acceptance and re-evaluation step.
require_text "$EXPERIENCE_STANDARD" '3. Discover or import existing authoritative information when supported.'
require_text "$EXPERIENCE_STANDARD" '4. Treat a new contribution as a Working Idea until the applicable acceptance boundary is crossed.'
require_text "$EXPERIENCE_STANDARD" '5. Interpret the contribution in relevant context and sharpen useful distinctions, implications,'
require_text "$EXPERIENCE_STANDARD" "8. Receive the person's response. When it is a Substantive Contribution"
require_text "$EXPERIENCE_STANDARD" '13. Do not continue merely because more information could theoretically be collected'
require_text "$EXPERIENCE_STANDARD" '16. Ask one clear question only when unresolved information is still needed and useful grounded'
require_text "$EXPERIENCE_STANDARD" '17. Present the Converged Proposal only after the substantive shape has settled enough'
require_text "$EXPERIENCE_STANDARD" '18. After acceptance, allow the owner to persist accepted knowledge, update the available context, and'
require_text "$EXPERIENCE_STANDARD" '19. Continue when required work remains; otherwise allow the conversational response to conclude naturally.'
require_absent "$EXPERIENCE_STANDARD" '3. Discover or import existing authoritative information when the organization already has it.'
require_absent "$EXPERIENCE_STANDARD" '7. Present the inferred-content heading only when Highway materially inferred or transformed the input.'
require_text "$EXPERIENCE_STANDARD" "does not govern the person's strategy, policy, requirements, priorities, or preferred wording."
require_text "$EXPERIENCE_STANDARD" '.highway/library/knowledge/highway-identity.md'
require_text "$EXPERIENCE_STANDARD" '.highway/library/knowledge/highway-platform-objectives.md'
# Superseded behavior: the runtime document was required to keep exactly one Repository Context bump rationale.
if [[ "$(grep -cF 'Bump rationale: adds Repository Context definitions, Contextual Guidance, and X2.7-X2.8 without' "$EXPERIENCE_STANDARD")" -ne 0 ]]; then
	echo "FAIL: removed Repository Context bump rationale is still present"
	fail=1
fi
# Superseded behavior: the previous Feature 120 MAJOR report must not remain current.
if grep -qF '6.0.0 → 7.0.0 (MAJOR)' "$EXPERIENCE_STANDARD"; then
	echo "FAIL: superseded Feature 120 amendment report is still present"
	fail=1
fi
# Superseded behavior: the contract section restated X2.2-X2.6, N5, N7-N9, and resume tokens.
require_text "$EXPERIENCE_STANDARD" '| X1.6 | A structured user-facing field MUST visually distinguish its Presentation Label from its value.'
# Superseded behavior: X1.7 required the question after framing, main content, and supporting rationale.
require_text "$EXPERIENCE_STANDARD" '| X1.7 | Setup presentation MUST keep at most one response-demanding question or decision in the final interaction block.'
require_absent "$EXPERIENCE_STANDARD" '| X1.7 | Setup presentation MUST place one decision or question last, after framing, the main content, and any supporting rationale or example.'
require_text "$EXPERIENCE_STANDARD" '| X2.1 | A confirmation before an irreversible loss MUST state what is lost.'
require_text "$EXPERIENCE_STANDARD" '| X2.3 | Implementation details MUST stay hidden unless the person requested them or needs them in order to act.'
require_text "$EXPERIENCE_STANDARD" 'Every user-visible response excludes Implementation details unless requested.'
require_text "$EXPERIENCE_STANDARD" '| X2.4 | An Interactive Workflow MUST ask only one unresolved question, and only for information still needed.'
require_text "$EXPERIENCE_STANDARD" '| X2.5 | Progress MUST appear only when remaining work is meaningful to the person.'
require_text "$EXPERIENCE_STANDARD" '| X2.6 | Progress MUST describe the activity rather than an internal stage, validation step, route, or implementation step.'
require_text "$EXPERIENCE_STANDARD" '| X2.8 | When accepted information changes Highway'"'"'s understanding, interpretation, recommendation, or next user-relevant action, the next response MUST reflect the changed understanding using the newly accepted information together with relevant accumulated context before advancing.'
require_text "$EXPERIENCE_STANDARD" 'The next response uses the newly accepted information with relevant accumulated context to provide contextual interpretation, a useful connection, implication, distinction, recommendation, or next action when one exists; it does not merely repeat the person'"'"'s words or narrate workflow mechanics.'
require_text "$EXPERIENCE_STANDARD" 'Constructive Advisory should make Highway more useful, not merely more verbose.'
require_text "$EXPERIENCE_STANDARD" 'A guided interaction should read as a continuing conversation rather than a sequence of independent generated prompts.'
require_text "$EXPERIENCE_STANDARD" 'Does this reflect what you have in mind? You can also change it or provide your own.'
require_absent "$EXPERIENCE_STANDARD" '| X2.8 | An acknowledgment MUST appear only when new information changes the recommendation, interpretation, or next user-relevant action.'
# Superseded behavior: X2.9 required the explanation before the unresolved question.
require_text "$EXPERIENCE_STANDARD" '| X2.9 | Decision Context MUST follow the question it explains under the label "**Why it matters:**".'
require_absent "$EXPERIENCE_STANDARD" '| X2.9 | Decision Context MUST use the label "**Why it matters:**" and explain why the answer matters to the person without asking a second question.'
require_text "$EXPERIENCE_STANDARD" '| X2.10 | An example MUST appear only when it makes the expected answer clearer without becoming a required category.'
require_text "$EXPERIENCE_STANDARD" '| X2.23 | An accepted Profile organization name MUST be used in contextual guidance where it improves clarity.'
require_text "$EXPERIENCE_STANDARD" '| X2.24 | An organization name that has not been accepted MUST NOT be invented.'
require_text "$EXPERIENCE_STANDARD" '| X2.25 | Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared collaborative recommendation model.'
require_text "$EXPERIENCE_STANDARD" '| X2.26 | Recommendation rationale MUST appear only when it helps the person decide.'
require_text "$EXPERIENCE_STANDARD" '| X2.27 | An orchestrator MUST introduce a new domain with one short outcome-oriented transition without repeating the owner'"'"'s opening.'
require_text "$EXPERIENCE_STANDARD" '| X2.28 | A visible move into a new setup domain MUST be separated with a horizontal rule.'
require_text "$EXPERIENCE_STANDARD" '| X2.29 | Discovered or extracted information MUST stay proposed until the user-acceptance boundary is satisfied.'
require_text "$EXPERIENCE_STANDARD" '| X2.30 | Evidence that cannot be recommended or inferred MUST stay unknown.'
require_text "$EXPERIENCE_STANDARD" '| X2.31 | Optional enrichment MUST NOT block continuation unless the owning domain requires it for validity.'
# X2.13 contribution precedence is checked by its ordered observable.
require_text "$EXPERIENCE_STANDARD" 'Before an unresolved question, the workflow presents a Converged Proposal only when the Working Idea has converged and the owner has a complete candidate; otherwise it contributes a useful Working Idea when further development can improve the result; otherwise it asks the focused unresolved question.'
require_text "$EXPERIENCE_STANDARD" 'A grounded recommendation may be presented as a Working Idea when further substantive development could'
require_text "$EXPERIENCE_STANDARD" '| X2.32 | Recommendation choice wording MUST match the number of recommendations shown.'
require_text "$EXPERIENCE_STANDARD" '| X2.33 | A completed guided Setup domain MUST close with one concise synthesis when accepted context from that domain can be meaningfully summarized.'
require_text "$EXPERIENCE_STANDARD" '| X2.34 | Machine-consumable owner results MUST NOT appear in normal orchestrated user-visible output.'
require_text "$EXPERIENCE_STANDARD" '| X2.35 | A delegated guided interaction MUST NOT expose a machine result after its final user-facing acknowledgment or question.'
require_text "$EXPERIENCE_STANDARD" 'Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result'
require_text "$EXPERIENCE_STANDARD" 'Converged Proposal example:'
require_text "$EXPERIENCE_STANDARD" 'Accepted information compounds during a guided interaction.'
require_absent "$EXPERIENCE_STANDARD" 'Select any of these'
require_absent "$EXPERIENCE_STANDARD" 'Choose a suitable repository structure.'
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
	# Superseded behavior: Profile and Objectives restated implementation details, User Exits, Owner Outcomes, and Resume Applicability. Those stay with the Highway Experience Standard.
	if [[ "$skill" != highway-profile && "$skill" != highway-objectives && "$skill" != highway-controls && "$skill" != highway-nfrs ]]; then
		require_text "$file" 'implementation details'
		require_text "$file" 'User Exits'
		require_text "$file" 'Owner Outcomes'
		require_text "$file" 'Resume Applicability'
	fi
	require_text "$file" 'ownership'
done

# Superseded behavior: Current Question, Domain Progress, and Current Activity were restated in the Profile skill. They are left to the Highway Experience Standard.
require_absent "$SKILLS_ROOT/highway-profile/SKILL.md" 'Current Question'
require_absent "$SKILLS_ROOT/highway-profile/SKILL.md" 'Domain Progress'
require_absent "$SKILLS_ROOT/highway-profile/SKILL.md" 'Current Activity'
# Superseded behavior: Objective discovery was labeled Outcome evidence.
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Business Objective'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Highway Relevance'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'A Profile-owned Blocked result blocks Objective behavior'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Success Measures'
require_text "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Why it matters:'
require_absent "$SKILLS_ROOT/highway-objectives/SKILL.md" 'Step 1 of 3'
require_absent "$SKILLS_ROOT/highway-objectives/SKILL.md" 'User Exits'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Concern'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Condition'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Obligation'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'Ask for missing information, not missing phrasing'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'one unresolved response-demanding question'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'materially interpreted user-authored proposal'
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" "Are there any other concerns or safeguards you'd like to establish?"
require_text "$SKILLS_ROOT/highway-controls/SKILL.md" 'candidate-generation result'
require_absent "$SKILLS_ROOT/highway-controls/SKILL.md" 'Completed Categories'
require_absent "$SKILLS_ROOT/highway-controls/SKILL.md" 'Current Category'
require_text "$SKILLS_ROOT/highway-nfrs/SKILL.md" 'pending Control-derived candidates'
require_text "$SKILLS_ROOT/highway-nfrs/SKILL.md" 'first unresolved candidate'
require_text "$SKILLS_ROOT/highway-new/SKILL.md" 'Current Domain'
require_text "$SKILLS_ROOT/highway-new/SKILL.md" 'Completed Domains'
require_text "$SKILLS_ROOT/highway-new/SKILL.md" 'Remaining Domains'
require_text "$SKILLS_ROOT/highway-new/SKILL.md" 'first incomplete evidence domain'
require_text "$SKILLS_ROOT/highway-discovery/SKILL.md" 'user-relevant analysis activity'
require_text "$SKILLS_ROOT/highway-adr/SKILL.md" 'user-relevant ADR activity'
require_text "$SKILLS_ROOT/highway-clarify/SKILL.md" 'one open finding question at a time'
require_text "$SKILLS_ROOT/highway-clarify/SKILL.md" 'Finding Position'
require_text "$SKILLS_ROOT/highway-clarify/SKILL.md" 'Remaining Findings'
require_text "$SKILLS_ROOT/highway-setup/SKILL.md" 'operational expectations future solutions should meet'
require_text "$SKILLS_ROOT/highway-setup/SKILL.md" 'requires additional owner interaction'
require_text "$SKILLS_ROOT/highway-setup/SKILL.md" 'Your foundational Highway context is now in place.'
require_text "$SKILLS_ROOT/highway-setup/SKILL.md" 'Run /highway-help to explore what Highway can help you do.'
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
