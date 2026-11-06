#!/usr/bin/env bash
# Config steps follow the flow as numbered steps, each yes or no ask states every reply, and each standard proposal opens as a starting point.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "Assess conflicts as `platform proposal` does." in highway-codify-config, or removing ### standard rules, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG="$HIGHWAY_ROOT/skills/highway-codify-config/SKILL.md"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require() {
	grep -Fq -- "$2" "$1" || {
		echo "FAIL: $(basename "$(dirname "$1")") omits: $2"
		fail=1
	}
}

reject() {
	if grep -Fq -- "$2" "$1"; then
		echo "FAIL: $(basename "$(dirname "$1")") still contains: $2"
		fail=1
	fi
}

require_in() {
	section "$1" "$2" | grep -Fq -- "$3" || {
		echo "FAIL: $(basename "$(dirname "$1")") $2 omits: $3"
		fail=1
	}
}

replies='`question` answers, then asks again. `unknown` asks again.'

require_in "$CONFIG" '### Classify' 'Classify the latest reply before any other action. Test the classes in this order and stop at the first match.'
require_in "$CONFIG" '### Classify' '1. `edit`: adds, removes, corrects, or replaces proposal text, or names a record to add, correct, or remove.'
require_in "$CONFIG" '### Classify' '2. `decline`: answers no, stops, or cancels.'
require_in "$CONFIG" '### Classify' '3. `question`: asks for an explanation.'
require_in "$CONFIG" '### Classify' '4. `select`: names a listed option, conflict, platform, or standard by number or title.'
require_in "$CONFIG" '### Classify' '5. `unknown`: the person says they do not know.'
require_in "$CONFIG" '### Classify' '6. `accept`: affirms the proposal or answers yes, and adds no fact.'
require_in "$CONFIG" '### Classify' 'On a proposal, "looks good" is `accept`.'

require_in "$CONFIG" '### platforms' '1. When Entry carried a platform name, apply the name bullets below to that name. Do not emit the list or its question.'
require_in "$CONFIG" '### platforms' '2. Otherwise read `library/coding-standards/codify-platforms.md` when present. Emit one item per row, in file order. Do not use an id as the label.'
require_in "$CONFIG" '### platforms' '  - `decline`: emit this list and its question.'
require_in "$CONFIG" '### platforms' '  - `question`: answer, then ask **Would you like to onboard [Platform]?** again.'
require_in "$CONFIG" '### platforms' '  - `unknown`: ask **Would you like to onboard [Platform]?** again.'

require_in "$CONFIG" '### platform proposal' '3. Fill this proposal.'
require_in "$CONFIG" '### platform proposal' '4. Assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance. With none, show `None`. When any exist, add: You can accept this proposal with these conflicts and resolve them afterward.'
require_in "$CONFIG" '### platform proposal' '5. List each capability `current` marked new under New Realized Capabilities. With none, show `None`.'
require_in "$CONFIG" '### platform proposal' '6. Emit this proposal, then the closing question and the cancel line.'

require_in "$CONFIG" '### platform written' '1. When the accepted proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. '"$replies"
require_in "$CONFIG" '### platform written' '2. Otherwise, when the platform works with code or configuration files, ask **Would you like to configure coding standards for [Platform]?** `accept` goes to `standards` with [Platform] as the standard to add or update. '"$replies"
require_in "$CONFIG" '### platform written' '3. Otherwise, or after `decline`, go to `platforms`.'

require_in "$CONFIG" '### standard rules' '1. When no standard file exists, propose at most ten rules from the documentation `current` read. Use the file and folder structure that documentation recommends.'
require_in "$CONFIG" '### standard rules' '2. Otherwise start from the standard file after `current`, including a standard re-added after removal.'
require_in "$CONFIG" '### standard rules' '3. Write each rule with the word must, naming a condition and the required outcome.'
require_in "$CONFIG" '### standard rules' '4. For a platform standard, inherit from the language standards its files use.'
require_in "$CONFIG" '### standard rules' "5. Include one rule, once, that keeps encoded or encrypted credentials outside this standard's files. When the documentation names a supported way to encrypt or store them, require that way. When it names none, name no product."
require_in "$CONFIG" '### standard rules' '6. When ten current rules lack the credentials rule, leave out the last rule the documentation no longer describes, or the last rule when all are still described. Name it in Consequences.'
require_in "$CONFIG" '### standard rules' '7. Write every structure path relative to the automation folder. Fill a placeholder in angle brackets, such as `<module>`, for each automation.'
require_in "$CONFIG" '### standard rules' "8. Cover only this standard's own files in the structure. Leave a component the platform calls, such as a module, to its own standard."
require_in "$CONFIG" '### standard rules' '9. Return to `standard proposal`.'

