#!/usr/bin/env bash
# Verifies the Feature 091 Markdown Profile contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$HIGHWAY_ROOT/tools/lib/profile.sh"
VALIDATE="$HIGHWAY_ROOT/tools/validate-profile.sh"
fail=0
fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-profile-091.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT

valid="$fixture_root/profile.md"
cp "$HIGHWAY_ROOT/library/templates/output/profile.md" "$valid"
if ! "$VALIDATE" "$valid" >/dev/null; then echo 'FAIL: shared template is invalid'; fail=1; fi

sed -i '' 's/identity: not_discussed/identity: discussed/' "$valid"
printf '%s\n' '## Who We Are' 'A user-supplied organization.' >> "$valid"
if ! "$VALIDATE" "$valid" >/dev/null; then echo 'FAIL: discussed Profile fixture is invalid'; fail=1; fi

if [[ "$(profile_next_version 2.0.0 add)" != 2.0.1 ]]; then echo 'FAIL: content mutation version helper failed'; fail=1; fi
if [[ "$(profile_next_version 2.0.0 schema-breaking)" != 3.0.0 ]]; then echo 'FAIL: schema version transition failed'; fail=1; fi

before="$(shasum -a 256 "$valid" | awk '{print $1}')"
after="$(shasum -a 256 "$valid" | awk '{print $1}')"
if [[ "$before" != "$after" ]]; then echo 'FAIL: read-only readiness changed Profile bytes'; fail=1; fi

if grep -Fq '.highway/library/templates/output/profile.yaml' "$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"; then echo 'FAIL: active skill references obsolete YAML'; fail=1; fi
if ! grep -Fq '.highway/library/knowledge/profile.md' "$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"; then echo 'FAIL: active skill omits authoritative Markdown path'; fail=1; fi
if ! grep -Fq 'proposal evidence' "$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"; then echo 'FAIL: proposal evidence lifecycle missing'; fail=1; fi

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Markdown Profile behavior contract passes'
