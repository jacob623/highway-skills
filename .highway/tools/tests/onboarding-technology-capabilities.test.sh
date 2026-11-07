#!/usr/bin/env bash
# Onboarding opens with the technology landscape heading and proposes technology capabilities.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "What we'll do together" or `[What the organization does.]` in highway-onboarding fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ONBOARDING="$HIGHWAY_ROOT/skills/highway-onboarding/SKILL.md"
fail=0

require() {
	grep -Fq -- "$1" "$ONBOARDING" || {
		echo "FAIL: highway-onboarding omits: $1"
		fail=1
	}
}

reject() {
	if grep -Fq -- "$1" "$ONBOARDING"; then
		echo "FAIL: highway-onboarding still contains: $1"
		fail=1
	fi
}

section() {
	awk -v h="$1" '$0 == h {p=1; next} /^##/ {p=0} p' "$ONBOARDING"
}

require_in() {
	local name="$1" text="$2"
	section "### $name" | grep -Fq -- "$text" || {
		echo "FAIL: highway-onboarding $name omits: $text"
		fail=1
	}
}

require_in overview "Emit \"Let's get to know your technology landscape\" as a level-3 heading."
section '### overview' | grep -Fxq "Let's get to know your technology landscape" || {
	echo "FAIL: highway-onboarding overview omits the heading line"
	fail=1
}
require_in overview '- **Identify the technology capabilities** that support your business.'

require_in capabilities 'A technology capability is something software, a platform, a service, or infrastructure does for the organization.'
require_in capabilities 'For each business activity that accepted context names, propose the technology capability that activity relies on, including when context names no system.'
require_in capabilities 'Title it for what the technology does, such as Online Payments, not for the business function, such as Sales. The title is not a product or vendor.'
require_in capabilities 'Leave out an activity that no technology supports. When two activities rely on one technology, propose each as its own capability.'
require_in capabilities 'Do not include a provider.'
require_in capabilities '[What the technology does for the organization.]'
require_in map '[What the technology does for the organization.]'

reject "What we'll do together"
reject 'This is where Highway helps you navigate your technology landscape.'
reject 'Identify important business capabilities'
reject '[What the organization does.]'

require 'version: 10.4.0'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: onboarding proposes technology capabilities'
