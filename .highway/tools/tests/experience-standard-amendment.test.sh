#!/usr/bin/env bash
# Verifies the interaction-wide X2.3 amendment and version record.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
fail=0
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
for token in '8.2.0 (MINOR)' '**Version**: 8.2.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-03' 'Every user-visible response excludes Implementation details unless requested.' 'X2.7' 'X2.8' 'X2.9' 'X2.10' '| X2.36 | An Interactive Workflow MUST NOT narrate internal workflow progression, persistence, state transitions, or processing unless the person needs that information to act.' '| X2.37 | When Highway materially shaped a Working Idea, the person MUST receive a Contribution Opportunity before convergence unless prior interaction already provided one.' '| X2.38 | After a Substantive Contribution, an Interactive Workflow MUST re-evaluate the active understanding before selecting its next user-relevant behavior.' '| X2.39 | When re-evaluation reveals consequential uncertainty the person can resolve, an Interactive Workflow MUST address that uncertainty before advancing past the affected understanding.' '| X2.40 | An Interactive Workflow MUST NOT ask a clarification question when re-evaluation already supports one responsible interpretation that does not require user-supplied information.' '#### Collaborative Development (Non-Normative Guidance)' '##### Conversational Clarification (Non-Normative Guidance)' '#### Contribution Opportunity (Non-Normative Guidance)' '#### Contextual Re-evaluation (Non-Normative Guidance)' '### Evolution-Aware Guidance (Non-Normative)'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done

for token in \
	'Version change: 8.0.0 → 8.1.0 (MINOR)' \
	'**Version**: 8.2.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-03' \
	"Conversational commentary focuses on the person's meaning, situation, choices, implications, or outcomes rather than internal Highway activity." \
	'Workflow narration' \
	'#### Conversational Voice (Non-Normative Guidance)' \
	"| X2.8 | When accepted information changes Highway's understanding, interpretation, recommendation, or next user-relevant action, the next response MUST reflect the changed understanding using the newly accepted information together with relevant accumulated context before advancing." \
	"| X2.8 | When accepted information changes Highway's understanding, interpretation, recommendation, or next user-relevant action, the next response MUST reflect the changed understanding using the newly accepted information together with relevant accumulated context before advancing. | The next response uses the newly accepted information with relevant accumulated context to provide contextual interpretation, a useful connection, implication, distinction, recommendation, or next action when one exists; it does not merely repeat the person's words or narrate workflow mechanics. A simple acknowledgment or natural conclusion remains acceptable when re-evaluation reveals nothing useful to add and no unresolved information is needed. | [agent-checkable]"; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Feature 120 missing $token"; fail=1; }
