#!/usr/bin/env bash
# Verifies declared context roles, absence handling, precedence, and participation boundaries.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, disposable-fixture
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FIXTURES="$SCRIPT_DIR/fixtures/profile-092"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
CONTROLS="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md"
fail=0
require() { grep -Fq -- "$2" "$1" || { echo "FAIL: $1 missing '$2'"; fail=1; }; }
for text in \
	'Profile-owned `Blocked`' \
	'Action Status: Blocked' \
	'other unavailable optional context is excluded' \
	'complete direct obligation' \
	'active user input wins'; do
	require "$CONTROLS" "$text"
done
require "$PROFILE" 'highway-identity.md'
require "$PROFILE" 'shared, non-normative context only'
for retired_context in highway-vision.md highway-platform-objectives.md; do
	if grep -Fq "$retired_context" "$PROFILE"; then
		echo "FAIL: Profile retains retired runtime context $retired_context"
		fail=1
	fi
done
require "$PROFILE" 'it is not retained as organizational fact'
require "$PROFILE" 'Accepted evidence that establishes a domain sets it to `discussed`'
require "$FIXTURES/repository-context/conflicts/workflow-input-authoritative.txt" 'workflow-specific input remains authoritative'
require "$FIXTURES/participation/reference/SKILL.md" '.highway/library/knowledge/profile.md'
if grep -Fq '.highway/library/knowledge/profile.md' "$FIXTURES/participation/negative/SKILL.md"; then
	echo 'FAIL: negative participant declares Profile context'; fail=1
fi
[[ -f "$FIXTURES/repository-context/absent/README.md" ]] || { echo 'FAIL: absent context fixture missing'; fail=1; }
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Profile context contract passes'
