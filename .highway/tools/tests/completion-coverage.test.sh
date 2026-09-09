#!/usr/bin/env bash
# Exercises completion-accountability records and decides the mechanical D7.2 coverage rule.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SPEC_DIR="spec""s"
FEATURE_DIR="$REPO_ROOT/$SPEC_DIR/021-completion-claim-accountability"
fail=0
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

trim() {
	printf '%s' "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

spec_ids() {
	grep -E '^-[[:space:]]*\*\*FR-[0-9]+\*\*:' "$1/spec.md" \
		| sed -E 's/^-[[:space:]]*\*\*(FR-[0-9]+)\*\*:.*/\1/' | sort
}

coverage_rows() {
	grep -E '^\|[[:space:]]*FR-[0-9]+[[:space:]]*\|' "$1/coverage.md" \
		| sed -E 's/^\|[[:space:]]*(FR-[0-9]+)[[:space:]]*\|[[:space:]]*([^|]+)[[:space:]]*\|[[:space:]]*(.*)[[:space:]]*\|$/\1\t\2\t\3/'
}

coverage_check() {
	feature_dir="$1"
	local_errors=0
	if [[ ! -f "$feature_dir/spec.md" || ! -f "$feature_dir/coverage.md" ]]; then
		echo "MISSING_COVERAGE: $feature_dir"
		return 1
	fi

	spec_file="$work_dir/spec-ids-$$"
	row_file="$work_dir/coverage-rows-$$"
	spec_ids "$feature_dir" >"$spec_file"
	coverage_rows "$feature_dir" >"$row_file"

	while IFS=$'\t' read -r requirement outcome evidence; do
		requirement="$(trim "$requirement")"
		outcome="$(trim "$outcome")"
		evidence="$(trim "$evidence")"
		[[ -n "$requirement" ]] || continue
		if [[ "$outcome" != "satisfied" && "$outcome" != "deferred" ]]; then
			echo "FAIL: malformed outcome for $requirement: $outcome"
			local_errors=1
		fi
		if [[ -z "$evidence" ]]; then
			echo "FAIL: malformed evidence for $requirement"
			local_errors=1
		fi
		if [[ "$outcome" == "satisfied" && -n "$evidence" ]]; then
			artifact="${evidence%%:*}"
			artifact="$(printf '%s' "$artifact" | sed 's/[` ]//g')"
			if [[ ! -f "$REPO_ROOT/$artifact" && ! -f "$feature_dir/$artifact" ]]; then
				echo "FAIL: satisfying artifact for $requirement does not exist: $artifact"
				local_errors=1
			fi
		fi
	done <"$row_file"

	row_ids="$work_dir/row-ids-$$"
	cut -f1 "$row_file" | sort >"$row_ids"
	duplicates="$(uniq -d "$row_ids")"
	if [[ -n "$duplicates" ]]; then
		echo "FAIL: duplicate requirement id(s): $duplicates"
		local_errors=1
	fi

	missing="$(comm -23 "$spec_file" "$row_ids")"
	if [[ -n "$missing" ]]; then
		echo "FAIL: missing requirement id(s): $missing"
		local_errors=1
	fi

	unknown="$(comm -13 "$spec_file" "$row_ids")"
	if [[ -n "$unknown" ]]; then
		echo "FAIL: unknown requirement id(s): $unknown"
		local_errors=1
	fi

	return "$local_errors"
}

assert_pass() {
	label="$1"
	shift
	output_file="$work_dir/assert-output"
	if "$@" >"$output_file" 2>&1; then
		echo "PASS: $label"
	else
		echo "FAIL: $label"
		cat "$output_file"
	fail=1
	fi
}

assert_fail() {
	label="$1"
	shift
	if "$@" >/dev/null 2>&1; then
		echo "FAIL: $label unexpectedly passed"
		fail=1
	else
		echo "PASS: $label failed as expected"
	fi
}

make_coverage_fixture() {
	fixture="$work_dir/coverage-fixture"
	mkdir -p "$fixture"
	printf '%s\n' \
		'- **FR-001**: first requirement' \
		'- **FR-002**: second requirement' >"$fixture/spec.md"
	printf '%s\n' '# Artifact' >"$fixture/artifact.md"
	printf '%s\n' \
		'| Requirement | Outcome | Evidence |' \
		'|---|---|---|' \
		'| FR-001 | satisfied | artifact.md: present |' \
		'| FR-002 | deferred | owned by a later feature |' >"$fixture/coverage.md"
	printf '%s' "$fixture"
}

evidence_check() {
	evidence_file="$1"
	evidence_rows="$work_dir/evidence-rows-$$"
	grep -E '^\|[[:space:]]*T[0-9]+' "$evidence_file" \
		| sed -E 's/^\|[[:space:]]*([^|]+)\|[[:space:]]*([^|]+)\|[[:space:]]*([^|]+)\|[[:space:]]*([^|]+)\|[[:space:]]*([^|]+)\|[[:space:]]*([^|]+)\|.*/\1\t\2\t\3\t\4\t\5\t\6/' \
		>"$evidence_rows"
	[[ -s "$evidence_rows" ]] || return 1
	while IFS=$'\t' read -r task reference behavior failing passing status; do
		task="$(trim "$task")"
		behavior="$(trim "$behavior")"
		failing="$(trim "$failing")"
		passing="$(trim "$passing")"
		status="$(trim "$status")"
		[[ -n "$task" && -n "$reference" && -n "$behavior" && -n "$failing" && -n "$passing" ]] || return 1
		printf '%s' "$failing" | grep -qi 'behavior-specific' || return 1
		printf '%s' "$passing" | grep -qi 'behavior-specific' || return 1
		[[ "$status" == "observed" ]] || return 1
	done <"$evidence_rows"
	grep -qi 'static prose-contract' "$evidence_file" || return 1
}

task_correspondence_check() {
	tasks_file="$1"
	while IFS= read -r task_line; do
		[[ "$task_line" == '- [X]'* ]] || continue
		artifact="$(printf '%s\n' "$task_line" | awk '{print $4}')"
		change="$(printf '%s\n' "$task_line" | sed -n 's/.*change:[[:space:]]*//p')"
		[[ -n "$change" ]] || return 1
		[[ -f "$(dirname "$tasks_file")/$artifact" ]] || return 1
		grep -q "$change" "$(dirname "$tasks_file")/$artifact" || return 1
	done <"$tasks_file"
}

report_check() {
	report="$1"
	grep -q '^## Check Results$' "$report" || return 1
	grep -q '^## Requirement Coverage$' "$report" || return 1
	grep -q '^## Task Status$' "$report" || return 1
	if grep -Eiq 'deferred|incomplete|unchecked' "$report"; then
		grep -qi 'qualified' "$report" || return 1
	fi
	if grep -Eiq 'deferred|incomplete|unchecked' "$report" && grep -Eiq '^status:[[:space:]]*complete$|^complete$' "$report"; then
		return 1
	fi
}

# D7.2's live feature record must be mechanically complete.
assert_pass "Feature 021 coverage record" coverage_check "$FEATURE_DIR"

# Failure proof: remove one requirement id, observe failure, then restore and observe pass.
fixture="$(make_coverage_fixture)"
assert_pass "valid coverage fixture" coverage_check "$fixture"
grep -v '| FR-002 |' "$fixture/coverage.md" >"$fixture/coverage.tmp"
mv "$fixture/coverage.tmp" "$fixture/coverage.md"
assert_fail "missing requirement id" coverage_check "$fixture"
printf '%s\n' \
	'| Requirement | Outcome | Evidence |' \
	'|---|---|---|' \
	'| FR-001 | satisfied | artifact.md: present |' \
	'| FR-002 | deferred | owned by a later feature |' >"$fixture/coverage.md"
assert_pass "restored requirement id" coverage_check "$fixture"

# D3.6 evidence accepts both executable and static prose-contract test claims.
assert_pass "behavior-specific red-to-green evidence" evidence_check "$FEATURE_DIR/test-evidence.md"
printf '%s\n' 'Passing observation only' >"$work_dir/missing-evidence.md"
assert_fail "missing failing observation" evidence_check "$work_dir/missing-evidence.md"
printf '%s\n' \
	'| Task | Test reference | Claimed behavior | Failing observation | Passing observation | Status |' \
	'|---|---|---|---|---|---|' \
	'| T999 | test.sh | required behavior | unrelated red output only | behavior-specific pass | observed |' \
	'| Static | test.sh | static prose-contract behavior | behavior-specific failure | behavior-specific pass | observed |' \
	'Static prose-contract evidence is allowed.' >"$work_dir/unrelated-red.md"
assert_fail "unrelated red output" evidence_check "$work_dir/unrelated-red.md"

# D7.1 structural part: missing paths fail; semantic described-change review remains agent-checkable.
task_fixture="$work_dir/task-fixture"
mkdir -p "$task_fixture"
printf '%s\n' 'required marker' >"$task_fixture/artifact.md"
printf '%s\n' '- [X] T001 artifact.md change: required marker' >"$task_fixture/tasks.md"
assert_pass "accurate task correspondence" task_correspondence_check "$task_fixture/tasks.md"
printf '%s\n' '- [X] T001 missing-artifact.md change: required marker' >"$task_fixture/tasks.md"
assert_fail "missing task artifact" task_correspondence_check "$task_fixture/tasks.md"
printf '%s\n' '- [X] T001 artifact.md change: absent marker' >"$task_fixture/tasks.md"
assert_fail "absent described change" task_correspondence_check "$task_fixture/tasks.md"

# D7.3 report claims remain distinct from check results and qualify deferred work.
report_fixture="$work_dir/report.md"
printf '%s\n' \
	'## Check Results' \
	'- run-all.sh: PASS' \
	'## Requirement Coverage' \
	'- FR-001: satisfied' \
	'- FR-002: deferred' \
	'## Task Status' \
	'- all tasks reviewed' \
	'## Status' \
	'qualified' >"$report_fixture"
assert_pass "separated qualified completion report" report_check "$report_fixture"
printf '%s\n' '## Check Results' '- run-all.sh: PASS' '- complete' >"$work_dir/bad-report.md"
assert_fail "conflated completion report" report_check "$work_dir/bad-report.md"
printf '%s\n' \
	'## Check Results' \
	'- run-all.sh: PASS' \
	'## Requirement Coverage' \
	'- FR-001: satisfied' \
	'## Task Status' \
	'- T001: incomplete' \
	'## Status' \
	'complete' >"$work_dir/incomplete-report.md"
assert_fail "incomplete task cannot be complete" report_check "$work_dir/incomplete-report.md"

# Checked-in fixtures are part of the contract and must remain exercised by this test.
FIXTURES="$HIGHWAY_ROOT/tools/tests/fixtures/completion-claim-accountability"
assert_pass "checked-in valid coverage fixture" coverage_check "$FIXTURES/coverage-valid"
assert_pass "checked-in static prose evidence" evidence_check "$FIXTURES/static-prose/evidence.md"
assert_pass "checked-in valid report" report_check "$FIXTURES/report-valid/report.md"
assert_fail "checked-in invalid report" report_check "$FIXTURES/report-invalid/report.md"
assert_pass "checked-in deferred report" report_check "$FIXTURES/report-deferred/report.md"

# Pre-enable assessment: report every completed historical feature without fabricating coverage.
for feature_dir in "$REPO_ROOT"/$SPEC_DIR/[0-9][0-9][0-9]-*; do
	[[ -d "$feature_dir" ]] || continue
	[[ -f "$feature_dir/tasks.md" ]] || continue
	if ! grep -q '^- \[ \]' "$feature_dir/tasks.md"; then
		if [[ -f "$feature_dir/coverage.md" ]]; then
			echo "PRE_ENABLE: $(basename "$feature_dir") coverage present"
		else
			echo "PRE_ENABLE: $(basename "$feature_dir") MISSING_COVERAGE"
		fi
	fi
done

exit "$fail"
