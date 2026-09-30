#!/usr/bin/env bash
# Verifies the thin Setup owner-orchestration contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
require_text() { grep -Fq -- "$2" "$1" || { echo "FAIL: '$2' missing from $1"; fail=1; }; }
for token in   'version: 8.0.0' '/highway-profile' '/highway-objectives' '/highway-controls' '/highway-nfrs'   'active user request' 'Profile, Objectives, Controls, NFRs' 'Next Action: None'   'Collection Result: Continue|Finished' 'Your foundational Highway context is now in place.'   'Where would you like to go next?' 'Run `/highway-help` to explore what Highway can help you do.'   'User-visible interaction follows the Highway Experience Standard.'   'Rely on the Constitution common failure model.'; do
  require_text "$SKILL" "$token"
done
for forbidden in 'Setup-owned:' 'Objectives-owned:' 'Created Control IDs' 'Workflow Step' 'Controls orchestration state' 'Guided Setup interaction contract' 'verified completion' 'retained-output verification' 'Highway Setup Complete'; do
  if grep -Fq -- "$forbidden" "$SKILL"; then echo "FAIL: obsolete Setup text '$forbidden' remains"; fail=1; fi
done
for token in 'Profile readiness' 'Objectives readiness' 'Controls readiness' 'NFR readiness'; do require_text "$SKILL" "$token"; done
profile_line="$(grep -n '^- Profile readiness' "$SKILL" | head -n 1 | cut -d: -f1)"
objective_line="$(grep -n '^- Objectives readiness' "$SKILL" | head -n 1 | cut -d: -f1)"
controls_line="$(grep -n '^- Controls readiness' "$SKILL" | head -n 1 | cut -d: -f1)"
nfr_line="$(grep -n '^- NFR readiness' "$SKILL" | head -n 1 | cut -d: -f1)"
if [[ "$profile_line" -ge "$objective_line" || "$objective_line" -ge "$controls_line" || "$controls_line" -ge "$nfr_line" ]]; then echo 'FAIL: owner order is not Profile -> Objectives -> Controls -> NFRs'; fail=1; fi
[[ $fail -eq 0 ]] && echo 'OK: Setup ownership contract passes' || exit 1
