#!/usr/bin/env bash
# Verifies the Feature 165 Identity Discovery Contribution Opportunity contract in the Profile source and adapters.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
fail=0

require_text() {
	grep -Fq -- "$2" "$1" || { echo "FAIL: missing '$2' in $1"; fail=1; }
}

flow() {
	tr '\n' ' ' < "$1" | tr -s ' '
}

require_flowed() {
	flow "$1" | grep -Fq -- "$2" || { echo "FAIL: missing flowed text '$2' in $1"; fail=1; }
}

require_order() {
	first_line="$(grep -nF -- "$2" "$1" | head -n1 | cut -d: -f1)"
	second_line="$(grep -nF -- "$3" "$1" | head -n1 | cut -d: -f1)"
	if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
		echo "FAIL: '$2' must precede '$3' in $1"
		fail=1
	fi
}

# US1: structured review before convergence when material discovery evidence exists.
for text in \
	'Identity Discovery Contribution Opportunity' \
	'omission detection rather than categorization' \
	"Here's what Highway believes [Organization Name] does." \
	'When Organization Name has not been accepted, use the accepted Repository Name where natural.' \
	'What would you add, correct, or remove?'; do
	require_text "$PROFILE" "$text"
done
require_flowed "$PROFILE" 'website content, imported material, or discovery evidence materially contributes to Identity development'
require_order "$PROFILE" 'Identity Discovery Contribution Opportunity' 'Identity Converged Proposal'

# US2: meaningful evidence-grounded findings, not isolated labels or a fixed taxonomy.
for text in \
	'concise, visually distinct title representing a meaningful organizational expression' \
	'one-sentence evidence-grounded summary explaining what Highway believes it found' \
	'**Retail Craft Kits:**' \
	'**Homeschool Curriculum:**' \
	'**Studio Classes:**' \
	'**Community Workshops:**' \
	'A fixed taxonomy is not required'; do
	require_text "$PROFILE" "$text"
done
require_flowed "$PROFILE" 'Do not emit isolated nouns or labels'
require_flowed "$PROFILE" 'products, services, programs, activities, audiences, communities served, delivery models, revenue-generating offerings'

# US3: corrections remain proposed, are re-synthesized, and stabilize before normal convergence.
for text in \
	'Contribution Opportunity rather than a Converged Proposal' \
	'Re-synthesize and re-present the Identity Discovery Contribution Opportunity' \
	'Do not transition immediately to the Identity Converged Proposal merely because' \
	'Remain within the Identity Discovery Contribution Opportunity while' \
	'only after the person indicates the findings are accurate' \
	'accepted discovery-contribution understanding' \
	'Using your organization'"'"'s name is often a good choice.' \
	'does not introduce new Profile fields' \
	'does not create new readiness dimensions'; do
	require_text "$PROFILE" "$text"
done
require_flowed "$PROFILE" 'adds, corrects, removes, combines, splits, or otherwise changes'
require_flowed "$PROFILE" 'no longer provides substantive additions, corrections, removals, combinations, or splits'
require_flowed "$PROFILE" 'modifications to proposed Identity evidence'
require_flowed "$PROFILE" 'remains proposed evidence until accepted'
require_flowed "$PROFILE" 'discovery-contribution representation and the final Identity Converged Proposal are separate artifacts'

# The final proposal and retained narrative must still use the existing boundaries.
require_text "$PROFILE" 'A domain'
for adapter in \
	.github/skills/highway-profile/SKILL.md \
	.claude/skills/highway-profile/SKILL.md \
	.cursor/skills/highway-profile/SKILL.md \
	.agents/skills/highway-profile/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$adapter" ]] || ! cmp -s "$PROFILE" "$REPO_ROOT/$adapter"; then
		echo "FAIL: generated adapter differs from Profile source: $adapter"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 165 Identity Discovery Contribution Opportunity contract passes'
