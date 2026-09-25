#!/usr/bin/env bash
# Verifies the Feature 092 template/artifact boundary.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: path and manifest assertions detect legacy-template reintroduction.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/profile-record.md"
MANIFEST="$HIGHWAY_ROOT/tools/.distribution-manifest"
OBSOLETE_MARKDOWN="library/templates/output/profile"".md"
OBSOLETE_YAML="library/templates/output/profile"".yaml"
fail=0

[[ -f "$TEMPLATE" ]] || { echo 'FAIL: replacement Profile template is missing'; fail=1; }
[[ ! -e "$HIGHWAY_ROOT/$OBSOLETE_MARKDOWN" ]] || { echo 'FAIL: obsolete Markdown template remains'; fail=1; }
[[ ! -e "$HIGHWAY_ROOT/$OBSOLETE_YAML" ]] || { echo 'FAIL: obsolete YAML template remains'; fail=1; }
grep -Fq '.highway/library/knowledge/profile.md' "$HIGHWAY_ROOT/skills/highway-profile/SKILL.md" || {
	echo 'FAIL: Profile skill omits the retained user-owned artifact path'
	fail=1
}
grep -Fq 'library/templates/output/profile-record.md' "$MANIFEST" || {
	echo 'FAIL: distribution manifest omits profile-record.md'
	fail=1
}
if grep -Fq "$OBSOLETE_MARKDOWN" "$MANIFEST" || grep -Fq "$OBSOLETE_YAML" "$MANIFEST"; then
	echo 'FAIL: distribution manifest retains an obsolete Profile template path'
	fail=1
fi
if grep -RInF "$OBSOLETE_MARKDOWN" \
	"$HIGHWAY_ROOT/skills" "$HIGHWAY_ROOT/governance" "$HIGHWAY_ROOT/library" "$HIGHWAY_ROOT/tools/.distribution-manifest" 2>/dev/null; then
	echo 'FAIL: active runtime or library contract references the obsolete Markdown template'
	fail=1
fi

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Profile template migration contract passes'
