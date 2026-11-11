#!/usr/bin/env bash
# Config proposals start from automation best practice, show short use entries, and record new realized capabilities through highway-implementation.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "For a platform, a documented capability is proposed only when the accepted implementation realizes it." in highway-codify-config, or removing ### add capabilities from highway-implementation, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
CONFIG="$HW_SKILLS/highway-codify-config/SKILL.md"
IMPL="$HW_SKILLS/highway-implementation/SKILL.md"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require() {
	grep -Fq -- "$2" "$1" || {
		echo "FAIL: $(basename "$(dirname "$1")") omits: $2"
		fail=1
	}
}

reject() {
	if grep -Fq -- "$2" "$1"; then
		echo "FAIL: $(basename "$(dirname "$1")") still contains: $2"
		fail=1
	fi
}

require_in() {
	section "$1" "$2" | grep -Fq -- "$3" || {
		echo "FAIL: $(basename "$(dirname "$1")") $2 omits: $3"
		fail=1
	}
}

require_in "$CONFIG" '### current' '1. Read the technology'"'"'s current public documentation. Write nothing.'
require_in "$CONFIG" '### current' '2. For a standard, capture each capability the documentation describes.'
require_in "$CONFIG" '### current' '3. For a platform, capture each automation capability the documentation describes. Do not capture a capability unrelated to automation.'
require_in "$CONFIG" '### current' '6. For a platform, mark each grouped capability that the implementation'"'"'s Realized Capabilities do not already mean as a new realized capability. Judge that by meaning.'
require_in "$CONFIG" '### current' '7. Do not propose a capability the documentation no longer describes.'
require_in "$CONFIG" '### current' 'Mark no new realized capability.'
require_in "$CONFIG" '### current' '9. Then go to the proposal named with this step.'

require_in "$CONFIG" '### platform proposal' '1. For an add or update, follow `kind`, then `use entries`. Start an update from the current values after `current`.'
require_in "$CONFIG" '### platform proposal' '2. For a remove, show the current values. Do not run `current` or `use entries`. Leave out New Realized Capabilities.'
require_in "$CONFIG" '### platform proposal' '3. Fill this proposal.'
require_in "$CONFIG" '### platform proposal' '6. Emit this proposal, then the closing question and the cancel line.'
require_in "$CONFIG" '### platform proposal' '[On an add or update with no edit yet: **Here is a proposed starting point for configuring how highway-codify uses [Platform]**]'
require_in "$CONFIG" '### platform proposal' '**New Realized Capabilities:**'
require_in "$CONFIG" '### platform proposal' '1. **[Title]:** Realized By: [Platform].'
require_in "$CONFIG" '### platform proposal' 'List each capability `current` marked new under New Realized Capabilities. With none, show `None`.'
require_in "$CONFIG" '### platform proposal' 'Re-emit this proposal with the change and without the starting-point line.'
require_in "$CONFIG" '### platform proposal' "After a write, when the proposal listed new realized capabilities, emit: Let's record the new capabilities for [Platform]. Follow \`highway-implementation\` for [RI id], with those capabilities and the return step \`platform written\` in \`highway-codify-config\`. Otherwise go to \`platform written\`."

proposal="$(section "$CONFIG" '### platform proposal')"
consequence="$(printf '%s\n' "$proposal" | grep -nF '[One sentence stating the consequence of this change.]' | head -1 | cut -d: -f1)"
starting="$(printf '%s\n' "$proposal" | grep -nF '**Here is a proposed starting point' | head -1 | cut -d: -f1)"
platform="$(printf '%s\n' "$proposal" | grep -nF '**Platform:** [Platform]' | head -1 | cut -d: -f1)"
if [[ -z "$consequence" || -z "$starting" || -z "$platform" ]] || ((consequence >= starting || starting >= platform)); then
	echo 'FAIL: highway-codify-config platform proposal does not order the consequence, the starting-point line, then Platform'
	fail=1
fi

require_in "$CONFIG" '### platform written' '1. When the accepted proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`.'
require_in "$CONFIG" '### platform written' '2. Otherwise, when the platform works with code or configuration files, ask **Would you like to configure coding standards for [Platform]?**'
require_in "$CONFIG" '### platform written' '3. Otherwise, or after `decline`, go to `platforms`.'

require_in "$CONFIG" '### standard proposal' 'For an add or update, follow `use entries`.'

