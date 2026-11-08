#!/usr/bin/env bash
# Config groups new realized capabilities by the automation and matches existing capabilities by meaning.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring the step that marks capabilities the implementation does not list, or removing the grouping step, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG="$HIGHWAY_ROOT/skills/highway-codify-config/SKILL.md"
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

reject_in() {
	if section "$1" "$2" | grep -Fq -- "$3"; then
		echo "FAIL: $(basename "$(dirname "$1")") $2 still contains: $3"
		fail=1
	fi
}

current="$(section "$CONFIG" '### current')"
previous=0
for step in \
	'1. Read the technology'"'"'s current public documentation. Write nothing.' \
	'2. For a standard, capture each capability the documentation describes.' \
	'3. For a platform, capture each automation capability the documentation describes. Do not capture a capability unrelated to automation.' \
	'4. Group captured platform capabilities that perform the same automation. Judge sameness by meaning.' \
	'5. Title that automation under the Title rule in `.highway/library/templates/output/capability-catalog.md`. Put a product name and a handoff, such as a pull request, a comment, or a ticket, in the evidence.' \
	'6. For a platform, mark each grouped capability that the implementation'"'"'s Realized Capabilities do not already mean as a new realized capability. Judge that by meaning.' \
	'7. Do not propose a capability the documentation no longer describes.' \
	'8. When the documentation cannot be read, say: The current documentation could not be read. Add no capability as current. Mark no new realized capability. Continue from the accepted implementation and the catalogs already present.' \
	'9. Then go to the proposal named with this step.'; do
	line="$(printf '%s\n' "$current" | grep -nxF -- "$step" | head -1 | cut -d: -f1)"
	if [[ -z "$line" ]]; then
		echo "FAIL: highway-codify-config ### current omits: $step"
		fail=1
	elif ((line <= previous)); then
		echo "FAIL: highway-codify-config ### current is out of order at: $step"
		fail=1
	else
		previous="$line"
	fi
done

reject_in "$CONFIG" '### current' 'do not list as a new realized capability'
reject_in "$CONFIG" '### current' '7. Then go to the proposal named with this step.'

words="$(printf '%s\n' "$current" | wc -w | tr -d ' ')"
if [[ -z "$current" ]] || ((words > 400)); then
	echo "FAIL: highway-codify-config ### current has $words words; the limit is 400"
	fail=1
fi

for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
	if printf '%s\n' "$current" | grep -Fiwq -- "$word"; then
		echo "FAIL: highway-codify-config ### current uses: $word"
		fail=1
	fi
done

require "$CONFIG" '- `current` groups the automation capabilities the platform documentation describes by meaning. Each group the implementation does not already mean appears once under New Realized Capabilities, titled under the capability catalog Title rule, with the product and the handoff in the evidence. After the write, configuration follows `highway-implementation` to record them, with the return step `platform written`.'
require "$CONFIG" 'version: 3.5.0'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: current groups realized capabilities by the automation'
