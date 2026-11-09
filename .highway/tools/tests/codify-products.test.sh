#!/usr/bin/env bash
# Codify places each feature in a product folder and decides join or start from the catalogs.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring `code/[ID]/` in highway-codify, or removing `### resume`, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
CODIFY="$SKILLS/highway-codify/SKILL.md"
ADR="$SKILLS/highway-adr/SKILL.md"
CATALOG="$OUTPUT/codify-catalog.md"
RECORD="$OUTPUT/codify-record.md"
TASKS="$OUTPUT/codify-tasks.md"
METADATA="$OUTPUT/codify-metadata.md"
INTEGRATIONS="$OUTPUT/codify-integrations.md"
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
require_in index 'starts the product, adds an implementation, records an integration, changes the summary, or is open'
require_in index 'When an accepted row already has that From, To, and Kind, write no second row.'

for text in \
	'code/<folder>/' \
	'version: 14.1.0'; do
	require "$CODIFY" "$text"
done
for text in \
	'code/[ID]/' \
	'Automation Path' \
	'read `codify.md` at that row'; do
	reject "$CODIFY" "$text"
done

require "$ADR" 'version: 6.0.0'
require "$ADR" "a recorded feature's action is this decision's title"
reject "$ADR" 'code/[ID]/codify.md'

require "$CATALOG" 'version: 3.0.0'
require "$CATALOG" '| ID | Folder | Title | Summary | Implementations | Features | Status |'
require "$CATALOG" 'starts the product, adds an implementation, records an integration, changes the summary, or is open'
reject "$CATALOG" 'Automation Path'
require "$RECORD" 'version: 9.1.0'
require "$RECORD" '**Proposed project:**'
require "$RECORD" '**Rationale:**'
require "$RECORD" '.highway/features/'
require "$TASKS" 'version: 6.0.0'
require "$TASKS" 'product: CDYXXXXXX'
require "$TASKS" 'relative to the product folder'
require "$METADATA" 'version: 2.0.0'
require "$METADATA" '.highway/metadata.md'
require "$INTEGRATIONS" 'version: 1.0.0'
require "$INTEGRATIONS" '| From | To | Kind | Summary | Status |'
require "$INTEGRATIONS" 'code/integrations.md'

over=$(awk '/^### /{if(n && c>400)print n": "c; n=$0; c=0; next} /^## /{if(n && c>400)print n": "c; n=""; next} n{c+=NF} END{if(n && c>400)print n": "c}' "$CODIFY")
if [[ -n "$over" ]]; then
	echo "FAIL: highway-codify step over 400 words: $over"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: codify decides the product from the catalogs'
