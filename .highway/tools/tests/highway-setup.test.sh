#!/usr/bin/env bash
# Verifies Feature 091 Setup ownership and routing contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
require_text() { grep -Fq "$2" "$1" || { echo "FAIL: '$2' missing from $1"; fail=1; }; }
require_text "$SKILL" '/highway-profile readiness'
require_text "$SKILL" 'first `not_discussed` domain'
require_text "$SKILL" 'advances to Objectives'
require_text "$SKILL" "Let's identify some explicit outcomes worth pursuing."
require_text "$SKILL" "These give Highway something concrete to connect future decisions back to"
require_text "$SKILL" "What's an important outcome you'd like to achieve?"
require_text "$SKILL" "If you'd like some suggestions based on your organization's Profile"
require_text "$SKILL" 'Setup-owned'
require_text "$SKILL" 'Objectives-owned'
require_text "$SKILL" 'does not inspect Profile metadata'
require_text "$SKILL" 'does not recompute'
require_text "$SKILL" 'does not write owner artifacts'
require_text "$SKILL" 'one unresolved owner question at a time'
require_text "$SKILL" 'never restore an unanswered question'
require_text "$SKILL" 'NFR `Not Applicable`'
require_text "$SKILL" 'current owner activity'
require_text "$SKILL" 'owners completed and remaining'
require_text "$SKILL" 'without exposing routing or validation mechanics'
if grep -Fq 'Step 1 of 3' "$SKILL"; then echo 'FAIL: Setup retains fixed Objective progress language'; fail=1; fi
if grep -Fq 'Describe the objective.' "$SKILL"; then echo 'FAIL: Setup owns Objective discovery prompts'; fail=1; fi
if grep -Fq 'organization.name' "$SKILL"; then echo 'FAIL: Setup retains organization.name ownership'; fail=1; fi
if grep -Fq 'profile.yaml' "$SKILL"; then echo 'FAIL: Setup references obsolete YAML'; fail=1; fi
profile_line="$(grep -n 'Profile readiness' "$SKILL" | head -n 1 | cut -d: -f1)"
objectives_line="$(grep -n 'Objectives readiness' "$SKILL" | head -n 1 | cut -d: -f1)"
controls_line="$(grep -n 'Controls readiness' "$SKILL" | head -n 1 | cut -d: -f1)"
nfr_line="$(grep -n 'NFR readiness' "$SKILL" | head -n 1 | cut -d: -f1)"
if [[ -z "$profile_line" || -z "$objectives_line" || -z "$controls_line" || -z "$nfr_line" || "$profile_line" -ge "$objectives_line" || "$objectives_line" -ge "$controls_line" || "$controls_line" -ge "$nfr_line" ]]; then
	echo 'FAIL: Setup readiness order is not Profile -> Objectives -> Controls -> NFRs'
	fail=1
fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Setup ownership contract passes'
