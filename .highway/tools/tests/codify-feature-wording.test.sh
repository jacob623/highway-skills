#!/usr/bin/env bash
# Codify applies Controls and NFRs, writes a plan after acceptance, and writes the task list when the person continues.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing `### govern` or `### plan` from highway-codify, or restoring `for your automation:**`, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
CODIFY="$HIGHWAY_ROOT/skills/highway-codify/SKILL.md"
RECORD="$OUTPUT/codify-record.md"
TASKS="$OUTPUT/codify-tasks.md"
PLAN="$OUTPUT/codify-plan.md"
fail=0

require() {
	local file="$1" text="$2"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: $(basename "$file") is missing"
		fail=1
		return
	fi
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$file") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if [[ -f "$file" ]] && grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$file") still contains: $text"
		fail=1
	fi
}

section() {
	awk -v h="$1" '$0 == h {p=1; next} /^##/ {p=0} p' "$CODIFY"
}

require_in() {
	local name="$1" text="$2"
	section "### $name" | grep -Fq -- "$text" || {
		echo "FAIL: highway-codify $name omits: $text"
		fail=1
	}
}

previous=0
for step in align govern resume join folder propose revise write index plan check menu tasks code close; do
	line=$(grep -n "^### $step\$" "$CODIFY" | head -n 1 | cut -d: -f1)
	if [[ -z "$line" || "$line" -le "$previous" ]]; then
		echo "FAIL: highway-codify ### $step is missing or out of order"
		fail=1
		line=$previous
	fi
	previous=$line
done

require_in align 'go to `govern`'
require_in govern 'library/governance/controls.md'
require_in govern 'library/governance/nfrs.md'
require_in govern 'Skip a removed row.'
require_in govern 'No Control or NFR applies.'
require_in govern 'When a coding standard disagrees, the Control or NFR wins.'
require_in govern 'When a Control and an NFR disagree, apply the Control.'
require_in govern 'apply the earlier catalog row'
require_in govern '[Applied title] is applied. [Other title] disagrees.'
require_in govern 'Show no proposal. Return to `suggest`.'
require_in propose '**Here is a proposed starting point for your codify feature:**'
require_in propose '**Controls and NFRs:**'
require_in propose '**Conflicts:**'
require_in propose 'Highway will use this specification to build out the solution.'
require_in revise 'stays in effect. To change a Control, run /highway-controls. To change an NFR, run /highway-nfrs.'
require_in write 'Do not write `codify-tasks.md` here.'
require_in write '**Controls and NFRs:**'
require_in index 'On success, go to `plan`'
require_in plan '.highway/library/templates/output/codify-plan.md'
require_in plan 'The plan holds one story per proposal task, so a review of it is the whole plan.'
require_in plan 'One story per proposal task, in task order.'
require_in plan "The title is that task's action."
reject "$CODIFY" 'Leave out a story that restates a proposal task.'
require_in plan 'Each applied Control or NFR names the story that carries it.'
require_in check 'Ask the first five'
require_in check 'one at a time.'
require_in check 'Do not say the check ran.'
require_in menu 'The plan is complete for feature <number>-<action>. **Would you like to:**'
require_in menu '1. Review the plan?'
require_in menu '2. Continue to code the solution?'
require_in menu '`2`: go to `tasks`.'
require_in tasks 'Highway is now building out this solution. We can review, discuss, and revise it afterward, and continue refining it as requirements evolve.'
require_in tasks 'Do not emit the sentence again.'
require_in tasks "the story whose title is that task's action"
require_in tasks 'Leave out a line that names work the proposal does not list.'
require_in tasks 'On success, go to `code` without asking a question.'
reject "$CODIFY" 'When a task serves no story, leave it out.'
require_in code 'whose catalog row is active'
require "$CODIFY" 'To revisit this in the future, just ask Highway to show your Code Catalog. We can review, discuss, and revise any of your solutions, and continue refining them as requirements evolve.'

require "$CODIFY" 'version: 14.1.0'
require "$CODIFY" '.highway/library/templates/output/codify-plan.md'
reject "$CODIFY" '**Here is a proposed starting point for your automation:**'
reject "$CODIFY" 'just ask highway to show your code catalog'

require "$RECORD" 'version: 9.1.0'
require "$RECORD" '**Controls and NFRs:**'
require "$RECORD" '**Conflicts:**'
require "$TASKS" 'version: 6.0.0'
require "$TASKS" '## Story 1:'
require "$TASKS" 'Independent test:'
require "$PLAN" 'version: 2.0.0'
for heading in '## Stories' '## Edge Cases' '## Functional Requirements' '## Decisions'; do
	require "$PLAN" "$heading"
done

for step in govern plan check menu tasks; do
	if section "### $step" | grep -Eiwq 'should|consider|prefer|usually|where appropriate'; then
		echo "FAIL: highway-codify $step uses a soft word"
		fail=1
	fi
done

over=$(awk '/^### /{if(n && c>400)print n": "c; n=$0; c=0; next} /^## /{if(n && c>400)print n": "c; n=""; next} n{c+=NF} END{if(n && c>400)print n": "c}' "$CODIFY")
if [[ -n "$over" ]]; then
	echo "FAIL: highway-codify step over 400 words: $over"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: codify plans the feature before coding'
