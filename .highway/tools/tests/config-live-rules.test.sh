#!/usr/bin/env bash
# Config proposals read current documentation, keep Why it matters off the catalog, and return a clean standard write to the menu.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing ### current, or telling the catalog to save a Why it matters line, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG="$HIGHWAY_ROOT/skills/highway-codify-config/SKILL.md"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/coding-standard.md"
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
	awk -v start="$1" -v end="$2" '
		$0 == start { p = 1; next }
		$0 == end { p = 0 }
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
	'does not run `current`' \
	'**Why it matters:**' \
	'The catalog view, a conflict quote, and the saved cell keep the rule only.' \
	'the word must' \
	'encoded or encrypted credentials' \
	'Otherwise state the consequence of the accepted change in one sentence and go to `menu`.' \
	'version: 3.0.0'; do
	require "$CONFIG" "$text"
done

reject "$CONFIG" 'each an imperative a reviewer can check'
reject "$CONFIG" 'Otherwise go to `standards`.'

for name in '### current' '### platform proposal' '### standard proposal'; do
	case "$name" in
		'### current') end='### platform proposal' ;;
		'### platform proposal') end='### standards' ;;
		'### standard proposal') end='### standard write' ;;
	esac
	words="$(section_words "$name" "$end")"
	if [[ "$words" -gt 400 ]]; then
		echo "FAIL: highway-codify-config ${name#\#\#\# } has $words words; the limit is 400"
		fail=1
	fi
done

require "$TEMPLATE" 'version: 3.0.0'
require "$TEMPLATE" 'one rule containing the word must; at most ten rules'
require "$TEMPLATE" 'One rule keeps encoded or encrypted credentials outside the files this standard covers.'
require "$TEMPLATE" 'This file does not contain a Why it matters line.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: config proposals read current documentation and save the rule only'
