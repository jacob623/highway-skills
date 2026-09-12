#!/usr/bin/env bash
# Tests .highway/tools/validate-skill.sh against the fixtures in .highway/tools/tests/fixtures/.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

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
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-nondeterministic-criterion" "decision criterion references"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-undeclared-key" "undeclared top-level key 'licence'"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-duplicate-key" "duplicate top-level key 'description'"

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
assert_single_failure "$FIXTURES/invalid-skill-nondeterministic-criterion" "P6.4"
assert_single_failure "$FIXTURES/invalid-skill-undeclared-key" "SCHEMA"
assert_single_failure "$FIXTURES/invalid-skill-duplicate-key" "SCHEMA"
assert_single_failure "$FIXTURES/invalid-skill-short-description" "SCHEMA"

# A no-op re-run must reproduce the identical failure (the fixture is unaffected by having been
# checked before).
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-undeclared-key" "undeclared top-level key 'licence'"
assert_exit_nonzero_naming "$FIXTURES/invalid-skill-duplicate-key" "duplicate top-level key 'description'"

# A malformed frontmatter contract manifest (a duplicate scope/key row) is reported as an error
# and blocks every per-skill check (FR-003). Uses FRONTMATTER_CONTRACT_FILE to point at a
# temporary, mutated copy so the real manifest is never touched.
malformed_manifest_tmp="$(mktemp)"
cp "$HIGHWAY_ROOT/tools/.frontmatter-contract" "$malformed_manifest_tmp"
printf 'top\tname\tyes\tkebab-case\n' >> "$malformed_manifest_tmp"
malformed_manifest_out="$(FRONTMATTER_CONTRACT_FILE="$malformed_manifest_tmp" "$VALIDATE" "$FIXTURES/valid-skill" 2>&1)"
malformed_manifest_rc=$?
rm -f "$malformed_manifest_tmp"
if [[ $malformed_manifest_rc -eq 0 ]]; then
	echo "FAIL: expected non-zero exit for a malformed frontmatter contract manifest, got 0. Output:"
	echo "$malformed_manifest_out"
	fail=1
elif [[ "$malformed_manifest_out" != *"duplicate entry"* ]]; then
	echo "FAIL: expected the malformed-manifest error to mention 'duplicate entry'. Got:"
	echo "$malformed_manifest_out"
	fail=1
fi

exit $fail
