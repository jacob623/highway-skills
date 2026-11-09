#!/usr/bin/env bash
# Codify matches a platform, a standard, and a Control by name, and gives each proposal task its own story.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing `### rank` or `### provider` from highway-codify, or restoring `the story it delivers`, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CODIFY="$HIGHWAY_ROOT/skills/highway-codify/SKILL.md"
PLAN="$HIGHWAY_ROOT/library/templates/output/codify-plan.md"
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
for step in 'record check' rank codified 'code project' suggest draft 'code tasks' provider standards align govern resume join folder layout plan check tasks; do
	line=$(grep -n "^### $step\$" "$CODIFY" | head -n 1 | cut -d: -f1)
	if [[ -z "$line" || "$line" -le "$previous" ]]; then
		echo "FAIL: highway-codify ### $step is missing or out of order"
		fail=1
		line=$previous
	fi
	previous=$line
done

require_in rank 'Go to `suggest`.'
require_in provider 'The Executor is Deployed by'
require_in provider 'Do not copy the Executor onto a task'
require_in provider 'Do not take this implementation'"'"'s row or the first catalog row.'
require_in standards 'File Patterns match a file the method names'
require_in standards 'appears on its own'
require_in govern 'the task'"'"'s target'
require_in govern 'the mechanism that realization names'
require_in layout 'Add a new match.'
require_in plan 'One story per proposal task, in task order.'
require_in plan 'The title is that task'"'"'s action.'
require_in plan 'Done when is the earliest such criterion.'
require_in check 'A story with no Done when'
require_in check 'Ask the first five'
require_in tasks 'the story whose title is that task'"'"'s action'
require "$CODIFY" 'version: 14.0.0'
require "$PLAN" 'version: 2.0.0'
require "$PLAN" 'The title is that task'"'"'s action.'
reject "$CODIFY" 'The accepted proposal is not copied.'
reject "$CODIFY" 'the story it delivers'
reject "$CODIFY" 'change the most stories'
reject "$CODIFY" 'whose When to use fits'

for step in rank suggest draft provider resume join folder; do
	words=$(section "### $step" | awk '{c+=NF} END{print c+0}')
	if [[ "$words" -gt 250 ]]; then
		echo "FAIL: highway-codify $step has $words words; the limit is 250"
		fail=1
	fi
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
echo 'PASS: codify matches rows and stories by name'
