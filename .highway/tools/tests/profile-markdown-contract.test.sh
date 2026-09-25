#!/usr/bin/env bash
# Verifies Markdown Profile rendering and state invariants.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-profile.sh"
fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-profile-md.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
fail=0
cp "$HIGHWAY_ROOT/library/templates/output/profile-record.md" "$fixture_root/one.md"
cp "$HIGHWAY_ROOT/library/templates/output/profile-record.md" "$fixture_root/two.md"
if ! cmp -s "$fixture_root/one.md" "$fixture_root/two.md"; then echo 'FAIL: identical template renders differ'; fail=1; fi
if ! "$VALIDATE" "$fixture_root/one.md" >/dev/null; then echo 'FAIL: template validation failed'; fail=1; fi
sed -i '' 's/identity: not_discussed/identity: discussed/' "$fixture_root/one.md"
printf '%s\n' '## Who We Are' 'Evidence supplied by the user.' >> "$fixture_root/one.md"
if ! "$VALIDATE" "$fixture_root/one.md" >/dev/null; then echo 'FAIL: discussed narrative validation failed'; fail=1; fi
cp "$fixture_root/one.md" "$fixture_root/three.md"
if ! cmp -s "$fixture_root/one.md" "$fixture_root/three.md"; then echo 'FAIL: accepted bytes are not stable'; fail=1; fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Markdown Profile contract passes'
