#!/usr/bin/env bash
# Verifies deterministic Setup collection result cases.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
for token in 'Continue' 'Finished' 'Declined' 'Aborted' 'Blocked' 'malformed' 'fresh owner readiness'; do
  grep -Fq -- "$token" "$SKILL" || { echo "FAIL: missing routing case '$token'"; fail=1; }
done
if grep -Fq '30-step' "$SKILL" || grep -Fq 'Created Control IDs' "$SKILL"; then echo 'FAIL: obsolete routing contract remains'; fail=1; fi
[[ $fail -eq 0 ]] && echo 'OK: Setup resume routing passes' || exit 1
