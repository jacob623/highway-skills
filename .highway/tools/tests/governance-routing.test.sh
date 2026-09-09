#!/usr/bin/env bash
# Verifies reciprocal classification routing between the NFR and Control skills.
set -u

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
require_text "$NFR_SKILL" "Specific, testable, auditable, or enforceable implementation requirement"
require_text "$NFR_SKILL" "offer \`/highway-controls\` instead"

# Advice is not refusal, and relationship ownership remains deferred.
require_text "$NFR_SKILL" "If the user keeps a vague NFR, record it after advice."
require_text "$NFR_SKILL" "reserved relationship fields remain empty in this phase"
require_text "$CONTROL_SKILL" "This skill MUST NOT refuse a Control the user still wants"

# Both skills expose the required workflow and verification sections.
require_text "$NFR_SKILL" "## Verification"
require_text "$NFR_SKILL" "## Error Handling"
require_text "$CONTROL_SKILL" "## Verification"
require_text "$CONTROL_SKILL" "## Error Handling"

exit $fail
