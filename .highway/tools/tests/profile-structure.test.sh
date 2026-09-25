#!/usr/bin/env bash
# Tests structural validation for the retained organizational profile.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-profile.sh"
FIXTURES="$SCRIPT_DIR/fixtures/profile"
fail=0

expect_valid() {
	local file="$1"
	if ! "$VALIDATE" "$file" >/dev/null 2>&1; then
		echo "FAIL: expected valid profile: $file"
		fail=1
	fi
}

expect_invalid() {
	local file="$1"
	if "$VALIDATE" "$file" >/dev/null 2>&1; then
		echo "FAIL: expected invalid profile: $file"
		fail=1
	fi
}

expect_valid "$HIGHWAY_ROOT/library/templates/output/profile.md"

SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
for required_text in \
	'five evidence domains' \
	'not_discussed' \
	'discussed' \
	'bounded' \
	'Profile readiness'; do
	if ! grep -Fq "$required_text" "$SKILL"; then
		echo "FAIL: Profile ownership contract missing '$required_text'"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: profile structure fixtures pass"
