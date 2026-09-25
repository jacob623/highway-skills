#!/usr/bin/env bash
# Verifies explicit Profile Repository Context participation.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fail=0
participant="$HIGHWAY_ROOT/tools/tests/fixtures/profile-091/reference-participant/SKILL.md"
for text in '.highway/library/knowledge/profile.md' 'declared Profile Repository Context' 'workflow-specific request' 'ask for a missing capability'; do
	if ! grep -Fq "$text" "$participant"; then echo "FAIL: participant missing '$text'"; fail=1; fi
done
for text in 'profile.md' 'user-owned organizational context' 'highway-identity.md' 'highway-vision.md'; do
	if ! grep -Fq "$text" "$HIGHWAY_ROOT/governance/constitution.md" && ! grep -Fq "$text" "$HIGHWAY_ROOT/library/knowledge/highway-identity.md"; then echo "FAIL: governance context missing '$text'"; fail=1; fi
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Profile participation contract passes'