require_in "$CONFIG" '### standard proposal' '1. For an add or update, follow `standard rules`.'
require_in "$CONFIG" '### standard proposal' '2. For an add or update, follow `use entries`.'
require_in "$CONFIG" '### standard proposal' '3. For a remove, show the current values. Do not run `current`, `standard rules`, or `use entries`.'
require_in "$CONFIG" '### standard proposal' '4. Fill this proposal.'
require_in "$CONFIG" '### standard proposal' '[On an add or update with no edit yet: **Here is a proposed starting point for the [Language or platform] coding standards**]'
require_in "$CONFIG" '### standard proposal' '5. Assess conflicts as `conflicts` does, against the catalogs as they would be after acceptance. With none, show `None`. When any exist, add: You can accept this proposal with these conflicts and resolve them afterward.'
require_in "$CONFIG" '### standard proposal' '6. For a remove, say in Consequences that `[Standard Path]` remains and is no longer used. List in Conflicts each standard whose Inherits From names it.'
require_in "$CONFIG" '### standard proposal' '7. Emit this proposal, then the closing question and the cancel line.'
require_in "$CONFIG" '### standard proposal' '- `edit`: emit one consequence sentence. Re-emit this proposal with the change and without the starting-point line. Stay on `standard proposal`.'

proposal="$(section "$CONFIG" '### standard proposal')"
consequence="$(printf '%s\n' "$proposal" | grep -nF '[One sentence stating the consequence of this change.]' | head -1 | cut -d: -f1)"
starting="$(printf '%s\n' "$proposal" | grep -nF '**Here is a proposed starting point for the' | head -1 | cut -d: -f1)"
title="$(printf '%s\n' "$proposal" | grep -nF '**Standard Title:** [Language or platform] Coding Standard' | head -1 | cut -d: -f1)"
if [[ -z "$consequence" || -z "$starting" || -z "$title" ]] || ((consequence >= starting || starting >= title)); then
	echo 'FAIL: highway-codify-config standard proposal does not order the consequence, the starting-point line, then Standard Title'
	fail=1
fi

require_in "$CONFIG" '### standard write' '3. When the proposal listed conflicts, ask **Would you like help resolving these conflicts?** `accept` goes to `conflicts`. '"$replies"' `decline` states the consequence of the accepted change in one sentence and goes to `menu`. Otherwise state the consequence of the accepted change in one sentence and go to `menu`.'

require_in "$CONFIG" '### conflicts' '1. Read both catalogs.'
require_in "$CONFIG" '### conflicts' '2. Assess platforms first, then standards, each in catalog order. Judge overlap by meaning, not exact wording. A conflict is:'
require_in "$CONFIG" '### conflicts' '3. When none exist, emit `Highway found no conflicts between your platforms and coding standards.` Then ask **What inconsistencies have you noticed?** Assess what the person describes against the catalogs, then re-emit this step.'
require_in "$CONFIG" '### conflicts' '4. Otherwise quote both entries and name both records in each description. Emit each conflict as an ordered list item, then the question and the cancel line.'

require_in "$CONFIG" '### resolve' '1. Propose the fewest changes that remove the selected conflict, starting from its recommendation.'
require_in "$CONFIG" '### resolve' '2. List each record once, in bold, with a lettered list of its changes.'
require_in "$CONFIG" '### resolve' '3. Fill this proposal.'
require_in "$CONFIG" '### resolve' '4. Emit this proposal, then the closing question and the cancel line.'

reject "$CONFIG" 'Assess conflicts as `platform proposal` does.'
reject "$CONFIG" 'Each rule contains the word must and names a condition and the required outcome.'
reject "$CONFIG" 'Then emit the closing question and the cancel line.'

previous=0
for heading in '### Entry' '### Classify' '### menu' '### platforms' '### current' '### use entries' '### platform proposal' '### platform written' '### standards' '### standard rules' '### standard proposal' '### standard write' '### conflicts' '### resolve'; do
	line="$(grep -nxF -- "$heading" "$CONFIG" | head -1 | cut -d: -f1)"
	if [[ -z "$line" ]] || ((line <= previous)); then
		echo "FAIL: highway-codify-config $heading is missing or out of order"
		fail=1
	else
		previous="$line"
	fi
done

check_words() {
	local heading="$1" limit="$2" words
	words="$(section "$CONFIG" "$heading" | wc -w | tr -d ' ')"
	if [[ -z "$(section "$CONFIG" "$heading")" ]] || ((words > limit)); then
		echo "FAIL: highway-codify-config $heading has $words words; the limit is $limit"
		fail=1
	fi
}

check_words '### standard rules' 250
for heading in '### Classify' '### platform proposal' '### standard proposal' '### conflicts' '### resolve'; do
	check_words "$heading" 400
done

for heading in '### Classify' '### platforms' '### platform proposal' '### platform written' '### standard rules' '### standard proposal' '### standard write' '### conflicts' '### resolve'; do
	for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
		if section "$CONFIG" "$heading" | grep -Fiwq -- "$word"; then
			echo "FAIL: highway-codify-config $heading uses: $word"
			fail=1
		fi
	done
done

require "$CONFIG" 'version: 3.2.1'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: config steps are ordered, numbered, and open each standard proposal as a starting point'
