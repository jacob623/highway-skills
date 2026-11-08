#!/usr/bin/env bash
# highway-codify-config owns the platform and coding standards catalogs, codify reads their guidance, and inclusion asks to configure.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring `### configure` in highway-codify, or the Source column in the platforms template, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
CONFIG="$SKILLS/highway-codify-config/SKILL.md"
CODIFY="$SKILLS/highway-codify/SKILL.md"
IMPL="$SKILLS/highway-implementation/SKILL.md"
ONBOARD="$SKILLS/highway-onboarding/SKILL.md"
PLATFORMS="$OUTPUT/codify-platforms.md"
STANDARDS_TEMPLATE="$OUTPUT/coding-standards-catalog.md"
STANDARD_TEMPLATE="$OUTPUT/coding-standard.md"
RECORD="$OUTPUT/codify-record.md"
TASKS="$OUTPUT/codify-tasks.md"
STANDARDS_CATALOG="$HIGHWAY_ROOT/../library/coding-standards/coding-standards.md"
MANIFEST="$HIGHWAY_ROOT/tools/.distribution-manifest"
STANDARDS_HEADER='| Standard Title | Technology | File Patterns | Summary | When to use | When not to use | Inherits From | Standard Path |'
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

for text in \
	'### How would you like to configure Highway Codify?' \
	'1. **View or Update Platforms** highway-codify can use in proposals.' \
	'2. **View or Update Coding Standards** highway uses for coding.' \
	'3. **Resolve Codify Conflicts** so highway can provide more accurate and consistent proposals.' \
	'**What would you add, correct, or remove?**' \
	'**What would you add or correct?**' \
	"If you'd like to cancel, just say so." \
	'**Which conflict would you like to resolve?**' \
	'as an ordered list' \
	'**Conflicts:**' \
	'**Coding Standards:**' \
	'**Tests:**' \
	'**Inherits From:**' \
	'is not in the implementation catalog.' \
	'to finish adding [Platform].' \
	'You can accept this proposal with these conflicts and resolve them afterward.' \
	'library/coding-standards/codify-platforms.md' \
	'coding-standards-catalog.md' \
	'coding-standard.md' \
	'### menu' \
	'### platforms' \
	'### standards' \
	'### conflicts' \
	'version: 3.5.0'; do
	require "$CONFIG" "$text"
done

require "$PLATFORMS" '| Platform | Implementation ID | Kind | When to use | When not to use |'
require "$PLATFORMS" 'library/coding-standards/codify-platforms.md'
require "$PLATFORMS" 'version: 2.1.0'
reject "$PLATFORMS" '| Source |'
require "$STANDARDS_TEMPLATE" "$STANDARDS_HEADER"
if [[ -e "$STANDARDS_CATALOG" ]]; then
	echo "FAIL: library/coding-standards/coding-standards.md is still seeded"
	fail=1
fi
require "$STANDARD_TEMPLATE" '## Rules'
require "$STANDARD_TEMPLATE" 'Tests: not required'
require "$RECORD" '**Standards:**'
require "$RECORD" 'version: 9.0.0'
require "$TASKS" 'Standards: `library/coding-standards/'
require "$TASKS" 'version: 6.0.0'
reject "$TASKS" 'Implement and Use'

for text in \
	'### standards' \
	'**Standards:**' \
	'/highway-codify-config' \
	'library/coding-standards/codify-platforms.md' \
	'version: 12.3.0'; do
	require "$CODIFY" "$text"
done
for text in \
	'### configure' \
	'/highway-codify configure' \
	'library/knowledge/codify-platforms.md' \
	'the first row was used'; do
	reject "$CODIFY" "$text"
done

for file in "$IMPL" "$ONBOARD"; do
	require "$file" '**Would you like to configure how highway-codify uses [Platform]?**'
	require "$file" 'library/coding-standards/codify-platforms.md'
	reject "$file" 'library/knowledge/codify-platforms.md'
	reject "$file" '/highway-codify configure'
done
require "$IMPL" 'Follow `highway-codify-config` for [Platform], with the return step `close` in `highway-implementation`.'
require "$ONBOARD" 'Follow `highway-codify-config` for [Platform], with the return step `configure` in `highway-onboarding`.'
require "$ONBOARD" 'to finish adding [Platform].'
reject "$ONBOARD" 'emit its two sentences. Do not ask a question.'

for agent in .claude .cursor .github .agents; do
	require "$MANIFEST" "include	$agent/skills/highway-codify-config	-"
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: codify config skill, catalogs, task standards, and inclusion question'
