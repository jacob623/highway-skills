#!/usr/bin/env bash
# Verifies owner-specific readiness state rules from the Feature 037 contracts.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
HIGHWAY_ROOT="$REPO_ROOT/.highway"
. "$SCRIPT_DIR/test-helpers.sh"
fail=0

expect_state() {
	local owner="$1" state="$2" expected="$3"
	local file="$HIGHWAY_ROOT/skills/highway-$owner/SKILL.md"
	if ! grep -Fq "$expected" "$file"; then
		echo "FAIL: $owner $state state is not documented as '$expected'"
		fail=1
	fi
}

expect_state profile missing '`Missing`'
expect_state profile complete '`Complete`'
expect_state objectives missing '`Missing`'
expect_state objectives blocked '`Blocked`'
expect_state objectives complete '`Complete`'
expect_state controls missing '`Missing`'
expect_state controls blocked '`Blocked`'
expect_state controls complete '`Complete`'
expect_state nfrs blocked '`Blocked`'
expect_state nfrs not_applicable '`Not Applicable`'
expect_state nfrs in_progress '`In Progress`'
expect_state nfrs complete '`Complete`'

nfr_file="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
for rule in 'zero candidates' 'none accepted' 'unavailable' 'malformed' 'contradictory'; do
	if ! grep -Fqi "$rule" "$nfr_file"; then
		echo "FAIL: NFR readiness rule '$rule' is not documented"
		fail=1
	fi
done
if grep -Eq 'NFR[^[:alnum:]]+`?Missing`?|`Missing`[^[:alnum:]]+NFR' "$nfr_file"; then
	echo "FAIL: NFR owner state matrix exposes Missing"
	fail=1
fi

for owner in profile objectives controls nfrs; do
	file="$HIGHWAY_ROOT/skills/highway-$owner/SKILL.md"
	before_hash="$(shasum -a 256 "$file" | cut -d ' ' -f 1)"
	case "$owner" in
		profile) grep -Fq 'organization.name' "$file" ;;
		objectives) grep -Fq 'next_id' "$file" ;;
		controls) grep -Fq 'valid Control' "$file" ;;
		nfrs) grep -Fq 'In Progress' "$file" ;;
	esac
	if [[ $? -ne 0 ]]; then
		echo "FAIL: $owner readiness state evidence missing"
		fail=1
	fi
	after_hash="$(shasum -a 256 "$file" | cut -d ' ' -f 1)"
	if ! assert_file_unchanged "$owner owner skill" "$before_hash" "$after_hash"; then
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: owner readiness state matrix passes"
