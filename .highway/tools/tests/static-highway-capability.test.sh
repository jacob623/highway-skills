#!/usr/bin/env bash
# Onboarding includes a static AI-Assisted Engineering and Planning capability and maps it to the agent platform.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a missing AI-Assisted Engineering and Planning line or an authorization to act fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-onboarding/SKILL.md"
fail=0

require() {
	local text="$1"
	grep -Fq -- "$text" "$SKILL" || {
		echo "FAIL: onboarding omits: $text"
		fail=1
	}
}

require '1. **AI-Assisted Engineering and Planning:**'
require 'Using AI systems to assist with research, architecture, planning, governance, or implementation activities.'
require 'A removed AI-Assisted Engineering and Planning line is not placed on the capability queue.'
require 'When the capability title is AI-Assisted Engineering and Planning and the session identifies the agent platform by name, that name is the provider.'
require 'Do not assign this provider to a capability the platform does not operate.'
require 'Do not authorize the agent platform to act on its own.'
require 'Omit it when an accepted ADR already records this capability for the same agent-platform name.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: static AI-Assisted Engineering and Planning capability"
