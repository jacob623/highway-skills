#!/usr/bin/env bash
# Platform prompts in onboarding, implementation, and configuration name how highway-codify uses the platform.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "Would you like to configure [Platform] for automation?" or "as a platform capable of executing automation" fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
ONBOARD="$SKILLS/highway-onboarding/SKILL.md"
IMPL="$SKILLS/highway-implementation/SKILL.md"
CONFIG="$SKILLS/highway-codify-config/SKILL.md"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") still contains: $text"
		fail=1
	fi
}

for file in "$ONBOARD" "$IMPL"; do
	require "$file" '**[Platform] is included as a platform highway can use in highway-codify proposals**'
	require "$file" '**Would you like to configure how highway-codify uses [Platform]?**'
	require "$file" "Let's configure how highway-codify uses [Platform]."
	reject "$file" 'that can start automation.**'
	reject "$file" 'configure [Platform] for automation'
	reject "$file" 'configure it for automation'
done

require "$ONBOARD" "3. Emit: Let's configure how highway-codify uses [Platform]."
require "$ONBOARD" 'version: 10.6.0'
require "$IMPL" "- \`accept\`, or a yes: emit: Let's configure how highway-codify uses [Platform]. Follow \`highway-codify-config\` for [Platform], with the return step \`close\` in \`highway-implementation\`."
require "$IMPL" 'version: 7.9.0'

require "$CONFIG" '[On an add or update with no edit yet: **Here is a proposed starting point for configuring how highway-codify uses [Platform]**]'
require "$CONFIG" '1. **View or Update Platforms** highway-codify can use in proposals.'
require "$CONFIG" 'version: 3.5.0'
reject "$CONFIG" 'capable of executing automation'
reject "$CONFIG" 'considers for automation and self-service'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: platform prompts name how highway-codify uses the platform'
