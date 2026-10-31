#!/usr/bin/env bash
# An ADR states its problem, scope, alternatives, revisit condition, typed links, and the architecture and implementation it produced.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring Selection Status or a handoff Selected Option in the ADR template fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
RECORD="$OUTPUT/adr-record.md"
CATALOG="$OUTPUT/adr-catalog.md"
ADR="$SKILLS/highway-adr/SKILL.md"
ONBOARDING="$SKILLS/highway-onboarding/SKILL.md"
ARCHITECTURE="$SKILLS/highway-architecture/SKILL.md"
IMPLEMENTATION="$SKILLS/highway-implementation/SKILL.md"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$file") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$file") still contains: $text"
		fail=1
	fi
}

for text in \
	'status: accepted | superseded' \
	'Problem: <the problem this decision responds to>' \
	'Forces: <the forces that make the decision necessary>' \
	'## Decision Scope' \
	'Covers: <what this decision decides>' \
	'Leaves Open: <what this decision does not decide, or `None`>' \
	'## Revisit When' \
	'Definition: <what this option is>' \
	'Outcome: <Selected, Rejected, or Evaluated>' \
	'- OBJXXXXXX: advances' \
	'- CTLXXXXXX: bound by' \
	'- NFRXXXXXX: satisfies' \
	'Reference Architecture: <RA id, or `None`>' \
	'Authorization to Proceed: Proceed to Reference Architecture; do not implement.' \
	'is `Accepted onboarding mapping`' \
	'The record contains no' \
	'Alternatives Considered lists every option, including the selected one.'; do
	require "$RECORD" "$text"
done
reject "$RECORD" 'Selection Status'
reject "$RECORD" 'Candidate Solution Options'
handoff="$(sed -n '/^## Reference Architecture Handoff$/,/^```$/p' "$RECORD")"
for text in 'Selected Option:' 'Reference Architecture Matches:' 'Reference Implementation:'; do
	if printf '%s\n' "$handoff" | grep -Fq -- "$text"; then
		echo "FAIL: adr-record.md handoff still contains: $text"
		fail=1
	fi
done

require "$CATALOG" '<accepted, superseded, or removed>'
require "$CATALOG" '`superseded` has a record at `adrs/<id>.md`'
reject "$CATALOG" '<accepted or removed>'

for text in \
	'`## Context` states the problem this decision responds to and the forces that make it necessary' \
	'`## Decision Scope` states what the decision covers and what it leaves open' \
	'`## Revisit When` states the condition that should cause the decision to be reopened' \
	'The selected option is `Selected`.' \
	'Do not repeat the selected option or the matches there.' \
	'Do not write an implementation entry.' \
	'Status is `superseded` in the record and in the catalog exactly when `superseded_by` names an ADR.'; do
	require "$ADR" "$text"
done
reject "$ADR" 'names the selected option, the copied matches'

for text in \
	'Selection Source as `Accepted onboarding mapping`' \
	'Head each alternative by its name' \
	'Do not write an option id.' \
	'set the ADR'"'"'s `Reference Architecture` field to its id' \
	'does not name an implementation'; do
	require "$ONBOARDING" "$text"
done

require "$ARCHITECTURE" "Do not change the ADR, except its Reference Architecture field."
require "$ARCHITECTURE" '.highway/library/templates/output/adr-record.md'
require "$ARCHITECTURE" '### name'
require "$ARCHITECTURE" 'running `/highway-architecture [ADR id]` again will name it.'
require "$ARCHITECTURE" 'Do not call the decision, architecture, and implementation chain complete.'
require "$ARCHITECTURE" 'is still `None`, go to `name`.'
reject "$ARCHITECTURE" 'Do not change the ADR, Discovery'
require "$IMPLEMENTATION" 'Do not change the ADR.'
reject "$IMPLEMENTATION" 'Reference Implementation field'
reject "$IMPLEMENTATION" 'Do not change the architecture, ADR,'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: ADR record completeness"
