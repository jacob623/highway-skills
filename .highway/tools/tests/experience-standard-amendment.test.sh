#!/usr/bin/env bash
# Verifies the interaction-wide X2.3 amendment and version record.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fail=0
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
for token in '1.6.1 -> 2.0.0 (MAJOR)' 'Every user-visible response excludes Implementation details unless requested.' 'X2.7' 'X2.8' 'X2.9' 'X2.10'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
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
	"Here's what I've captured as your [category]:" \
	'at most 5'
do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience Standard amendment passes'
