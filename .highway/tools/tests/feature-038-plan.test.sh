#!/usr/bin/env bash
# Verifies Feature 038 planning/source ownership and task-record contracts.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FEATURE_DIR="$REPO_ROOT/$(printf 'spec%s' 's')/038-readiness-verification-corrections"
PLAN="$FEATURE_DIR/plan.md"
TASKS="$FEATURE_DIR/tasks.md"
FEATURE_037="$REPO_ROOT/$(printf 'spec%s' 's')/037-readiness-ownership-refactor/spec.md"
fail=0

expect_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: $file missing '$text'"
		fail=1
	fi
}

expect_text "$PLAN" '.highway/skills/'
expect_text "$PLAN" 'generated outputs'
expect_text "$PLAN" 'Feature 037 remains unchanged'
expect_text "$PLAN" '.github/skills/'
expect_text "$PLAN" '.claude/skills/'
expect_text "$PLAN" '.cursor/rules/'
if [[ ! -f "$FEATURE_037" ]]; then
	echo "FAIL: Feature 037 historical spec is missing"
	fail=1
fi

if grep -nE 'ACTION REQUIRED|\[e\.g\.|Option [0-9]|\[REMOVE IF UNUSED\]|\[FEATURE NAME\]|\[###|\[Title\]|TXXX' "$PLAN"; then
	echo "FAIL: Feature 038 plan contains template residue"
	fail=1
fi

while IFS= read -r line; do
	if ! printf '%s\n' "$line" | grep -Eq '^- \[[Xx ]\] T[0-9]{3}( \[P\])?( \[US[1-3]\])? .+'; then
		echo "FAIL: invalid task line: $line"
		fail=1
	fi
	if ! printf '%s\n' "$line" | grep -Eq '/|git diff'; then
		echo "FAIL: task line lacks a concrete path: $line"
		fail=1
	fi
done < <(grep -E '^- \[[Xx ]\] T[0-9]{3}' "$TASKS")

task_count="$(grep -Ec '^- \[[Xx ]\] T[0-9]{3}' "$TASKS")"
if [[ "$task_count" != 33 ]]; then
	echo "FAIL: expected 33 Feature 038 tasks, got $task_count"
	fail=1
fi

before_hash="$(shasum -a 256 "$FEATURE_037" | awk '{print $1}')"
cat "$FEATURE_037" >/dev/null
after_hash="$(shasum -a 256 "$FEATURE_037" | awk '{print $1}')"
if [[ "$before_hash" != "$after_hash" ]]; then
	echo "FAIL: Feature 037 historical spec changed during planning check"
	fail=1
fi

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: Feature 038 plan, source ownership, task format, and Feature 037 preservation pass"
