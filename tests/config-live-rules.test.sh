#!/usr/bin/env bash
# Config proposals read current documentation, keep Why it matters off the catalog, and return a clean standard write to the menu.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing ### current, or telling the catalog to save a Why it matters line, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
CONFIG="$(fl_skill_text_file "$HW_SKILLS/highway-codify-config")"
TEMPLATE="$(hw_template coding-standard)"
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

section_words() {
	awk -v start="$1" '
		$0 == start { p = 1; next }
		p && /^### / { p = 0 }
		p { c += NF }
		END { print c + 0 }
	' "$CONFIG"
}

current_line="$(grep -n '^### current$' "$CONFIG" | head -1 | cut -d: -f1)"
proposal_line="$(grep -n '^### platform proposal$' "$CONFIG" | head -1 | cut -d: -f1)"
if [[ -z "$current_line" || -z "$proposal_line" || "$current_line" -ge "$proposal_line" ]]; then
	echo "FAIL: ### current does not stand before ### platform proposal"
	fail=1
fi

for text in \
	'### current' \
	'The current documentation could not be read.' \
	'Then go to the proposal named with this step.' \
	'go to `current`, then `platform proposal`' \
	'go to `current`, then `standard proposal`' \
	'Do not run `current`' \
	'**Why it matters:**' \
	'The catalog view, a conflict quote, and the saved cell keep the entry only.' \
	'with must once' \
	'encoded or encrypted credentials' \
	'Otherwise state the consequence of the accepted change in one sentence and go to `menu`.'; do
	require "$CONFIG" "$text"
done

reject "$CONFIG" 'each an imperative a reviewer can check'
reject "$CONFIG" 'Otherwise go to `standards`.'

for name in '### current' '### platform proposal' '### standard proposal'; do
	words="$(section_words "$name")"
	if [[ "$words" -gt 400 ]]; then
		echo "FAIL: highway-codify-config ${name#\#\#\# } has $words words; the limit is 400"
		fail=1
	fi
done

require "$TEMPLATE" 'one rule with must once, one condition, and one outcome, in eight words or fewer; the model suggests at most fifteen'
require "$TEMPLATE" 'One rule keeps encoded or encrypted credentials outside the files this standard covers.'
require "$TEMPLATE" 'This file does not contain a Why it matters line.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: config proposals read current documentation and save the rule only'