require_in "$CONFIG" '### use entries' '1. For a platform, take its type from the implementation'"'"'s Technology Choice and `current`'
require_in "$CONFIG" '### use entries' '2. On an add or update of a standard whose Technology is a platforms-catalog title, the whole value, compared without regard to case, follow `platform entries`. Do not follow `entry level`.'
require_in "$CONFIG" '### use entries' '3. Do not take an entry from the implementation'"'"'s Realized Capabilities or Runtime Components.'
require_in "$CONFIG" '### use entries' '4. Write each entry as one condition or one outcome, in five words or fewer. Count a hyphenated term as one word.'
require_in "$CONFIG" '### use entries' '5. Do not join two things with "and", "or", a comma, or a slash. Write two things as two entries.'
require_in "$CONFIG" '### use entries' '6. Give When to use and When not to use at least one entry each.'
require_in "$CONFIG" '### use entries' '7. On an update, keep each saved entry. Rewrite a saved entry that breaks step 4 or step 5, and state the rewrite in its **Why it matters:** sentence.'
require_in "$CONFIG" '### use entries' '9. Under each entry, emit **Why it matters:** and one sentence stating the consequence of that entry for the work Highway proposes. Name no customer, product, or decision of this organization. The catalog view, a conflict quote, and the saved cell keep the entry only.'
require_in "$CONFIG" '### use entries' '10. Return to the proposal that followed this step.'
require "$CONFIG" '- `highway-implementation`.'

reject "$CONFIG" 'is one sentence that names a condition and the required outcome'
reject "$CONFIG" 'For a platform, a documented capability is proposed only when the accepted implementation realizes it.'
reject "$CONFIG" 'Ground When to use and When not to use in `current`, the implementation'"'"'s Technology Choice, Runtime Components, and Realized Capabilities'

require_in "$IMPL" '### Entry' '1. When the invocation names an accepted implementation, new realized capabilities, and a return step, go to `add capabilities`.'
require_in "$IMPL" '### add capabilities' '1. Hold the return step for this visit.'
require_in "$IMPL" '### add capabilities' '3. Leave out a passed capability whose title Realized Capabilities already lists.'
require_in "$IMPL" '### add capabilities' '4. Derive each capability id as `write` does. When a title breaks the capability title rule, or `write` would ask for a wording change, leave that capability out.'
require_in "$IMPL" '### add capabilities' '5. Append each remaining capability to Realized Capabilities, in the order passed, with its Title, Realized By, and Evidence. Change no other byte of the record.'
require_in "$IMPL" '### add capabilities' '6. Rewrite this Parent'"'"'s rows in `implementations/capabilities.md` as `write` does, with the new capabilities. Leave other Parents unchanged.'
require_in "$IMPL" '### add capabilities' '7. Write the record and the catalog together. A failed write leaves both unchanged. Say what failed. Go to the held step.'
require_in "$IMPL" '### add capabilities' '8. Emit **New capabilities recorded for [Title]:** and list each recorded title.'
require_in "$IMPL" '### add capabilities' '9. Go to the held step. Do not ask a question. Do not run `platforms` or `close`.'

check_words() {
	local file="$1" heading="$2" limit="$3" words
	words="$(section "$file" "$heading" | wc -w | tr -d ' ')"
	if [[ -z "$(section "$file" "$heading")" ]] || ((words > limit)); then
		echo "FAIL: $(basename "$(dirname "$file")") $heading has $words words; the limit is $limit"
		fail=1
	fi
}

check_words "$CONFIG" '### use entries' 250
check_words "$IMPL" '### add capabilities' 250
check_words "$CONFIG" '### current' 400
check_words "$CONFIG" '### platform proposal' 400
check_words "$CONFIG" '### standard proposal' 400

for pair in "$CONFIG|### current" "$CONFIG|### platform proposal" "$CONFIG|### platform written" "$CONFIG|### use entries" "$IMPL|### Entry" "$IMPL|### add capabilities"; do
	file="${pair%%|*}"
	heading="${pair#*|}"
	for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
		if section "$file" "$heading" | grep -Fiwq -- "$word"; then
			echo "FAIL: $(basename "$(dirname "$file")") $heading uses: $word"
			fail=1
		fi
	done
done


if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: config proposals start from automation best practice and record new capabilities'
