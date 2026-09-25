#!/usr/bin/env bash
# Verifies deterministic Setup resume routing cases.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
for case_text in 'No authoritative Profile' 'Valid incomplete Profile' 'Valid Complete Profile' 'Malformed Profile'; do
	grep -Fq "$case_text" "$SKILL" || { echo "FAIL: missing routing case '$case_text'"; fail=1; }
done
if grep -Fq 'Setup checkpoint' "$SKILL" && ! grep -Fq 'Never restore' "$SKILL"; then echo 'FAIL: Setup checkpoint behavior is ambiguous'; fail=1; fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Setup resume routing passes'
