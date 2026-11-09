#!/usr/bin/env bash
# Implementation includes platforms that can start automation, codify config configures them, and one Provider executes every task.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "The executor and each provider are the person" or a diagram arrow from one target to the next fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
OUTPUT="$HIGHWAY_ROOT/library/templates/output"
IMPL="$SKILLS/highway-implementation/SKILL.md"
ONBOARD="$SKILLS/highway-onboarding/SKILL.md"
CODIFY="$SKILLS/highway-codify/SKILL.md"
PLATFORMS="$OUTPUT/codify-platforms.md"
RECORD="$OUTPUT/codify-record.md"
TASKS="$OUTPUT/codify-tasks.md"
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
require "$PLATFORMS" 'version: 2.1.0'

for text in \
	'### platforms' \
	'is included as a platform highway can use in highway-codify proposals**' \
	'**Would you like to configure how highway-codify uses [Platform]?**' \
	'library/coding-standards/codify-platforms.md' \
	'an agent that starts the work' \
	'version: 7.9.0'; do
	require "$IMPL" "$text"
done

require "$ONBOARD" 'follow `platforms` in `highway-implementation`'
require "$ONBOARD" 'version: 10.6.0'

for text in \
	'When the invocation is the word `configure`' \
	"**[Product Title]'s implementation record is missing critical detail required for highway-codify proposals.**" \
	'**Executor:**' \
	'Do not replace the Provider' \
	'P -->|[Next action]|' \
	'version: 14.0.0'; do
	require "$CODIFY" "$text"
done
for text in \
	'The executor and each provider are the person' \
	'Do not invent a means that no accepted architecture describes.' \
	'T1 -->|[Next action]|'; do
	reject "$CODIFY" "$text"
done

require "$RECORD" 'P -->|<next action>|'
require "$RECORD" 'version: 9.1.0'
reject "$RECORD" 'T1 -->|<next action>|'

require "$TASKS" 'The Provider is the first node'
require "$TASKS" 'version: 6.0.0'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: codify platform catalog, provider, and diagram"
