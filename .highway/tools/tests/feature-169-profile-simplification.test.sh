#!/usr/bin/env bash
# Verifies the Feature 169 Profile Simplification Pass contract.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
fail=0

flow() { tr '\n' ' ' < "$1" | tr -s ' '; }
require_text() { grep -Fq -- "$2" "$1" || { echo "FAIL: missing '$2' in $1"; fail=1; }; }
require_flowed() { flow "$1" | grep -Fq -- "$2" || { echo "FAIL: missing flowed text '$2' in $1"; fail=1; }; }
require_absent() { if flow "$1" | grep -Fq -- "$2"; then echo "FAIL: '$2' remains in $1"; fail=1; fi; }
require_count() {
	actual="$(flow "$1" | grep -Fo -- "$3" | wc -l | tr -d ' ')"
	if [[ "$actual" -ne "$4" ]]; then
		echo "FAIL: $2 expected $4 occurrences of '$3' but found $actual"
		fail=1
	fi
}

# US1: the four opportunities remain and the five competing standalone sections are removed.
for heading in \
	'### Identity Discovery Contribution Opportunity' \
	'#### Vision Discovery Contribution Opportunity' \
	'#### Competitive Path Discovery Contribution Opportunity' \
	'#### Guiding Principles Discovery Contribution Opportunity'; do
	require_text "$PROFILE" "$heading"
done
for heading in \
	'#### Advisory question scaffolding' \
	'#### Contribution in practice' \
	'#### Possibility-list Contribution Opportunities' \
	'#### Structure-revealing contributions' \
	'##### Organizational expression'; do
	require_absent "$PROFILE" "$heading"
done
require_flowed "$PROFILE" 'The Vision Discovery Contribution Opportunity is a Contribution Opportunity rather than a Converged Proposal.'
require_flowed "$PROFILE" 'The Competitive Path Discovery Contribution Opportunity is a Contribution Opportunity rather than a Converged Proposal.'
require_flowed "$PROFILE" 'The Guiding Principles Discovery Contribution Opportunity is a Contribution Opportunity rather than a Converged Proposal.'

# US2: Interpretation confidence remains and structure guidance is owned by each opportunity.
for statement in \
	'Prefer a grounded interpretation that can be corrected over a missing interpretation that forces the person to create it from scratch.' \
	'When accepted evidence already supports a useful distinction, implication, connection, tension, structure, organizing principle, or Working Idea, do not ask a question that merely seeks permission to express the interpretation.' \
	'When accepted evidence supports a responsible first-pass interpretation of Vision, Competitive Path, or Guiding Principles, prefer presenting a structured starting point rather than continuing exploratory questioning.' \
	'When a Discovery Contribution Opportunity is active, express that grounded interpretation inside its proposed starting point rather than questioning it separately.' \
	'The starting point exists to give the person something meaningful to react to.' \
	'Questions remain available when accepted evidence cannot support a responsible starting point.'; do
	require_flowed "$PROFILE" "$statement"
done
structure_sentence='Use the proposed starting point to reveal relationships, patterns, structure, tensions, tradeoffs, implications, dependencies, and organizing principles already supported by accepted evidence.'
require_count "$PROFILE" 'Profile skill' "$structure_sentence" 4

# US3: obsolete verification claims are absent while protected boundaries remain.
for bullet in \
	'- Contribution in practice carries three worked exemplars, each adding one thing.' \
	'- Contribution in practice carries one counter-example of an addition the accepted material does not support.' \
	'- Each Substantive Contribution receives one acknowledgment.' \
	'- An acknowledgment adds understanding beyond restating the contribution.'; do
	require_absent "$PROFILE" "$bullet"
done
for protected in \
	'Each accepted domain mutation succeeds before Profile uses it as persisted knowledge.' \
	'No retained schema field or readiness dimension is added for convergence or collaboration concepts.' \
	'Each domain crosses one acceptance boundary before its substance is retained.' \
	"No domain substance is retained before that domain's candidate has been presented."; do
	require_flowed "$PROFILE" "$protected"
done

# Generated Profile adapters must match the source document exactly.
for generated in \
	"$REPO_ROOT/.github/skills/highway-profile/SKILL.md" \
	"$REPO_ROOT/.claude/skills/highway-profile/SKILL.md" \
	"$REPO_ROOT/.cursor/skills/highway-profile/SKILL.md" \
	"$REPO_ROOT/.agents/skills/highway-profile/SKILL.md"; do
	if [[ ! -f "$generated" ]] || ! cmp -s "$PROFILE" "$generated"; then
		echo "FAIL: generated Profile adapter differs from source: $generated"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 169 Profile Simplification Pass contract passes'
