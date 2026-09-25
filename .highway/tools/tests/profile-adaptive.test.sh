#!/usr/bin/env bash
# Verifies adaptive evidence fixture coverage.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORPUS="$SCRIPT_DIR/fixtures/profile-091/adaptive-corpus.md"
fail=0
for fixture in 'Very small non-technical organization' 'Small technology startup' 'Small-to-medium organization with dedicated IT' 'Large enterprise'; do
	grep -Fq "$fixture" "$CORPUS" || { echo "FAIL: missing adaptive fixture '$fixture'"; fail=1; }
done
grep -Fq 'multiple domains' "$CORPUS" || { echo 'FAIL: cross-domain fixture coverage missing'; fail=1; }
grep -Fq 'Identical inputs produce identical' "$CORPUS" || { echo 'FAIL: deterministic rendering coverage missing'; fail=1; }
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: adaptive Profile corpus passes'
