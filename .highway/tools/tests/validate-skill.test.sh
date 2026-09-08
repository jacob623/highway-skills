#!/usr/bin/env bash
# Tests .highway/tools/validate-skill.sh against the fixtures in .highway/tools/tests/fixtures/.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-skill.sh"
FIXTURES="$SCRIPT_DIR/fixtures"

fail=0

assert_exit_zero() {
	local dir="$1"
	local out
	out="$("$VALIDATE" "$dir" 2>&1)"
	local rc=$?
	if [[ $rc -ne 0 ]]; then
		echo "FAIL: expected exit 0 for '$dir', got $rc. Output:"
		echo "$out"
		fail=1
	fi
}

assert_exit_nonzero_naming() {
	local dir="$1" expected_substring="$2"
	local out
	out="$("$VALIDATE" "$dir" 2>&1)"
	local rc=$?
	if [[ $rc -eq 0 ]]; then
		echo "FAIL: expected non-zero exit for '$dir', got 0. Output:"
		echo "$out"
		fail=1
		return
	fi
	if [[ "$out" != *"$expected_substring"* ]]; then
		echo "FAIL: expected error output for '$dir' to mention '$expected_substring'. Got:"
		echo "$out"
		fail=1
	fi
}

assert_exit_zero "$FIXTURES/valid-skill"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-missing-version" "metadata.version"
assert_exit_nonzero_naming "$FIXTURES/invalid_skill_bad_id" "invalid id"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-long-description" "description"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-missing-usage" "usage"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-missing-example" "'## Example'"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-name-mismatch" "does not match directory-derived id"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-relative-link" "is a relative path"

# Every skill-shaped artifact in the repository that is meant to be valid must pass, so that an
# author copying one inherits a conforming skill (SC-001).
for skill_dir in "$HIGHWAY_ROOT"/skills/*/; do
	[[ -f "$skill_dir/SKILL.md" ]] || continue
	assert_exit_zero "$skill_dir"
done

# Each intentionally invalid fixture must fail for its one stated reason and no other (FR-012).
assert_single_failure() {
	local dir="$1" expected_tag="$2"
	local out findings count
	out="$("$VALIDATE" "$dir" 2>&1)"
	findings="$(printf '%s\n' "$out" | grep '^ERROR: ' || true)"
	count="$(printf '%s\n' "$findings" | grep -c '^ERROR: ' | tr -d ' ')"
	if [[ "$count" -ne 1 ]]; then
		echo "FAIL: expected exactly 1 finding for '$dir', got $count:"
		printf '%s\n' "$findings" | sed 's/^/    /'
		fail=1
		return
	fi
	if [[ "$findings" != *"[$expected_tag]"* ]]; then
		echo "FAIL: expected the single finding for '$dir' to be tagged [$expected_tag]. Got: $findings"
		fail=1
	fi
}

assert_single_failure "$FIXTURES/invalid-skill-missing-version" "P7.2"
assert_single_failure "$FIXTURES/invalid_skill_bad_id" "SCHEMA"
assert_single_failure "$FIXTURES/invalid-skill-long-description" "SCHEMA"
assert_single_failure "$FIXTURES/invalid-skill-missing-usage" "SCHEMA"
assert_single_failure "$FIXTURES/invalid-skill-missing-example" "SCHEMA"
assert_single_failure "$FIXTURES/invalid-skill-name-mismatch" "SCHEMA"
assert_single_failure "$FIXTURES/invalid-skill-relative-link" "P8.7"

exit $fail
