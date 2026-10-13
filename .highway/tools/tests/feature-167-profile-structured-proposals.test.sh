#!/usr/bin/env bash
# Verifies the Feature 167 structured proposal-first Profile contract.
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

require_flowed() {
	tr '\n' ' ' < "$1" | tr -s ' ' | grep -Fq -- "$2" || {
		echo "FAIL: missing flowed text '$2' in $1"
		fail=1
	}
}

require_order() {
	first_line="$(grep -nF -- "$2" "$1" | head -n1 | cut -d: -f1)"
	second_line="$(grep -nF -- "$3" "$1" | head -n1 | cut -d: -f1)"
	if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
		echo "FAIL: '$2' must precede '$3' in $1"
		fail=1
	fi
}

# US1: Vision uses a structured contribution opportunity before its question when evidence supports one.
for text in \
	'Vision Discovery Contribution Opportunity' \
	'Vision starting points should be presented as structured bullets rather than narrative prose' \
	'What would you add, correct, or remove?' \
	'accepted Identity evidence and other accepted Profile evidence' \
	'responsible first-pass Vision interpretation'; do
	require_text "$PROFILE" "$text"
done
require_order "$PROFILE" 'Vision Discovery Contribution Opportunity' 'Vision question'
require_flowed "$PROFILE" 'Further exploratory questioning becomes the exception path when accepted evidence cannot support a responsible starting point'

# US2: Competitive Path is grounded in accepted context and exposes structured path elements.
for text in \
	'Competitive Path Discovery Contribution Opportunity' \
	'Competitive Path starting points should be presented as structured bullets rather than narrative prose' \
	'Primary Approach' \
	'Strategic Advantage' \
	'Important Tradeoff' \
	'accepted Identity, Vision, and other accepted Profile evidence'; do
	require_text "$PROFILE" "$text"
done
require_order "$PROFILE" 'Competitive Path Discovery Contribution Opportunity' 'Competitive Path question'

# US3: Guiding Principles are individually visible and remain decision guidance rather than Controls.
for text in \
	'Guiding Principles Discovery Contribution Opportunity' \
	'Guiding Principles starting points should be presented as structured bullets rather than narrative prose' \
	'potential decision-making values individually' \
	'Principle'; do
	require_text "$PROFILE" "$text"
done
require_order "$PROFILE" 'Guiding Principles Discovery Contribution Opportunity' 'Guiding Principles question'

# US4: All three opportunities remain provisional and preserve the existing lifecycle boundaries.
for text in \
	'When accepted evidence supports a responsible first-pass interpretation of Vision, Competitive Path, or Guiding Principles' \
	'The starting point exists to give the person something meaningful to react to.' \
	'Questions remain available when accepted evidence cannot support a responsible starting point.' \
	'Contribution Opportunity rather than a Converged Proposal' \
	'Re-evaluate the active understanding with relevant accepted context' \
	'does not introduce new Profile fields' \
	'does not create new readiness dimensions' \
	'Retain nothing from Vision before that candidate is presented and accepted.'; do
	require_text "$PROFILE" "$text"
done
require_flowed "$PROFILE" 'Retain nothing from Competitive Path before that candidate is presented and accepted.'
require_flowed "$PROFILE" 'Retain nothing from Guiding Principles before that candidate is presented and accepted.'

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
echo 'OK: Feature 167 Profile Structured Proposals contract passes'
