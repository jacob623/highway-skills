#!/usr/bin/env bash
# Verifies reciprocal classification routing between the NFR and Control skills.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
NFR_SKILL="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
CONTROL_SKILL="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md"
fail=0

require_text() {
	file="$1"
	text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

# NFR-shaped input offered to Controls must have a named destination.
require_text "$CONTROL_SKILL" "Do not use it to author non-functional requirements"
require_text "$CONTROL_SKILL" "/highway-nfrs"

# Control-shaped input offered to NFRs must have a named destination.
require_text "$NFR_SKILL" "enforceable, auditable, or checkable safeguard"
require_text "$NFR_SKILL" "/highway-controls"

# Advice is not refusal, and relationship ownership remains deferred.
require_text "$CONTROL_SKILL" "This skill MUST NOT refuse a Control the user still wants"

# Feature 094 onboarding aliases and review boundaries stay owned by their canonical skills.
require_text "$CONTROL_SKILL" '`setup` and `configure` are aliases'
require_text "$CONTROL_SKILL" "materially interpreted user-authored proposal"
require_text "$CONTROL_SKILL" "Selected recommendations are captured directly"
require_text "$NFR_SKILL" "accept, modify, replace, reject, or skip"

# Feature 078 keeps review output contracts in their canonical owner sections.
require_text "$CONTROL_SKILL" "### Control Review Output Contract"
if [[ "$(grep -Fc '### Control Review Output Contract' "$CONTROL_SKILL")" != "1" ]]; then
	echo "FAIL: Control review output contract is not declared exactly once"
	fail=1
fi

# Both skills expose the required workflow and verification sections.
require_text "$NFR_SKILL" "## Verification"
require_text "$NFR_SKILL" "## Error Handling"
require_text "$CONTROL_SKILL" "## Verification"
require_text "$CONTROL_SKILL" "## Error Handling"

exit $fail
