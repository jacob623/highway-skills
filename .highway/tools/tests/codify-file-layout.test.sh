#!/usr/bin/env bash
# Coding standards carry a relative file and folder structure, codify places files from it by feature, and no standard is seeded.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring `executor/` in the codify task template, or the seeded Terraform standard, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
CONFIG="$SKILLS/highway-codify-config/SKILL.md"
CODIFY="$SKILLS/highway-codify/SKILL.md"
STANDARD_TEMPLATE="$OUTPUT/coding-standard.md"
RECORD="$OUTPUT/codify-record.md"
TASKS="$OUTPUT/codify-tasks.md"
ORG_STANDARDS="$HIGHWAY_ROOT/../library/coding-standards"
MANIFEST="$HIGHWAY_ROOT/tools/.distribution-manifest"
fail=0

require() {
	local file="$1" text="$2"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") is missing"
		fail=1
		return
	fi
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if [[ -f "$file" ]] && grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") still contains: $text"
		fail=1
	fi
}

absent() {
	local file="$1"
	if [[ -e "$file" ]]; then
		echo "FAIL: library/coding-standards/$(basename "$file") is still seeded"
		fail=1
	fi
}

require "$STANDARD_TEMPLATE" '## File and Folder Structure'
require "$STANDARD_TEMPLATE" 'Test path:'
require "$STANDARD_TEMPLATE" 'Tests: not required'
require "$STANDARD_TEMPLATE" 'version: 3.0.0'

for text in \
	'**File and Folder Structure:**' \
	'Test path:' \
	'A file and folder structure is needed.' \
	'Paths are relative to the automation folder.' \
	'The test path must be part of the file and folder structure.' \
	'When the catalog is absent, create it' \
	'name the same relative path' \
	'version: 3.2.0'; do
	require "$CONFIG" "$text"
done

for text in \
	'### layout' \
	'**Files:**' \
	'has no file and folder structure. To add one, run /highway-codify-config.' \
	'version: 12.0.0'; do
	require "$CODIFY" "$text"
done

require "$RECORD" '**Files:**'
require "$RECORD" 'version: 9.0.0'

for text in \
	'[Executor]' \
	'[Task N]' \
	'- [ ] T001' \
	'Files: `README.md`' \
	'Standards: `library/coding-standards/' \
	'The Provider is the first node of the accepted diagram.' \
	'version: 6.0.0'; do
	require "$TASKS" "$text"
done

for file in "$CODIFY" "$TASKS" "$RECORD"; do
	reject "$file" 'executor/'
	reject "$file" 'task-N/'
	reject "$file" 'Each task produces one file'
done
reject "$TASKS" 'code/<id>/'
reject "$RECORD" 'code/<id>/'

absent "$ORG_STANDARDS/coding-standards.md"
absent "$ORG_STANDARDS/terraform.md"
reject "$MANIFEST" "include	library/coding-standards	-"
require "$MANIFEST" "exclude	library	-"

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: codify file layout, feature task list, and unseeded coding standards'
