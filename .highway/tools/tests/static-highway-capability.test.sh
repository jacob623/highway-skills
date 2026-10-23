#!/usr/bin/env bash
# Onboarding includes a static Highway capability and maps it to the agent platform.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a missing Highway line or an authorization to act fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-onboarding/SKILL.md"
fail=0

require() {
	local text="$1"
	grep -Fq "$text" "$SKILL" || {
		echo "FAIL: onboarding omits: $text"
		fail=1
	}
}

require '**Highway:** Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge.'
require 'A removed Highway line is not placed on the capability queue.'
require 'When the capability title is Highway and the session identifies the agent platform by name, that name is the provider.'
require 'Do not assign this provider to a capability the platform does not operate.'
require 'Do not authorize the agent platform to act on its own.'
require 'Omit it when an accepted ADR already records the Highway capability for the same agent-platform name.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: static Highway capability"
