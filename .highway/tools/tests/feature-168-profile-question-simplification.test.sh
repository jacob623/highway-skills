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
require_count() {
	actual="$(flow "$1" | grep -Fo -- "$3" | wc -l | tr -d ' ')"
	if [[ "$actual" -ne "$4" ]]; then
		echo "FAIL: $2 expected $4 occurrences of '$3' but found $actual"
		fail=1
	fi
}

# US1: grounded interpretation remains inside an active structured starting point.
for text in \
	'Questions remain available when accepted evidence cannot support a responsible starting point.' \
	'When a Discovery Contribution Opportunity is active, express that grounded interpretation inside its proposed starting point rather than questioning it separately.' \
	'What would you add, correct, or remove?'; do
	require_flowed "$PROFILE" "$text"
done

# US2: existing fallback and domain boundaries remain available.
for text in \
	'Retain nothing from Vision before that candidate is presented and accepted.' \
	'does not introduce new Profile fields' \
	'does not create new readiness dimensions'; do
	require_flowed "$PROFILE" "$text"
done

# US3: the former question-centric worked examples remain absent.
require_absent "$PROFILE" '#### Contribution in practice'
require_absent "$PROFILE" 'Which of those two would you be judged on?'
require_absent "$PROFILE" 'Does that read as the thing you'
require_absent "$PROFILE" 'What would have to be true for you to break it?'
require_count "$PROFILE" 'Profile skill' 'Use the proposed starting point to reveal relationships, patterns, structure, tensions, tradeoffs, implications, dependencies, and organizing principles already supported by accepted evidence.' 4
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
