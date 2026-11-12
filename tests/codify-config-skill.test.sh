#!/usr/bin/env bash
# highway-codify-config owns the platform and coding standards catalogs, codify reads their guidance, and inclusion asks to configure.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring `### configure` in highway-codify, or the Source column in the platforms template, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
SKILLS="$HW_SKILLS"
CONFIG="$(fl_skill_text_file "$SKILLS/highway-codify-config")"
CODIFY="$(fl_skill_text_file "$SKILLS/highway-codify")"
IMPL="$(fl_skill_text_file "$SKILLS/highway-implementation")"
ONBOARD="$(fl_skill_text_file "$SKILLS/highway-onboarding")"
PLATFORMS="$(hw_template codify-platforms)"
STANDARDS_SKELETON="$(hw_template coding-standards-catalog)"
STANDARD_TEMPLATE="$(hw_template coding-standard)"
RECORD="$(hw_template codify-record)"
TASKS="$(hw_template codify-tasks)"
STANDARDS_CATALOG="$HW_ROOT/library/coding-standards/coding-standards.md"
MANIFEST="$HW_FRAMEWORK/.distribution-manifest"
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
	'library/coding-standards/coding-standards.md' \
	'coding-standard.md' \
	'### menu' \
	'### platforms' \
	'### standards' \
	'### conflicts'; do
	require "$CONFIG" "$text"
done

require "$PLATFORMS" '| Platform | Implementation ID | Kind | When to use | When not to use |'
require "$CONFIG" 'The file is `library/coding-standards/codify-platforms.md`.'
reject "$PLATFORMS" '| Source |'
require "$STANDARDS_SKELETON" "$STANDARDS_HEADER"
if [[ -e "$STANDARDS_CATALOG" ]]; then
	echo "FAIL: library/coding-standards/coding-standards.md is still seeded"
	fail=1
fi
require "$STANDARD_TEMPLATE" '## Rules'
require "$STANDARD_TEMPLATE" 'Tests: not required'
require "$RECORD" '**Standards:**'
require "$TASKS" 'Standards: `library/coding-standards/'
reject "$TASKS" 'Implement and Use'

for text in \
	'### standards' \
	'**Standards:**' \
	'highway-codify-config' \
	'library/coding-standards/codify-platforms.md'; do
	require "$CODIFY" "$text"
done
for text in \
	'### configure' \
	'highway-codify configure' \
	'library/knowledge/codify-platforms.md' \
	'the first row was used'; do
	reject "$CODIFY" "$text"
done

for file in "$IMPL" "$ONBOARD"; do
	require "$file" '**Would you like to configure how highway-codify uses [Platform]?**'
	require "$file" 'library/coding-standards/codify-platforms.md'
	reject "$file" 'library/knowledge/codify-platforms.md'
	reject "$file" 'highway-codify configure'
done
require "$IMPL" 'Follow `highway-codify-config` for [Platform], with the return step `close` in `highway-implementation`.'
require "$ONBOARD" 'Follow `highway-codify-config` for [Platform], with the return step `configure` in `highway-onboarding`.'
require "$ONBOARD" 'to finish adding [Platform].'
reject "$ONBOARD" 'emit its two sentences. Do not ask a question.'

for row in .claude/skills .cursor/skills .github/skills .agents/skills; do
	require "$MANIFEST" "include	$row/highway-codify-config	-"
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: codify config skill, catalogs, task standards, and inclusion question'
