#!/usr/bin/env bash
# Controls and NFRs review the whole queue once, in the same card as stored records.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: absence of the batch heading or return of the one-at-a-time bridge fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")") omits: $text"
		fail=1
	}
}

forbid() {
	local file="$1" text="$2"
	if grep -Fq "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")") still contains: $text"
		fail=1
	fi
}

check_skill() {
	local skill="$1" heading="$2" between="$3" singular="$4"
	require "$skill" "$heading"
	require "$skill" '**[Title]:** [Statement]'
	require "$skill" '**Why it matters:**'
	require "$skill" "$between"
	forbid "$skill" "$singular"
	forbid "$skill" "Next we'll develop"
	forbid "$skill" '**Success looks like:**'
}

check_skill \
	"$(fl_skill_text_file "$HW_SKILLS/highway-controls")" \
	"**Here's what I've captured as your controls:**" \
	'Put `---` between Controls.' \
	"**Here's what I've captured as your Control:**"

check_skill \
	"$(fl_skill_text_file "$HW_SKILLS/highway-nfrs")" \
	"**Here's what I've captured as your NFRs:**" \
	'Put `---` between NFRs.' \
	"**Here's what I've captured as your NFR:**"

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: control and NFR batch acceptance"
