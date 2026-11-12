#!/usr/bin/env bash
# One acceptance writes one automation. A matching request closes with codify.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a choice line that labels an implementation by its id fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
SKILLS="$HW_SKILLS"
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

CODIFY="$(fl_skill_text_file "$SKILLS/highway-codify")"
REQUEST="$(fl_skill_text_file "$SKILLS/highway-request")"
ASSESSMENT="$(fl_skill_text_file "$SKILLS/highway-assessment")"
RECORD="$(hw_template codify-record)"
TASKS="$(hw_template codify-tasks)"
STANDARDS_CATALOG="$HW_ROOT/library/coding-standards/coding-standards.md"
SAMPLE_STANDARD="$HW_ROOT/library/coding-standards/terraform.md"
MANIFEST="$HW_FRAMEWORK/.distribution-manifest"

for text in \
	'Here is a proposed starting point for your codify feature:' \
	'What would you add, correct, or remove?' \
	'If this is accurate, just say so.' \
	'CDY' \
	'instance is running' \
	'instances are running' \
	'Establish' \
	'## Setup Instructions' \
	'## User Guide' \
	'code/code.md' \
	'Would you like to explore any of these options?' \
	"If you have another idea, provide a brief description and we'll work through it together." \
	'```flowchart' \
	'**Scope:**' \
	'**Provider:**' \
	'**Method:**' \
	'**Assumptions:**' \
	'codify-tasks.md' \
	'library/coding-standards/coding-standards.md' \
	'No coding standard applies.' \
	'Tests: required' \
	'first open task'; do
	require "$CODIFY" "$text"
done

require "$TASKS" 'product: CDYXXXXXX'
require "$TASKS" '- [ ] T001'
for seeded in "$STANDARDS_CATALOG" "$SAMPLE_STANDARD"; do
	if [[ -e "$seeded" ]]; then
		echo "FAIL: $(basename "$seeded") is still seeded"
		fail=1
	fi
done
reject "$MANIFEST" 'include	library/coding-standards	-'

reject "$CODIFY" '**1. [Implementation ID]:**'
reject "$CODIFY" 'You can also provide your own.'

require "$CODIFY" 'More than one row may name the same Implementation ID.'
require "$CODIFY" 'A removed row keeps its id and has no folder.'
require "$RECORD" 'id: CDYXXXXXX'
reject "$RECORD" '## Day'
for text in \
	'## Summary' \
	'## Description' \
	'## Diagram' \
	'## Acceptance Criteria' \
	'## Tasks'; do
	require "$RECORD" "$text"
done

require "$REQUEST" 'Run `highway-codify` for **[Implementation title]** to **[action]**.'
require "$REQUEST" 'Run `highway-discovery [ID]` to evaluate candidate solutions against your objectives, safeguards, and operational expectations.'
require "$REQUEST" 'Do not state the day.'

require "$ASSESSMENT" 'continue as `highway-request` at `start`'
reject "$ASSESSMENT" 'Run `highway-codify`'
reject "$ASSESSMENT" 'run highway-codify'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
exit 0