done
if [[ "$(grep -c '^| X[0-9]' "$STANDARD")" -ne 44 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 44 rules'
	fail=1
fi
for protected in \
	.highway/skills/highway-objectives/SKILL.md \
	.highway/skills/highway-controls/SKILL.md \
	.highway/skills/highway-nfrs/SKILL.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/skills/highway-clarify/SKILL.md \
	.highway/governance/constitution.md \
	.highway/library/templates/output/profile-record.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q .; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done
for token in \
	'**Substantive Contribution**: A person' \
	'**Conversational Clarification**: Focused resolution' \
	'After a Substantive Contribution, an Interactive Workflow MUST re-evaluate' \
	'When re-evaluation reveals consequential uncertainty' \
	'An Interactive Workflow MUST NOT ask a clarification question when re-evaluation already supports' \
	'Existing acceptance, rejection, selection, persistence, and owner-result behavior continues to apply.' \
	'Re-evaluation is universal for Substantive Contributions; visible clarification is selective.' \
	'Conversational Clarification and Contribution Opportunity serve different purposes.' \
	'A clarification question does not automatically satisfy the Contribution Opportunity.' \
	'Conversational Clarification is not artifact review or acceptance.' \
	'Contextual re-evaluation occurs both while a Working Idea is developing and after knowledge becomes accepted.' \
	'Substantive Contribution' \
	'Accepted Knowledge' \
	'When the person supplies new substantive information, conversational continuity means responding from the changed understanding' \
	'When it is a Substantive Contribution, update the working understanding' \
	'receive a Substantive Contribution' \
	'Clear substantive contribution' \
	'Consequential ambiguity' \
	'Clarification versus Contribution Opportunity' \
	'Acceptance plus new information'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Feature 135 missing $token"; fail=1; }
done
for forbidden in \
	'CLAR identifiers' \
	'finding fingerprints' \
	'clarification catalogs' \
	'persisted clarification history' \
	'A/B/C/D clarification options'; do
	if grep -Fq "$forbidden" "$STANDARD"; then
		echo "FAIL: Feature 135 imported forbidden clarification artifact mechanics: $forbidden"
		fail=1
	fi
done
# Feature 101 evidence-first rows. Superseded X2.2 behavior: the first emitted content is a greeting or required question.
# Feature 127 superseded the immediate-acceptance wording with the Converged Proposal boundary.
for token in \
	'| X2.2 | An Interactive Workflow MUST use accepted information, available evidence, or a grounded recommendation before asking a question.' \
	'| X2.11 | Accepted information that already answers the need MUST be reused.' \
	'| X2.12 | When the workflow supports it, authoritative organizational information MUST be imported or validated rather than recreated conversationally.' \
	'| X2.13 | An Interactive Workflow MUST contribute a grounded Converged Proposal or useful Working Idea before asking when available relevant context supports either.' \
	'| X2.14 | A question MUST NOT be asked only to satisfy an internal workflow dimension.' \
	'| X2.15 | Organization size, maturity, or operating model MUST NOT be assigned from organization identity alone.' \
	'| X2.7 | A recommendation MUST be grounded in context the owning workflow declares.' \
	'| X2.16 | A recommendation set MUST contain at most 5 distinct actionable choices.' \
	'| X2.17 | A user-authored alternative MUST stay available whenever recommendations are shown.' \
	'| X2.18 | Selecting a displayed Converged Proposal MUST count as acceptance without a second confirmation.' \
	'| X2.19 | A request for explanation, comparison, or more information MUST NOT be treated as acceptance.' \
	'| X2.20 | Further recommendations MUST stop when no useful grounded non-duplicate choice remains, the person is finished, or the person will provide their own information.' \
	'| X2.21 | A materially interpreted Converged Proposal MUST be reviewed under the heading "Here'"'"'s what I'"'"'ve captured as your [category]:", with one acceptance request at the bottom.' \
	'| X2.22 | A direct domain-complete statement or explicitly selected Converged Proposal MUST be captured without an additional interpretation review.' \
	'| X2.9 | Decision Context MUST follow the question it explains under the label "**Why it matters:**".' \
	'| X2.25 | Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared collaborative recommendation model.' \
	"Here's what I've captured as your [category]:" \
	'at most 5'
do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done
# X2.13 contribution precedence: evaluate context in order before asking.
if ! grep -Fq 'Before an unresolved question, the workflow evaluates available relevant context in order: present a Converged Proposal when supported; otherwise contribute a useful Working Idea when supported; otherwise ask the focused unresolved question.' "$STANDARD"; then
	echo 'FAIL: X2.13 observable does not express contribution precedence'
	fail=1
fi
if ! grep -Fq '| X2.32 | Recommendation choice wording MUST match the number of recommendations shown.' "$STANDARD"; then
	echo 'FAIL: X2.32 choice-wording rule is missing'
	fail=1
fi
for closure_rule in \
	'| X2.33 | A completed guided Setup domain MUST close with one concise synthesis when accepted context from that domain can be meaningfully summarized.' \
	'| X2.34 | Machine-consumable owner results MUST NOT appear in normal orchestrated user-visible output.' \
	'| X2.35 | A delegated guided interaction MUST NOT expose a machine result after its final user-facing acknowledgment or question.'
do
	grep -Fq "$closure_rule" "$STANDARD" || { echo "FAIL: Experience Standard missing $closure_rule"; fail=1; }
done
# Superseded behavior: X2.9 required the explanation before the unresolved question.
if grep -Fq '| X2.9 | Decision Context MUST use the label "**Why it matters:**" and explain why the answer matters to the person without asking a second question.' "$STANDARD"; then
	echo 'FAIL: former X2.9 explanation-before-question rule is still present'
	fail=1
fi
if grep -Fq '6.0.0 → 7.0.0 (MAJOR)' "$STANDARD"; then
	echo 'FAIL: superseded Feature 120 Experience Standard report is still present'
	fail=1
fi
if ! grep -Fq 'internal persistence, state evaluation, routing, and progression occur without narration unless the person needs the information to act' "$STANDARD"; then
	echo 'FAIL: X2.36 interaction-model guidance is missing'
	fail=1
fi
if [[ "$(grep -cF 'Sync Impact Report' "$STANDARD")" -ne 1 ]]; then
	echo 'FAIL: Experience Standard must contain exactly one Sync Impact Report'
	fail=1
fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience Standard amendment passes'
