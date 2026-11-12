#!/usr/bin/env bash
# Onboarding and implementation hand off to highway-codify-config and continue at a held return step.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "Run `/highway-codify-config [Platform]` to configure it for automation." in highway-onboarding, or "- `decline`: stop. Write nothing." in highway-codify-config, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
ONBOARD="$HW_SKILLS/highway-onboarding/SKILL.md"
IMPL="$HW_SKILLS/highway-implementation/SKILL.md"
CONFIG="$HW_SKILLS/highway-codify-config/SKILL.md"
MENU='### How would you like to configure Highway Codify?'
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

line_of() {
	grep -nFx -- "$2" "$1" | head -1 | cut -d: -f1
}

require "$ONBOARD" 'Follow the steps in this order: `overview`, `capabilities`, `map`, `mapping`, `orchestrate`, `lineage`, `configure`, then `summary`.'
require_in "$ONBOARD" '### orchestrate' 'A yes adds [Platform] to the platforms to configure, in the order asked.'
require_in "$ONBOARD" '### orchestrate' 'When `highway-codify-config` started this onboarding for [Platform], do not ask this for [Platform].'
require_in "$ONBOARD" '### lineage' 'Then go to `configure`.'
require_in "$ONBOARD" '### configure' '1. When no platform to configure remains, go to `summary`.'
require_in "$ONBOARD" '### configure' '2. Take the first platform to configure. Remove it from the list.'
require_in "$ONBOARD" '### configure' "3. Emit: Let's configure how highway-codify uses [Platform]."
require_in "$ONBOARD" '### configure' '4. Follow `highway-codify-config` for [Platform], with the return step `configure` in `highway-onboarding`.'
require_in "$ONBOARD" '### summary' 'Run `/highway-codify-config [Platform]` to finish adding [Platform].'

lineage="$(line_of "$ONBOARD" '### lineage')"
configure="$(line_of "$ONBOARD" '### configure')"
summary="$(line_of "$ONBOARD" '### summary')"
if [[ -z "$lineage" || -z "$configure" || -z "$summary" ]] || ((lineage >= configure || configure >= summary)); then
	echo 'FAIL: highway-onboarding does not order lineage, configure, then summary'
	fail=1
fi

words="$(section "$ONBOARD" '### configure' | wc -w | tr -d ' ')"
if ((words > 250)); then
	echo "FAIL: highway-onboarding configure has $words words"
	fail=1
fi

require_in "$IMPL" '### platforms' 'When `onboarding` follows this step, return to `highway-onboarding` instead of going to `close`. Do not emit the included line or ask the question.'
require_in "$IMPL" '### platforms' "- \`accept\`, or a yes: emit: Let's configure how highway-codify uses [Platform]. Follow \`highway-codify-config\` for [Platform], with the return step \`close\` in \`highway-implementation\`."
require_in "$IMPL" '### platforms' '- `decline`, or a no: go to `close`.'
require_in "$IMPL" '### platforms' '- `unknown`: go to `close`.'

require_in "$CONFIG" '### Entry' '2. When the invocation names a return step, hold it for this visit.'
require_in "$CONFIG" "$MENU" '- `decline`: when a return step is held, go to that step in its skill. Otherwise stop. Write nothing.'

reject "$ONBOARD" 'Run `/highway-codify-config [Platform]` to configure it for automation.'
reject "$ONBOARD" 'Do not emit the configure pointer here.'
reject "$IMPL" 'Run `/highway-codify-config [Platform]` to configure it.'
reject "$CONFIG" '- `decline`: stop. Write nothing.'

for pair in "$ONBOARD|### configure" "$IMPL|### platforms" "$CONFIG|### Entry" "$CONFIG|$MENU"; do
	file="${pair%%|*}"
	heading="${pair#*|}"
	for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
		if section "$file" "$heading" | grep -Fiwq -- "$word"; then
			echo "FAIL: $(basename "$(dirname "$file")") $heading uses: $word"
			fail=1
		fi
	done
done


if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: onboarding and implementation hand off to configuration and return'
