#!/usr/bin/env bash
# The README is headed Setup Instructions and User Guide. A finished run closes with the completion message. The code catalog lists recent automations.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a README sentence that heads the first part `## Implement` fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
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

reject_line() {
	local file="$1" text="$2"
	if grep -Fxq -- "$text" "$file"; then
		echo "FAIL: $(basename "$file") still contains the line: $text"
		fail=1
	fi
}

CODIFY="$SKILLS/highway-codify/SKILL.md"
RECORD="$OUTPUT/codify-record.md"
CATALOG="$OUTPUT/codify-catalog.md"

for text in \
	'Head the first part `## Setup Instructions` and the second part `## User Guide`.' \
	'### The codify stage is complete.' \
	'This code is now part of your Highway knowledge base.' \
	'The automation was not run.' \
	'**The files can be found here:**' \
	"If you'd like to review the files together, just say so." \
	'**Setup and Usage Instructions** can be found here:' \
	"If you'd like to review the instructions together, just say so." \
	'just ask highway to show your code catalog' \
	'Run /highway-help to explore what Highway can help you do.' \
	'### catalog' \
	'When the invocation is the word `catalog`' \
	'**Which automation would you like to discuss?**' \
	'more automations are not shown.' \
	'1 more automation is not shown.' \
	'You can name or describe any automation.' \
	'No automation has been created yet.' \
	'The instructions are not written yet.' \
	'Append the new row as the last row.' \
	'version: 9.0.1'; do
	require "$CODIFY" "$text"
done
for text in \
	'`## Implement`' \
	'`## Use`' \
	'Order the index by Automation ID.' \
	'[Every task is done. Or: Task'; do
	reject "$CODIFY" "$text"
done

require "$RECORD" '## Setup Instructions'
require "$RECORD" '## User Guide'
require "$RECORD" 'User Guide follows the interface of the Provider.'
require "$RECORD" 'version: 7.0.0'
reject_line "$RECORD" '## Implement'
reject_line "$RECORD" '## Use'

require "$CATALOG" 'Rows are in acceptance order.'
require "$CATALOG" 'A new row is appended as the last row.'
require "$CATALOG" 'version: 2.0.0'
reject "$CATALOG" 'Rows are ordered by Automation ID.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: codify closing guide, README headings, and catalog view'
exit 0
