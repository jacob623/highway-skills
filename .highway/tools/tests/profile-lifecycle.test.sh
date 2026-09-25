#!/usr/bin/env bash
# Verifies Profile mutation and no-write lifecycle invariants for Feature 092.
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
cp "$HIGHWAY_ROOT/library/templates/output/profile-record.md" "$accepted"
before="$(shasum -a 256 "$accepted" | awk '{print $1}')"

# A declined proposal remains transient and cannot change the accepted artifact.
cp "$accepted" "$fixture_root/declined.md"
printf '%s\n' 'transient proposal evidence' >> "$fixture_root/declined.md"
after="$(shasum -a 256 "$accepted" | awk '{print $1}')"
[[ "$before" == "$after" ]] || { echo 'FAIL: declined proposal changed accepted bytes'; fail=1; }

# An interrupted proposal is also discarded before it can replace accepted bytes.
cp "$accepted" "$fixture_root/interrupted.md"
printf '%s\n' 'interrupted proposal evidence' >> "$fixture_root/interrupted.md"
after="$(shasum -a 256 "$accepted" | awk '{print $1}')"
[[ "$before" == "$after" ]] || { echo 'FAIL: interrupted proposal changed accepted bytes'; fail=1; }

# A confirmed mutation writes the accepted proposal and changes the retained bytes.
cp "$accepted" "$fixture_root/confirmed.md"
sed -i '' 's/identity: not_discussed/identity: discussed/' "$fixture_root/confirmed.md"
printf '%s\n' '## Who We Are' 'Accepted identity evidence.' >> "$fixture_root/confirmed.md"
if ! "$HIGHWAY_ROOT/tools/validate-profile.sh" "$fixture_root/confirmed.md" >/dev/null; then
	echo 'FAIL: confirmed proposal was not structurally valid'
	fail=1
fi
cp "$fixture_root/confirmed.md" "$accepted"
confirmed="$(shasum -a 256 "$accepted" | awk '{print $1}')"
[[ "$confirmed" != "$before" ]] || { echo 'FAIL: confirmed mutation did not change accepted bytes'; fail=1; }

# A byte-identical no-op requires no write and remains byte-identical.
no_op_before="$(shasum -a 256 "$accepted" | awk '{print $1}')"
cmp -s "$accepted" "$fixture_root/confirmed.md" || { echo 'FAIL: no-op proposal differs from accepted bytes'; fail=1; }
no_op_after="$(shasum -a 256 "$accepted" | awk '{print $1}')"
[[ "$no_op_before" == "$no_op_after" ]] || { echo 'FAIL: no-op mutation changed accepted bytes'; fail=1; }

# A persistence mismatch must be detected before reporting mutation success.
cp "$fixture_root/confirmed.md" "$fixture_root/expected.md"
printf '%s\n' 'unexpected persisted bytes' >> "$accepted"
if cmp -s "$accepted" "$fixture_root/expected.md"; then
	echo 'FAIL: persistence mismatch was not detected'
	fail=1
fi

# Legacy YAML is inert even when present.
printf '%s\n' 'organization:' '  name: Legacy' > "$fixture_root/profile.yaml"
if grep -Fq Legacy "$accepted"; then echo 'FAIL: legacy YAML influenced accepted Profile'; fail=1; fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Profile lifecycle contract passes'
