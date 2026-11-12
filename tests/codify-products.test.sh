#!/usr/bin/env bash
# Codify places each feature in a product folder and decides join or start from the catalogs.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring `code/[ID]/` in highway-codify, or removing `### resume`, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
SKILLS="$HW_SKILLS"
CODIFY="$(fl_skill_text_file "$SKILLS/highway-codify")"
ADR="$(fl_skill_text_file "$SKILLS/highway-adr")"
CATALOG="$(hw_template codify-catalog)"
RECORD="$(hw_template codify-record)"
TASKS="$(hw_template codify-tasks)"
METADATA="$(hw_template codify-metadata)"
INTEGRATIONS="$(hw_template codify-integrations)"
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
for step in align resume join folder layout propose revise identifier write index code; do
	line=$(grep -n "^### $step\$" "$CODIFY" | head -n 1 | cut -d: -f1)
	if [[ -z "$line" || "$line" -le "$previous" ]]; then
		echo "FAIL: highway-codify ### $step is missing or out of order"
		fail=1
		line=$previous
	fi
	previous=$line
done

for text in \
	'Read the accepted rows of `code/code.md` and `code/integrations.md`. Skip removed rows. Do not open a product folder.' \
	'1. When the person named a folder, use it.'; do
	require_in resume "$text"
done
for text in \
	'Read the matching coding standard. When one of its rules names where this action lives, that rule replaces the decision below.' \
	'when both sides have products, join the folder of the implementation being codified. Leave the other folder in place.' \
	'when neither side has a product, start one folder and list both implementations.' \
	'For a capability row whose From is the selected implementation, join the product that lists From. Add To to its implementations.' \
	'When a product Summary means the same consumer and outcome and this action is new, join that folder.'; do
	require_in join "$text"
done
for text in \
	'When that folder is already a catalog path, say it is taken and ask for another name.' \
	'The first sentence says in plain words why this folder is the right home.' \
	'When a standard or integration replaced the decision, cite it after that sentence.'; do
	require_in folder "$text"
done

require_in codified 'Do not open a product folder.'
require_in codified 'An integration row does not leave a suggestion out.'
require_in propose '**Proposed project:**'
require_in propose '**Rationale:**'
require_in propose 'No arrow leaves a target.'
require_in propose 'Go to `revise`.'
require_in revise 'An edit that changes the proposed project uses that folder.'
require_in revise 'Stay on `revise`.'
require_in write '.highway/metadata.md'
require_in write '.highway/features/'
require_in index 'code/integrations.md'
require_in index "3. Apply the Features rule to this feature's entry."
require "$CODIFY" 'The Features rule: in Features, add `<number>-<action> | one sentence` when this feature starts the product, adds an implementation, records an integration, changes the summary, or is open.'
require_in index 'When an accepted row already has that From, To, and Kind, write no second row.'

for text in \
	'code/<folder>/'; do
	require "$CODIFY" "$text"
done
for text in \
	'code/[ID]/' \
	'Automation Path' \
	'read `codify.md` at that row'; do
	reject "$CODIFY" "$text"
done

require "$ADR" "a recorded feature's action is this decision's title"
reject "$ADR" 'code/[ID]/codify.md'

require "$CATALOG" '| ID | Folder | Title | Summary | Implementations | Features | Status |'
require "$CODIFY" 'starts the product, adds an implementation, records an integration, changes the summary, or is open'
reject "$CATALOG" 'Automation Path'
reject "$CODIFY" 'Automation Path'
require "$RECORD" '**Proposed project:**'
require "$RECORD" '**Rationale:**'
require "$RECORD" '.highway/features/'
require "$TASKS" 'product: CDYXXXXXX'
require "$TASKS" 'relative to the product folder'
require "$METADATA" '.highway/metadata.md'
require "$INTEGRATIONS" '| From | To | Kind | Summary | Status |'
require "$CODIFY" 'The integrations catalog is `code/integrations.md`.'

over=$(awk '/^### /{if(n && c>400)print n": "c; n=$0; c=0; next} /^## /{if(n && c>400)print n": "c; n=""; next} n{c+=NF} END{if(n && c>400)print n": "c}' "$CODIFY")
if [[ -n "$over" ]]; then
	echo "FAIL: highway-codify step over 400 words: $over"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: codify decides the product from the catalogs'
