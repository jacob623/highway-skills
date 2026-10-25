#!/usr/bin/env bash
# Profile labels are bold, recommendation sets are numbered with the approved closing copy, and NFRs follow Controls first.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: an "If none of these fit" line, a bulleted recommendation, or a plain Profile label fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
PROFILE="$SKILLS/highway-profile/SKILL.md"
OBJECTIVES="$SKILLS/highway-objectives/SKILL.md"
CONTROLS="$SKILLS/highway-controls/SKILL.md"
NFRS="$SKILLS/highway-nfrs/SKILL.md"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")") omits: $text"
		fail=1
	}
}

forbid() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")") keeps: $text"
		fail=1
	fi
}

count_at_least() {
	local file="$1" text="$2" want="$3" got
	got="$(grep -Fc -- "$text" "$file")"
	if [[ "$got" -lt "$want" ]]; then
		echo "FAIL: $(basename "$(dirname "$file")") has $got of $want: $text"
		fail=1
	fi
}

for label in 'Future Direction' 'Desired Impact' 'Future State' 'Primary Approach' 'Strategic Advantage' 'Important Tradeoff' '[Short principle name]'; do
	require "$PROFILE" "- **$label**"
	if grep -Fxq -- "- $label" "$PROFILE"; then
		echo "FAIL: highway-profile keeps a plain label: $label"
		fail=1
	fi
done

for skill in "$OBJECTIVES" "$CONTROLS" "$NFRS"; do
	count_at_least "$skill" '1. **[Title]:** [One sentence.]' 3
	require "$skill" 'Number every recommendation in the set, starting at 1.'
	require "$skill" '- `select`: names one or more recommendations in the current set, by title or by number.'
	require "$skill" 'A number in the reply refers to the recommendation set, not the queue list.'
	count_at_least "$skill" "If you'd like additional suggestions, just say so." 3
	forbid "$skill" 'If none of these fit'
	forbid "$skill" 'just let me know'
	forbid "$skill" '- **[Title]:** [One sentence.]'
done

count_at_least "$OBJECTIVES" 'You can select some, all or provide your own outcome.' 3
count_at_least "$CONTROLS" 'You can select some, all or provide your own safeguards.' 3
count_at_least "$NFRS" 'You can select some, all or provide your own operational expectation.' 3

count_at_least "$OBJECTIVES" "If you'd like to add another outcome first, just say so." 2
count_at_least "$CONTROLS" "If you'd like to add another safeguard first, just say so." 2
count_at_least "$NFRS" "If you'd like to add another operational expectation first, just say so." 2

require "$NFRS" 'Derive each recommendation from an accepted Control that no queued, shown, or captured NFR reflects yet.'
require "$NFRS" 'Use the accepted Profile and accepted Objectives to refine its scope, priority, and wording.'
require "$NFRS" 'One NFR may reflect more than one Control.'
require "$NFRS" 'While any accepted Control is unreflected, the set contains only recommendations derived from Controls'
require "$NFRS" 'An unreflected Control is a remaining grounded recommendation.'
require "$NFRS" 'After every accepted Control is reflected, check coverage across'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: guided flow refinements'
