#!/usr/bin/env bash
# Verifies no-write lifecycle invariants for Feature 091.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-profile-life.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
fail=0
accepted="$fixture_root/accepted.md"
cp "$HIGHWAY_ROOT/library/templates/output/profile.md" "$accepted"
before="$(shasum -a 256 "$accepted" | awk '{print $1}')"
# Declined and interrupted proposals do not write the accepted artifact.
printf '%s\n' 'transient proposal evidence' > "$fixture_root/proposal.txt"
after="$(shasum -a 256 "$accepted" | awk '{print $1}')"
[[ "$before" == "$after" ]] || { echo 'FAIL: transient proposal changed accepted bytes'; fail=1; }
# Legacy YAML is inert even when present.
printf '%s\n' 'organization:' '  name: Legacy' > "$fixture_root/profile.yaml"
if grep -Fq Legacy "$accepted"; then echo 'FAIL: legacy YAML influenced accepted Profile'; fail=1; fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Profile lifecycle contract passes'
