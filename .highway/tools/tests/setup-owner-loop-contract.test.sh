#!/usr/bin/env bash
# Verifies owner-specific readiness and result routing.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
require() { grep -Fq -- "$2" "$1" || { echo "FAIL: $1 missing '$2'"; fail=1; }; }
for token in 'Request readiness from the current owner' 'terminal with `Next Action: None`' 'result declared by that owner' 'requires additional owner interaction' 'active collection/work finished' 'malformed or unsupported owner output' 'Collection Result contracts' 'own declared owner results'; do require "$SKILL" "$token"; done
[[ $fail -eq 0 ]] && echo 'OK: Setup owner-loop contract passes' || exit 1
