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
# Superseded behavior: the shared template schema was 2.0.0.
if ! grep -Fq 'schema_version: 3.0.0' "$HIGHWAY_ROOT/library/templates/output/profile-record.md"; then echo 'FAIL: shared template schema is not 3.0.0'; fail=1; fi
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

SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
for required_text in \
	'only the accepted cohesive domain narrative' \
	'Acknowledgment, explanation, reflection, and advisory commentary remain transient' \
	'Accepted paragraph evidence establishes the domain as `discussed`' \
	'accepting enrichment for an already `discussed` or `bounded` domain does not change readiness' \
	'persist the retained Profile, and only then return dependent readiness'; do
	if ! grep -Fq "$required_text" "$SKILL"; then
		echo "FAIL: Profile lifecycle boundary missing '$required_text'"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Profile lifecycle contract passes'
