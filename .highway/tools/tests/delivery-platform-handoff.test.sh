#!/usr/bin/env bash
# An empty delivery platform stops highway-codify, which hands off to highway-implementation and back, or uses a platform named for one run.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "[Field] is needed. Name it on the implementation." in highway-codify, or removing ### delivery platforms from highway-implementation, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
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
require_in "$CODIFY" "$P" '2. When this run holds a named platform, it is the Executor. When this run holds a coding standard, it is Language for this run.'
require_in "$CODIFY" "$P" '3. When the Executor is `Needed`, empty, or names a platform with no row, go to `platforms needed`. Do not show the proposal. Write nothing.'
N='### platforms needed'
require_in "$CODIFY" "$N" "**[Product Title]'s implementation record does not list preferred delivery platforms.**"
require_in "$CODIFY" "$N" 'Without these, Codify is unable to make proposals for [Product title].'
require_in "$CODIFY" "$N" '**Would you like to set the preferred delivery platforms now?**'
require_in "$CODIFY" "$N" "If you'd prefer to name the delivery platform for this single codify run, just say so. Future highway-codify runs for [Product title] will result in this same message."
require_in "$CODIFY" "$N" "- A yes that names no platform: emit: Let's set the preferred delivery platforms for [Product Title]. Follow \`highway-implementation\` for [RI id], with the return step \`provider\` in \`highway-codify\`."
require_in "$CODIFY" "$N" '- A platforms-catalog row, named with or without a yes: hold it for this run. Return to `provider`.'
require_in "$CODIFY" "$N" "Follow \`highway-codify-config\` for [Platform], with the return step \`provider\` in \`highway-codify\`."
require_in "$CODIFY" "$N" "Follow \`highway-onboarding\` for [Platform], with the return step \`provider\` in \`highway-codify\`."
require_in "$CODIFY" "$N" '- A listed coding-standard title: hold it for this run. Re-emit the message.'
require_in "$CODIFY" "$N" '**Which platform would you like this codify run to use?**'
require_in "$CODIFY" "$N" '- `decline`, or a no: stop. Write nothing.'
require_in "$CODIFY" "$N" 'A held platform or coding standard is never written to the implementation.'
require_in "$CODIFY" "$N" 'A return to `provider` keeps the selected implementation, the action, and the draft, and reads the record again.'
reject "$CODIFY" '[Field] is needed. Name it on the implementation.'

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
require_in "$IMPL" "$D" 'Otherwise rewrite the three Execution lines. Change no other byte.'
require_in "$IMPL" "$D" 'On success, emit: The preferred delivery platforms for [Title] are set. Picking up your highway-codify run. Go to the held step.'
require_in "$IMPL" "$D" '- `decline`: emit: Leaving the preferred delivery platforms for [Title] unset. Picking up your highway-codify run. Write nothing. Go to the held step.'
require_in "$IMPL" "$D" 'Do not create an implementation. Do not run `platforms` or `close`.'

words="$(section "$IMPL" "$D" | wc -w | tr -d ' ')"
if [[ "$words" -eq 0 || "$words" -gt 250 ]]; then
	echo "FAIL: highway-implementation $D has $words words; the limit is 250"
	fail=1
fi
for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
	if section "$IMPL" "$D" | grep -Fiwq -- "$word"; then
		echo "FAIL: highway-implementation $D uses: $word"
		fail=1
	fi
done

require "$ONBOARD" 'Its Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: None`.'
require "$ONBOARD" 'When the caller named the return step `provider` in `highway-codify`, go to that step after the platform row is written.'

require "$CODIFY" 'version: 12.3.0'
require "$IMPL" 'version: 7.6.0'
require "$ONBOARD" 'version: 10.5.0'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: an empty delivery platform hands off to highway-implementation and back'
