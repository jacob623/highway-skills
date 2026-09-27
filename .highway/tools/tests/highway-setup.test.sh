#!/usr/bin/env bash
# Verifies Feature 095 Setup handoff, ownership, and routing contract.
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
require_text "$SKILL" 'Profile readiness'
require_text "$SKILL" 'Objectives readiness'
require_text "$SKILL" "Let's identify some explicit outcomes worth pursuing."
require_text "$SKILL" "These give Highway something concrete to connect future decisions back to"
require_text "$SKILL" "What's an important outcome you'd like to achieve?"
require_text "$SKILL" "If you'd like some suggestions based on your organization's Profile"
require_text "$SKILL" 'Setup-owned'
require_text "$SKILL" 'Objectives-owned'
require_text "$SKILL" 'does not inspect Profile metadata'
require_text "$SKILL" 'never recomputes it'
require_text "$SKILL" 'does not author a Controls discovery question'
require_text "$SKILL" 'one unresolved owner question at a time'
require_text "$SKILL" 'never restore an unanswered question'
require_text "$SKILL" 'NFR `Not Applicable`'
require_text "$SKILL" 'current owner activity'
require_text "$SKILL" 'owners completed and remaining'
require_text "$SKILL" 'without exposing routing or validation mechanics'
require_text "$SKILL" "We've identified what you're trying to accomplish. Now let's think about what needs to be true as you pursue those outcomes."
require_text "$SKILL" 'Controls-purpose transition'
require_text "$SKILL" 'Collection Result: Finished'
require_text "$SKILL" 'Created Control IDs: []'
require_text "$SKILL" 'pre-delegation `Complete`'
require_text "$SKILL" 'does not claim Controls or Setup completion'
require_text "$SKILL" 'fresh Controls readiness'
require_text "$SKILL" 'does not advance through NFR review'
require_text "$SKILL" 'stop-before-NFR-review'
require_text "$SKILL" "We've established the safeguards that should guide future technology decisions. Now let's consider what those decisions need to achieve in operation."
require_text "$SKILL" "Based on the Controls we've defined, Highway may already have identified qualities or operational outcomes worth considering."
require_text "$SKILL" 'first NFR-owned interaction'
require_text "$SKILL" 'terminal result without requiring interaction'
require_text "$SKILL" 'Next Action: None'
require_text "$SKILL" 'requires user input'
require_text "$SKILL" 'NFR Collection Result'
require_text "$SKILL" 'Collection Result: Continue|Finished'
require_text "$SKILL" 'fresh NFR readiness'
require_text "$SKILL" 'without inspecting candidate contents, counts, records, relationships, or internal state'
require_text "$SKILL" 'Your foundational Highway context is now in place.'
require_text "$SKILL" '**Your foundational Highway context is now in place.**'
require_text "$SKILL" '**This is where Highway starts becoming more useful.**'
require_text "$SKILL" '**Where would you like to go next?**'
require_text "$SKILL" 'Run `/highway-help` to explore what Highway can help you do.'
if grep -Fq 'Highway Setup Complete' "$SKILL"; then echo 'FAIL: Setup retains the completion dashboard'; fail=1; fi
if grep -Fq 'Business Objectives: <terminal owner status>' "$SKILL"; then echo 'FAIL: Setup retains dashboard summary fields'; fail=1; fi
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
