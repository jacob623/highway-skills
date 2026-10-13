#!/usr/bin/env bash
# Verifies the Feature 168 Profile question-bias simplification contract.
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

# US1: grounded reasoning enters an active structured starting point.
for text in \
	'When a Discovery Contribution Opportunity is active, incorporate one grounded advisory addition into its structured starting point' \
	'let the person react through the active Discovery Contribution Opportunity' \
	'Questions remain available when accepted evidence cannot support a responsible starting point.' \
	'When a Discovery Contribution Opportunity is active, express that grounded interpretation inside its proposed starting point rather than questioning it separately.' \
	'What would you add, correct, or remove?'; do
	require_flowed "$PROFILE" "$text"
done

# US2: necessary clarification and existing boundaries remain available.
for text in \
	'consequential ambiguity remains unresolved' \
	'canonical questions' \
	'One worked counter-example.' \
	'What does the bakery do that a person would miss if it closed?' \
	'Retain nothing from Vision before that candidate is presented and accepted.' \
	'does not introduce new Profile fields' \
	'does not create new readiness dimensions'; do
	require_flowed "$PROFILE" "$text"
done

# US3: remove the three question-centric worked examples while retaining the section and counter-example.
require_text "$PROFILE" '#### Contribution in practice'
require_absent "$PROFILE" 'Which of those two would you be judged on?'
require_absent "$PROFILE" 'Does that read as the thing you'
require_absent "$PROFILE" 'What would have to be true for you to break it?'
require_flowed "$PROFILE" 'When the person supplies something substantial, add one grounded thing to it.'
require_flowed "$PROFILE" 'inside the active structured starting point'
require_flowed "$PROFILE" 'When accepted evidence already supports a useful distinction, implication, connection, tension, structure, organizing principle, or Working Idea, do not ask a question that merely seeks permission to express the interpretation.'

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
echo 'OK: Feature 168 Profile Question-Bias Simplification contract passes'
