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

expect_valid "$HIGHWAY_ROOT/library/templates/output/profile.yaml"
expect_valid "$FIXTURES/valid-populated.yaml"
expect_valid "$FIXTURES/valid-future-sections.yaml"
expect_invalid "$FIXTURES/malformed.yaml"
expect_invalid "$FIXTURES/missing-metadata.yaml"
expect_invalid "$FIXTURES/wrong-order.yaml"
expect_invalid "$FIXTURES/empty-section.yaml"
expect_invalid "$FIXTURES/generated-value.yaml"

SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
for required_text in \
	'What is the name of the organization, business unit, team, or project group this repository represents?' \
	'organization.name' \
	'whitespace-only' \
	'does not infer organization identity' \
	'Profile cannot report `Complete`'; do
	if ! grep -Fq "$required_text" "$SKILL"; then
		echo "FAIL: Profile ownership contract missing '$required_text'"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: profile structure fixtures pass"
