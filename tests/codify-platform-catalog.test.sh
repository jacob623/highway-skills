#!/usr/bin/env bash
# Implementation includes platforms that can start automation, codify config configures them, and one Provider executes every task.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "The executor and each provider are the person" or a diagram arrow from one target to the next fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
SKILLS="$HW_SKILLS"
IMPL="$SKILLS/highway-implementation/SKILL.md"
ONBOARD="$SKILLS/highway-onboarding/SKILL.md"
CODIFY="$SKILLS/highway-codify/SKILL.md"
PLATFORMS="$(hw_template codify-platforms)"
RECORD="$(hw_template codify-record)"
TASKS="$(hw_template codify-tasks)"
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

require "$PLATFORMS" '| Platform | Implementation ID | Kind | When to use | When not to use |'

for text in \
	'### platforms' \
	'is included as a platform highway can use in highway-codify proposals**' \
	'**Would you like to configure how highway-codify uses [Platform]?**' \
	'library/coding-standards/codify-platforms.md' \
	'an agent that starts the work'; do
	require "$IMPL" "$text"
done

require "$ONBOARD" 'Follow `onboarding` in `highway-implementation`'
require "$IMPL" '6. Follow `platforms`.'

for text in \
	'When the invocation is the word `configure`' \
	"**[Product Title]'s implementation record is missing critical detail required for highway-codify proposals.**" \
	'**Executor:**' \
	'Do not replace the Provider' \
	'P -->|[Next action]|'; do
	require "$CODIFY" "$text"
done
for text in \
	'The executor and each provider are the person' \
	'Do not invent a means that no accepted architecture describes.' \
	'T1 -->|[Next action]|'; do
	reject "$CODIFY" "$text"
done

require "$RECORD" 'P -->|<next action>|'
reject "$RECORD" 'T1 -->|<next action>|'

require "$TASKS" 'The Provider is the first node'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: codify platform catalog, provider, and diagram"
