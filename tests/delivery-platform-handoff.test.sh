#!/usr/bin/env bash
# An incomplete implementation record stops highway-codify, which hands off to highway-implementation and back.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "[Field] is needed. Name it on the implementation." in highway-codify, or removing ### delivery platforms from highway-implementation, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
SKILLS="$HW_SKILLS"
CODIFY="$SKILLS/highway-codify/SKILL.md"
IMPL="$SKILLS/highway-implementation/SKILL.md"
ONBOARD="$SKILLS/highway-onboarding/SKILL.md"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require_in() {
	local file="$1" heading="$2" text="$3"
	section "$file" "$heading" | grep -Fq -- "$text" || {
		echo "FAIL: $(basename "$(dirname "$file")") $heading omits: $text"
		fail=1
	}
}

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")") still contains: $text"
		fail=1
	fi
}

P='### provider'
require_in "$CODIFY" "$P" '2. When the Executor names a platform with no row, go to `record check`. Do not show the proposal. Write nothing.'
N='### record check'
require_in "$CODIFY" "$N" "**[Product Title]'s implementation record is missing critical detail required for highway-codify proposals.**"
require_in "$CODIFY" "$N" "Let's set those details now for [Product Title]."
require_in "$CODIFY" "$N" '5. Then follow `highway-implementation` for [RI id], with the return step `record check` in `highway-codify`. Ask nothing.'
require_in "$CODIFY" "$N" '3. When `highway-implementation` returned here and the record is still incomplete, stop.'
require_in "$CODIFY" "$N" 'A return keeps the selected implementation and any selected action, and reads the record again.'
reject "$CODIFY" '[Field] is needed. Name it on the implementation.'
reject "$CODIFY" '### platforms needed'
reject "$CODIFY" 'with the return step `provider` in `highway-codify`'

words="$(section "$CODIFY" "$N" | wc -w | tr -d ' ')"
if [[ "$words" -eq 0 || "$words" -gt 250 ]]; then
	echo "FAIL: highway-codify $N has $words words; the limit is 250"
	fail=1
fi

require_in "$IMPL" '### Entry' '2. When the invocation names an accepted implementation and a return step, and names no realized capabilities, go to `delivery platforms`.'
D='### delivery platforms'
require_in "$IMPL" "$D" '1. Hold the return step for this visit. Keep it while configuration or onboarding runs from this step.'
require_in "$IMPL" "$D" '**Product Title:** [Title]'
require_in "$IMPL" "$D" '**Architecture Reference:** [RA id] — [Architecture title]'
require_in "$IMPL" "$D" '**Deployed by:** [Platform. Or: Needed.]'
require_in "$IMPL" "$D" '**Managed by:** [Platform. Or: Needed.]'
require_in "$IMPL" "$D" '**Language:** [Standard Title. Or: None.]'
require_in "$IMPL" "$D" '- `edit`: follow `field` for each named field, with the return step `delivery platforms` in `highway-implementation`. Re-emit this view.'
require_in "$IMPL" "$D" 'Otherwise rewrite the three Execution lines with the held fields. Change no other byte.'
require_in "$IMPL" "$D" 'On success, emit: The preferred delivery platforms for [Title] are set. Picking up your highway-codify run. Go to the held step.'
require_in "$IMPL" "$D" '**Here is the proposed Deployed by, Managed by and Language for [Product Title]**'
require_in "$IMPL" "$D" '- `decline`: go to `delivery decline`.'
require_in "$IMPL" "$D" 'Do not create an implementation. Do not run `platforms` or `close`.'
require_in "$IMPL" '### delivery decline' 'Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].'
require_in "$IMPL" '### delivery decline' '**Would you like to return and provide these details now?**'

words="$(section "$IMPL" "$D" | wc -w | tr -d ' ')"
if [[ "$words" -eq 0 || "$words" -gt 400 ]]; then
	echo "FAIL: highway-implementation $D has $words words; the limit is 400"
	fail=1
fi
for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
	if section "$IMPL" "$D" | grep -Fiwq -- "$word"; then
		echo "FAIL: highway-implementation $D uses: $word"
		fail=1
	fi
done

require "$IMPL" 'Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: Needed`.'
reject "$ONBOARD" 'When the caller named the return step `provider` in `highway-codify`'


if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: an incomplete record hands off to highway-implementation and back'
