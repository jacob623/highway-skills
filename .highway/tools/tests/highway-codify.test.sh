#!/usr/bin/env bash
# One acceptance writes one automation. A matching request closes with codify.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a choice line that labels an implementation by its id fails this check.

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

CODIFY="$SKILLS/highway-codify/SKILL.md"
REQUEST="$SKILLS/highway-request/SKILL.md"
ASSESSMENT="$SKILLS/highway-assessment/SKILL.md"
RECORD="$OUTPUT/codify-record.md"
CATALOG="$OUTPUT/codify-catalog.md"

for text in \
	'Here is a proposed starting point for your automation:' \
	'What would you add, correct, or remove?' \
	'If this is accurate, just say so.' \
	'CDY' \
	'instance is running' \
	'instances are running' \
	'Establish' \
	'## Implement' \
	'## Use' \
	'code/code.md'; do
	require "$CODIFY" "$text"
done

reject "$CODIFY" '**1. [Implementation ID]:**'

require "$CATALOG" 'More than one row may name the same Implementation ID.'
require "$CATALOG" 'A removed row keeps its id and has no folder.'
require "$RECORD" 'id: CDYXXXXXX'
require "$RECORD" 'Day 1 or Day 2'

require "$REQUEST" 'Run `/highway-codify` for **[Implementation title]** to **[action]**.'
require "$REQUEST" 'Run `/highway-discovery [ID]` to evaluate candidate solutions against your objectives, safeguards, and operational expectations.'
require "$REQUEST" 'Do not state the day.'

require "$ASSESSMENT" 'continue as `highway-request` at `start`'
reject "$ASSESSMENT" '/highway-codify'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
exit 0
