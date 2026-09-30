#!/usr/bin/env bash
# Verifies owner readiness and collection routing boundaries.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
require() { grep -Fq -- "$2" "$1" || { echo "FAIL: $1 missing '$2'"; fail=1; }; }
for token in 'Request readiness from the current owner' 'terminal with `Next Action: None`' 'supported `Next Action`' 'collection continues' 'collection finished' 'fresh readiness' 'owner `Blocked`' 'owner `Declined` or `Aborted`'; do require "$SKILL" "$token"; done
if grep -Fq 'candidate state' "$SKILL" && ! grep -Fq 'does not list or inspect owner-internal artifacts, state' "$SKILL"; then echo 'FAIL: Setup may inspect owner state'; fail=1; fi
[[ $fail -eq 0 ]] && echo 'OK: Setup owner-loop contract passes' || exit 1
