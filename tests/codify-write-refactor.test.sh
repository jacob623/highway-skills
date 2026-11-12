#!/usr/bin/env bash
# Codify write names the task list template once, and suggestions leave out automations already accepted for the implementation.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring the `[Executor]` bullet in codify `write`, or removing `### codified`, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
CODIFY="$(fl_skill_text_file "$HW_SKILLS/highway-codify")"
fail=0

section() {
	awk -v h="$1" '$0 == h {p=1; next} /^##/ {p=0} p' "$CODIFY"
}

require_in() {
	local name="$1" body="$2" text="$3"
	printf '%s\n' "$body" | grep -Fq -- "$text" || {
		echo "FAIL: highway-codify $name omits: $text"
		fail=1
	}
}

reject_in() {
	local name="$1" body="$2" text="$3"
	if printf '%s\n' "$body" | grep -Fq -- "$text"; then
		echo "FAIL: highway-codify $name still contains: $text"
		fail=1
	fi
}

write_body="$(section '### write')"
codified_body="$(section '### codified')"
verification_body="$(section '## Verification')"
skill_body="$(cat "$CODIFY")"

require_in write "$write_body" 'codify-tasks.md'
require_in write "$write_body" 'Write none of them until all are valid.'
for text in \
	'[Executor]' \
	'Tests: required' \
	'The README task is last.' \
	'Each proposal task is one feature' \
	'Each line names its files'; do
	reject_in write "$write_body" "$text"
done

write_words=$(printf '%s\n' "$write_body" | wc -w | tr -d ' ')
if [[ "$write_words" -gt 250 ]]; then
	echo "FAIL: highway-codify write has $write_words words; the limit is 250"
	fail=1
fi

require_in codified "$codified_body" 'same words, in the same order'
require_in codified "$codified_body" 'Do not open a product folder.'
require_in codified "$codified_body" 'Do not open that record.'
require_in skill "$skill_body" 'Each action grounded in this implementation is already codified.'

rank_line=$(grep -n '^### rank$' "$CODIFY" | cut -d: -f1)
codified_line=$(grep -n '^### codified$' "$CODIFY" | cut -d: -f1)
if [[ -z "$rank_line" || -z "$codified_line" || "$codified_line" -le "$rank_line" ]]; then
	echo "FAIL: highway-codify codified does not follow rank"
	fail=1
fi

require_in Verification "$verification_body" 'Tests: required'
require_in Verification "$verification_body" 'No coding standard applies.'
reject_in Verification "$verification_body" 'The task list holds one group of lines per proposal task'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: codify write names the task list template, and suggestions skip codified automations'
