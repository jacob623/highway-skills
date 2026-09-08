#!/usr/bin/env bash
# Tests .highway/tools/validate-library.sh against the fixtures in
# tools/tests/fixtures/library/. See
# feature 005 (rename content to library).
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-library.sh"
FIXTURES="$SCRIPT_DIR/fixtures/library"

fail=0

assert_exit_zero() {
	local file="$1"
	local out
	out="$("$VALIDATE" "$file" 2>&1)"
	local rc=$?
	if [[ $rc -ne 0 ]]; then
		echo "FAIL: expected exit 0 for '$file', got $rc. Output:"
		echo "$out"
		fail=1
	fi
	printf '%s' "$out"
}

assert_single_failure() {
	local file="$1" expected_tag="$2"
	local out findings count
	out="$("$VALIDATE" "$file" 2>&1)"
	local rc=$?
	if [[ $rc -eq 0 ]]; then
		echo "FAIL: expected non-zero exit for '$file', got 0. Output:"
		echo "$out"
		fail=1
		return
	fi
	findings="$(printf '%s\n' "$out" | grep '^ERROR: ' || true)"
	count="$(printf '%s\n' "$findings" | grep -c '^ERROR: ' | tr -d ' ')"
	if [[ "$count" -ne 1 ]]; then
		echo "FAIL: expected exactly 1 finding for '$file', got $count:"
		printf '%s\n' "$findings" | sed 's/^/    /'
		fail=1
		return
	fi
	if [[ "$findings" != *"[$expected_tag]"* ]]; then
		echo "FAIL: expected the single finding for '$file' to be tagged [$expected_tag]. Got: $findings"
		fail=1
	fi
}

# Valid governance and knowledge fixtures pass.
assert_exit_zero "$FIXTURES/governance/valid/policy.md" >/dev/null
assert_exit_zero "$FIXTURES/knowledge/valid/reference.md" >/dev/null

# Each seeded violation is detected and named by rule ID.
assert_single_failure "$FIXTURES/governance/invalid-bad-citation/policy.md" "P3.5"
assert_single_failure "$FIXTURES/knowledge/invalid-two-keywords/reference.md" "P1.1"

# A valid template whose placeholder text contains the literal word "MUST" still passes, with
# the four keyword/word-limit rules reported N/A under condition N2 -- not silently skipped.
template_out="$(assert_exit_zero "$FIXTURES/templates/valid/output-shape.md")"
if [[ "$template_out" != *"N/A:"*"P1.1=N2"*"P1.3=N2"*"P7.4=N2"*"P7.5=N2"* ]]; then
	echo "FAIL: expected the template's N/A group to contain P1.1=N2 P1.3=N2 P7.4=N2 P7.5=N2. Got:"
	echo "$template_out"
	fail=1
fi

# A template missing metadata.version fails via rule P7.2 (not a duplicate [SCHEMA] finding --
# version format has exactly one owner, same as for a skill).
assert_single_failure "$FIXTURES/templates/invalid-missing-version/output-shape.md" "P7.2"

# A file outside the three recognized library directories fails library-type detection.
assert_single_failure "$FIXTURES/invalid-orphan/orphan.md" "LIBRARY-TYPE"

exit $fail
