#!/usr/bin/env bash
# One decision can run beside several architectures. Assessment offers ready records. Discovery checks product claims.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring the single-architecture question for a span, or removing the review menu, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
SKILLS="$HW_SKILLS"
OUTPUT="$HW_OUTPUT_TEMPLATES"
ADR="$SKILLS/highway-adr/SKILL.md"
ASSESSMENT="$SKILLS/highway-assessment/SKILL.md"
DISCOVERY="$SKILLS/highway-discovery/SKILL.md"
ADR_RECORD="$OUTPUT/adr-record.md"
DISCOVERY_RECORD="$OUTPUT/discovery-record.md"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") still contains: $text"
		fail=1
	fi
}

require "$ADR" 'list every RA id in the set, in id order, separated by a comma and a space, in the catalog Architecture ID cell'
require "$ADR" 'lists every architecture it names, in id order, separated by a comma and a space.'
require "$ADR" '`None` means a new architecture will follow.'
require "$ADR_RECORD" 'Reference Architecture: <RA id, or `None`>'
require "$ADR_RECORD" 'Its Required Architecture Work is `None`.'
require "$ADR" 'An ADR id appears on at most one row.'
require "$ADR" 'it appears on the row of each architecture it names.'
require "$DISCOVERY_RECORD" 'Product Claim Checks:'
require "$DISCOVERY_RECORD" '`product currency`'
require "$DISCOVERY_RECORD" '`required platform`'
require "$DISCOVERY_RECORD" 'A product claim check is not accepted repository evidence.'

require "$ADR" '### span'
require "$ADR" 'This decision runs beside the current decision of each of these architectures. None of those decisions is replaced, and no new architecture will follow.'
require "$ADR" "If you'd like to leave out any of these architectures, just say so."
require "$ADR" 'An architecture that did not match is not added.'
require "$ADR" 'Which architecture should this decision use?'
require "$ADR" 'Does this decision replace'
require "$ADR" 'in id order, separated by a comma and a space'
require "$ADR" '**Which implementation would you like to codify first?**'
require "$ADR" 'Run `/highway-codify` for **[Implementation title]** to **[Decision title]**.'
require "$ADR" 'is not yet implemented.'
require "$ADR" 'One Discovery has one ADR.'

require "$ASSESSMENT" '### review'
require "$ASSESSMENT" '**What would you like to review?**'
require "$ASSESSMENT" '1. Observed gaps against accepted architectures.'
require "$ASSESSMENT" '2. Accepted artifacts ready for progression to the next stage (requests, discoveries, decisions, architectures, and implementations).'
require "$ASSESSMENT" '### ready records'
require "$ASSESSMENT" '**1. Requests**'
require "$ASSESSMENT" '**a. [Record title]:** Ready for [stage].'
require "$ASSESSMENT" '**Which record would you like to advance?**'
require "$ASSESSMENT" "If you'd like to see more records, just say so."
require "$ASSESSMENT" "If you'd like to return to the main menu, just say so."
require "$ASSESSMENT" 'continue as `highway-codify`'
require "$ASSESSMENT" 'Do not write a ready record to the findings file.'
reject "$ASSESSMENT" '/highway-codify'

require "$DISCOVERY" "If you'd like to select this option for the Decision record, just say so."
require "$DISCOVERY" '- `adopt`: selects the option being explored for the Decision record.'
require "$DISCOVERY" '### check'
require "$DISCOVERY" 'deprecated, retired, or no longer offered'
require "$DISCOVERY" '`inconclusive`'
require "$DISCOVERY" 'Vendor documentation does not count as that support.'
require "$DISCOVERY" 'was left out.'
require "$DISCOVERY" 'Do not run the check'

list_line=$(grep -n '^### review$' "$ASSESSMENT" | cut -d: -f1)
findings_line=$(grep -n '^### list of findings$' "$ASSESSMENT" | cut -d: -f1)
if [[ -z "$list_line" || -z "$findings_line" || "$list_line" -ge "$findings_line" ]]; then
	echo "FAIL: highway-assessment review does not come before list of findings"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: ADR span, assessment review, and discovery checks"
