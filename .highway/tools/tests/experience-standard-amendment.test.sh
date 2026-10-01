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
# Superseded behavior: the runtime document was required to keep '3.0.0 → 4.0.0 (MAJOR)'.
for token in '7.0.0 → 7.1.0 (MINOR)' '**Version**: 7.1.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-01' 'Every user-visible response excludes Implementation details unless requested.' 'X2.7' 'X2.8' 'X2.9' 'X2.10'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done
for token in \
	'Version change: 7.0.0 → 7.1.0 (MINOR)' \
	'**Version**: 7.1.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-01' \
	'#### Conversational Voice (Non-Normative Guidance)' \
	'| X2.8 | When accepted information changes Highway'"'"'s understanding, interpretation, recommendation, or next user-relevant action, the next response MUST acknowledge what changed.' \
	'| X2.8 | When accepted information changes Highway'"'"'s understanding, interpretation, recommendation, or next user-relevant action, the next response MUST acknowledge what changed. | The next response connects the accepted information to Highway'"'"'s updated understanding, interpretation, recommendation, or next action; it is not acknowledgment-only and does not merely repeat the person'"'"'s words. | [agent-checkable]'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Feature 120 missing $token"; fail=1; }
done
if [[ "$(grep -c '^| X[0-9]' "$STANDARD")" -ne 39 ]]; then
	echo 'FAIL: Experience Standard rule inventory must remain 39 rules'
	fail=1
fi
for protected in \
	.highway/skills/highway-objectives/SKILL.md \
	.highway/skills/highway-controls/SKILL.md \
	.highway/skills/highway-nfrs/SKILL.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/library/knowledge/highway-identity.md \
	.highway/library/templates/output/profile-record.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q .; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done
# Feature 101 evidence-first rows. Superseded X2.2 behavior: the first emitted content is a greeting or required question.
for token in \
	'| X2.2 | An Interactive Workflow MUST use accepted information, available evidence, or a grounded recommendation before asking a question.' \
	'| X2.11 | Accepted information that already answers the need MUST be reused.' \
	'| X2.12 | When the workflow supports it, authoritative organizational information MUST be imported or validated rather than recreated conversationally.' \
	'| X2.13 | Grounded recommendations MUST be offered before a question when context supports useful choices.' \
	'| X2.14 | A question MUST NOT be asked only to satisfy an internal workflow dimension.' \
	'| X2.15 | Organization size, maturity, or operating model MUST NOT be assigned from organization identity alone.' \
	'| X2.7 | A recommendation MUST be grounded in context the owning workflow declares.' \
	'| X2.16 | A recommendation set MUST contain at most 5 distinct actionable choices.' \
	'| X2.17 | A user-authored alternative MUST stay available whenever recommendations are shown.' \
	'| X2.18 | Selecting a displayed recommendation MUST count as acceptance without a second confirmation.' \
	'| X2.19 | A request for explanation, comparison, or more information MUST NOT be treated as acceptance.' \
	'| X2.20 | Further recommendations MUST stop when no useful grounded non-duplicate choice remains, the person is finished, or the person will provide their own information.' \
	'| X2.21 | Material interpretation MUST be reviewed under the heading "Here'"'"'s what I'"'"'ve captured as your [category]:", with the proposal immediately below and one acceptance request at the bottom.' \
	'| X2.22 | An explicit selection, a direct statement already in the requested category, or clearly presented imported information MUST be captured without that review.' \
	'| X2.9 | Decision Context MUST follow the question it explains under the label "**Why it matters:**".' \
	'| X2.25 | Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared recommendation interaction model.' \
	"Here's what I've captured as your [category]:" \
	'at most 5'
do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done
# Superseded behavior: X2.13's observable did not require evaluation before each unresolved guided-collection question.
if ! grep -Fq 'Before each unresolved guided-collection question, the workflow evaluates accumulated accepted context; a useful grounded choice is shown instead of the question.' "$STANDARD"; then
	echo 'FAIL: X2.13 observable does not evaluate before each unresolved guided-collection question'
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
if [[ "$(grep -cF 'Sync Impact Report' "$STANDARD")" -ne 1 ]]; then
	echo 'FAIL: Experience Standard must contain exactly one Sync Impact Report'
	fail=1
fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience Standard amendment passes'
