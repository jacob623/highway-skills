#!/usr/bin/env bash
# A coding rule is one must, one condition, and one outcome within eight words, the model suggests at most fifteen, and each rule shows its consequence on the proposal only.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "propose at most ten rules" in highway-codify-config, or removing ### rule shape, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG="$HIGHWAY_ROOT/skills/highway-codify-config/SKILL.md"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/coding-standard.md"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require() {
	grep -Fq -- "$2" "$1" || {
		echo "FAIL: $(basename "$1") omits: $2"
		fail=1
	}
}

reject() {
	if grep -Fq -- "$2" "$1"; then
		echo "FAIL: $(basename "$1") still contains: $2"
		fail=1
	fi
}

require_in() {
	section "$1" "$2" | grep -Fq -- "$3" || {
		echo "FAIL: highway-codify-config $2 omits: $3"
		fail=1
	}
}

check_words() {
	local heading="$1" limit="$2" body words
	body="$(section "$CONFIG" "$heading")"
	words="$(printf '%s\n' "$body" | wc -w | tr -d ' ')"
	if [[ -z "$body" ]] || ((words > limit)); then
		echo "FAIL: highway-codify-config $heading has $words words; the limit is $limit"
		fail=1
	fi
}

shape="$(section "$CONFIG" '### rule shape')"
previous=0
for step in \
	'1. Write one rule with must once, one condition, and one outcome, in eight words or fewer. Count a path, a hyphenated word, and a placeholder as one word.' \
	'2. A second outcome joined by and, or, or a comma is a separate rule. A slash that is part of a path stays inside that one word.' \
	'3. When a rule the person provides, or a saved rule, lacks must, has more than eight words, or combines rules, rewrite it to conform before the proposal is presented. State that rewrite in the consequence sentence that opens the proposal. Keep a saved rule that conforms.' \
	'4. Under each rule, emit **Why it matters:** and one sentence stating the consequence of that rule. Name no customer, product, or decision of this organization. The catalog view, a conflict quote, and the saved cell keep the rule only.' \
	'5. Return to `standard rules`.'; do
	line="$(printf '%s\n' "$shape" | grep -nxF -- "$step" | head -1 | cut -d: -f1)"
	if [[ -z "$line" ]]; then
		echo "FAIL: highway-codify-config ### rule shape omits: $step"
		fail=1
	elif ((line <= previous)); then
		echo "FAIL: highway-codify-config ### rule shape is out of order at: $step"
		fail=1
	else
		previous="$line"
	fi
done

rules_line="$(grep -nxF '### standard rules' "$CONFIG" | head -1 | cut -d: -f1)"
shape_line="$(grep -nxF '### rule shape' "$CONFIG" | head -1 | cut -d: -f1)"
proposal_line="$(grep -nxF '### standard proposal' "$CONFIG" | head -1 | cut -d: -f1)"
if [[ -z "$rules_line" || -z "$shape_line" || -z "$proposal_line" ]] || ((rules_line >= shape_line || shape_line >= proposal_line)); then
	echo 'FAIL: highway-codify-config does not order standard rules, rule shape, then standard proposal'
	fail=1
fi
between="$(awk -v a="$shape_line" -v b="$proposal_line" 'NR > a && NR < b && /^### /' "$CONFIG")"
if [[ -n "$between" ]]; then
	echo "FAIL: highway-codify-config has a heading between rule shape and standard proposal: $between"
	fail=1
fi

require_in "$CONFIG" '### standard rules' '1. When no standard file exists, suggest at most fifteen rules from the documentation `current` read. Use the file and folder structure that documentation recommends.'
require_in "$CONFIG" '### standard rules' '3. Follow `rule shape`, then write the rules it returned. When the suggestions exceed fifteen, keep the credentials rule, leave out the later suggestions, and name each left-out suggestion in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.'
require_in "$CONFIG" '### standard rules' "5. Include one rule, once, that keeps encoded or encrypted credentials outside this standard's files. When the documentation names a supported way to encrypt or store them, require that way in its own rule. Both follow \`rule shape\`. When it names none, name no product."
require_in "$CONFIG" '### standard rules' '6. When fifteen suggestions lack the credentials rule, leave out the last suggestion the documentation no longer describes, or the last suggestion when all are still described. Name it in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.'
require_in "$CONFIG" '### standard rules' '9. Return to `standard proposal`.'

proposal="$(section "$CONFIG" '### standard proposal')"
block_line="$(printf '%s\n' "$proposal" | grep -nxF '**Coding Standards:**' | head -1 | cut -d: -f1)"
if [[ -z "$block_line" ]]; then
	echo 'FAIL: highway-codify-config standard proposal omits **Coding Standards:**'
	fail=1
else
	block="$(printf '%s\n' "$proposal" | awk -v s="$block_line" 'NR > s && NR <= s + 3')"
	expected="$(printf '%s\n%s\n%s' '1. [Rule]' '' '   **Why it matters:** [One sentence stating the consequence of this rule.]')"
	if [[ "$block" != "$expected" ]]; then
		echo 'FAIL: highway-codify-config standard proposal does not show each rule, a blank line, then Why it matters'
		fail=1
	fi
fi

for text in \
	'propose at most ten rules' \
	'Write each rule with the word must, naming a condition and the required outcome.' \
	'When ten current rules lack the credentials rule'; do
	reject "$CONFIG" "$text"
done

check_words '### rule shape' 250
check_words '### standard rules' 250
check_words '### standard proposal' 400

for heading in '### rule shape' '### standard rules'; do
	for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
		if section "$CONFIG" "$heading" | grep -Fiwq -- "$word"; then
			echo "FAIL: highway-codify-config $heading uses: $word"
			fail=1
		fi
	done
done

require "$TEMPLATE" '1. <one rule with must once, one condition, and one outcome, in eight words or fewer; the model suggests at most fifteen>'
require "$TEMPLATE" 'This file does not contain a Why it matters line.'
reject "$TEMPLATE" 'at most ten rules'

require "$CONFIG" '- Each coding rule is one must, one condition, and one outcome in eight words or fewer. The model suggests at most fifteen, and one keeps encoded or encrypted credentials outside the files. A provided rule that does not conform is rewritten, and the opening consequence sentence names the rewrite. Each rule shows **Why it matters:** on the proposal only.'
require "$CONFIG" 'version: 3.3.0'
require "$TEMPLATE" 'version: 3.0.1'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: a coding rule is one must within eight words'
