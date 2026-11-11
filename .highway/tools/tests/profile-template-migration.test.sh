#!/usr/bin/env bash
# Verifies the Profile template/artifact boundary: the record template ships, and highway-profile
# writes the user-owned Profile rather than reading a framework-tree copy.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
TEMPLATE="$(hw_template profile-record)"
MANIFEST="$HW_TOOLS/.distribution-manifest"
fail=0

[[ -f "$TEMPLATE" ]] || { echo 'FAIL: Profile record template is missing'; fail=1; }
grep -Fq 'library/knowledge/profile.md' "$HW_SKILLS/highway-profile/SKILL.md" || {
	echo 'FAIL: Profile skill omits the retained user-owned artifact path'
	fail=1
}
grep -Fq 'Do not read, copy, or review `.highway/library/knowledge/profile.md`' "$HW_SKILLS/highway-profile/SKILL.md" || {
	echo 'FAIL: Profile skill does not ignore the framework-tree profile'
	fail=1
}
grep -Fq 'library/templates/output/profile-record.md' "$MANIFEST" || {
	echo 'FAIL: distribution manifest omits profile-record.md'
	fail=1
}

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Profile template boundary passes'
