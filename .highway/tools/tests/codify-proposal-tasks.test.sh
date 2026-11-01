#!/usr/bin/env bash
# Codify suggests actions, checks standards then sources, and proposes ordered tasks.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring Components, Day, or Means in the proposal, or a left-to-right diagram, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
CODIFY="$SKILLS/highway-codify/SKILL.md"
ADR="$SKILLS/highway-adr/SKILL.md"
RECORD="$OUTPUT/codify-record.md"
TASKS="$OUTPUT/codify-tasks.md"
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

for text in \
	'automating these tasks may be worth visiting:**' \
	"If you have another idea, provide a brief description and we'll work through it together." \
	'### align' \
	'### propose' \
	'flowchart TB' \
	'**Tasks:**' \
	'**Scope:**' \
	'**Provider:**' \
	'**Method:**' \
	'**Assumptions:**' \
	'cannot be met for'; do
	require "$CODIFY" "$text"
done

for text in \
	'this implementation, these may be worth visiting' \
	'**Components:**' \
	'**Current state:**' \
	'**Day:**' \
	'**Means:**' \
	'flowchart LR'; do
	reject "$CODIFY" "$text"
done

require "$RECORD" '## Tasks'
require "$RECORD" 'flowchart TB'
for text in '## Components' '## Current State' '## Action' '## Day' '## Means'; do
	reject "$RECORD" "$text"
done

require "$TASKS" '[Executor]'
require "$TASKS" '[Task N]'

require "$ADR" "that automation's title is this decision's title"
reject "$ADR" "that automation's \`## Action\`"

align_line=$(grep -n '^### align$' "$CODIFY" | cut -d: -f1)
propose_line=$(grep -n '^### propose$' "$CODIFY" | cut -d: -f1)
if [[ -z "$align_line" || -z "$propose_line" || "$align_line" -ge "$propose_line" ]]; then
	echo "FAIL: highway-codify align does not come before propose"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: codify action suggestions, checks, and task proposal"
