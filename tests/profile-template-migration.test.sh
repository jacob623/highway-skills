#!/usr/bin/env bash
# Verifies the Profile template/artifact boundary: the record template ships inside highway-profile,
# and highway-profile writes the user-owned Profile without naming a framework-tree copy.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
TEMPLATE="$(hw_template profile-record)"
SKILL="$HW_SKILLS/highway-profile/SKILL.md"
MANIFEST="$HW_FRAMEWORK/.distribution-manifest"
fail=0

[[ -f "$TEMPLATE" ]] || { echo 'FAIL: Profile record template is missing'; fail=1; }
grep -Fq 'assets/profile-record.md' "$SKILL" || {
	echo 'FAIL: Profile skill does not name its template as assets/profile-record.md'
	fail=1
}
grep -Fq 'library/knowledge/profile.md' "$SKILL" || {
	echo 'FAIL: Profile skill omits the retained user-owned artifact path'
	fail=1
}
if grep -Fq '.highway/library/knowledge/' "$SKILL"; then
	echo 'FAIL: Profile skill still names .highway/library/knowledge/'
	fail=1
fi
if grep -Fq 'profile-record.md' "$MANIFEST"; then
	echo 'FAIL: distribution manifest still lists profile-record.md under .highway/; it ships inside highway-profile'
	fail=1
fi

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Profile template boundary passes'
