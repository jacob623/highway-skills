#!/usr/bin/env bash
# Verifies the corrected thin Setup contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
require_text() { grep -Fq -- "$2" "$1" || { echo "FAIL: '$2' missing from $1"; fail=1; }; }
for token in 'version: 8.0.0' '## Purpose' 'Profile → Objectives → Controls → NFRs' '/highway-profile' '/highway-objectives' '/highway-controls' '/highway-nfrs' 'active user request' 'Collection Result contracts' 'Your foundational Highway context is now in place.' '## Welcome to Highway' 'Turn organizational knowledge into connected decisions.' 'User-visible interaction follows the Highway Experience Standard.' 'Rely on the Constitution common failure model.'; do require_text "$SKILL" "$token"; done
for forbidden in 'Setup-owned:' 'Objectives-owned:' 'Created Control IDs' 'Workflow Step' 'Controls orchestration state' 'Guided Setup interaction contract' 'verified completion' 'retained-output verification' 'Profile readiness
- Objectives readiness'; do
  if grep -Fq -- "$forbidden" "$SKILL"; then echo "FAIL: obsolete Setup text '$forbidden' remains"; fail=1; fi
done
[[ $fail -eq 0 ]] && echo 'OK: Setup ownership contract passes' || exit 1
