#!/usr/bin/env bash
# Verifies the highway-profile skill's behavioral contract.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
PROFILE="$HIGHWAY_ROOT/library/templates/output/profile.yaml"
# shellcheck source=tools/lib/profile.sh
source "$HIGHWAY_ROOT/tools/lib/profile.sh"
fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

require_text "$SKILL" '.highway/library/templates/output/profile.yaml'
require_text "$SKILL" 'setup'
require_text "$SKILL" 'configure'
require_text "$SKILL" 'view'
require_text "$SKILL" 'show'
require_text "$SKILL" 'describe'
require_text "$SKILL" 'add'
require_text "$SKILL" 'update'
require_text "$SKILL" 'remove'
require_text "$SKILL" 'reset'
require_text "$SKILL" 'Confirmation Status'
require_text "$SKILL" 'Affected Entries'
require_text "$SKILL" 'NFR'
require_text "$SKILL" 'Control'
require_text "$SKILL" 'byte-for-byte unchanged'
require_text "$SKILL" 'fourteen context questions'
require_text "$SKILL" 'business_context'
require_text "$SKILL" 'vendor_strategy'

if grep -Eq 'timestamp|random identifier|environment-derived value' "$PROFILE"; then
	echo "FAIL: distributed profile contains a generated-value marker"
	fail=1
fi

before="$(shasum -a 256 "$PROFILE" | awk '{print $1}')"
# Read-only contract checks are static because the skill is an instruction artifact.
require_text "$SKILL" 'without changing it'
require_text "$SKILL" 'without creating a file'
after="$(shasum -a 256 "$PROFILE" | awk '{print $1}')"
if [[ "$before" != "$after" ]]; then
	echo "FAIL: read-only checks changed the distributed profile"
	fail=1
fi

[[ "$(profile_next_version 1.0.0 add)" == "1.0.1" ]] || { echo "FAIL: add version increment"; fail=1; }
[[ "$(profile_next_version 1.0.1 update)" == "1.0.2" ]] || { echo "FAIL: update version increment"; fail=1; }
[[ "$(profile_next_version 1.0.2 remove)" == "1.0.3" ]] || { echo "FAIL: remove version increment"; fail=1; }
[[ "$(profile_next_version 1.0.3 reset)" == "1.1.0" ]] || { echo "FAIL: reset version increment"; fail=1; }
[[ "$(profile_next_version 1.1.0 schema-breaking)" == "2.0.0" ]] || { echo "FAIL: schema-breaking version increment"; fail=1; }
if profile_next_version 1.0.0 declined >/dev/null 2>&1; then
	echo "FAIL: declined operation produced a version"
	fail=1
fi

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: profile behavior contract passes"
