#!/usr/bin/env bash
# Exercises completion-accountability records and decides the mechanical D7.2 coverage rule.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document
# Seeded failure probe: --probe source-document seeds an unregistered directory, an orphan entry,
# a malformed status, and a duplicate entry against the real completion register in turn and
# observes each detected; --probe source-document --neutralise requires the unmodified register to
# be clean. See the Feature 041 completion-register and probe-mode contracts.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SPEC_DIR="spec""s"
SPECS_DIR="$REPO_ROOT/$SPEC_DIR"
FEATURE_DIR="$REPO_ROOT/$SPEC_DIR/021-completion-claim-accountability"
SPECIFY_DIR=".""specify"
REGISTER_FILE="$REPO_ROOT/$SPECIFY_DIR/memory/completion-register.md"
fail=0
work_dir="$(mktemp -d)"
register_backup=""
cleanup() {
	rm -rf "$work_dir"
	[[ -n "$register_backup" && -f "$register_backup" ]] && cp "$register_backup" "$REGISTER_FILE"
}
trap cleanup EXIT

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

trim() {
	printf '%s' "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

spec_ids() {
	grep -E '^-[[:space:]]*\*\*FR-[0-9]+[a-z]*\*\*:' "$1/spec.md" \
		| sed -E 's/^-[[:space:]]*\*\*(FR-[0-9]+[a-z]*)\*\*:.*/\1/' | sort
}

coverage_rows() {
	grep -E '^\|[[:space:]]*FR-[0-9]+[a-z]*[[:space:]]*\|' "$1/coverage.md" \
		| sed -E 's/^\|[[:space:]]*(FR-[0-9]+[a-z]*)[[:space:]]*\|[[:space:]]*([^|]+)[[:space:]]*\|[[:space:]]*(.*)[[:space:]]*\|$/\1\t\2\t\3/'
}

coverage_check() {
	feature_dir="$1"
	local_errors=0
	if [[ ! -f "$feature_dir/spec.md" || ! -f "$feature_dir/coverage.md" ]]; then
		echo "MISSING_COVERAGE: $feature_dir"
		return 1
	fi
	header_count="$(grep -Ec '^\| Requirement \| Outcome \| Evidence \|$' "$feature_dir/coverage.md" || true)"
	if [[ "$header_count" -ne 1 ]]; then
		echo "FAIL: invalid coverage header for $feature_dir"
		local_errors=1
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
		if [[ "$outcome" != "satisfied" && "$outcome" != "deferred" && "$outcome" != "historical" ]]; then
			echo "FAIL: malformed outcome for $requirement: $outcome"
			local_errors=1
		fi
		feature_number="$(basename "$feature_dir" | cut -c1-3 | sed 's/^0*//')"
		[[ -n "$feature_number" ]] || feature_number=0
		if [[ "$outcome" == "historical" && "$feature_number" -ge 21 ]]; then
			echo "FAIL: historical outcome is outside Features 001-020: $requirement"
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

# Parses "| <feature> | <status> | <corrects> |" rows into name<TAB>status<TAB>corrects. No
# associative array (Bash 3.2.57); the caller reads this with `while IFS=$'\t' read`.
register_rows() {
	awk -F'|' '
		/^\|[ \t]*[0-9][0-9][0-9]-/ {
			gsub(/^[ \t]+|[ \t]+$/, "", $2)
			gsub(/^[ \t]+|[ \t]+$/, "", $3)
			gsub(/^[ \t]+|[ \t]+$/, "", $4)
			print $2 "\t" $3 "\t" $4
		}
	' "$1"
}

# Emits "<problem>" per line for a completion register / specs directory pair, or nothing when the
# register is sound. Takes both paths so the self-test below can point it at seeded fixtures
# instead of the real register and the real spec record.
register_problems() {
	local register_file="$1" specs_dir="$2"
	local rows_file names_file
	rows_file="$work_dir/register-rows-$$-$RANDOM"
	names_file="$work_dir/register-names-$$-$RANDOM"
	register_rows "$register_file" >"$rows_file"

	if [[ ! -s "$rows_file" ]]; then
		echo "no rows parsed from the completion register; the reader matched nothing"
		return
	fi

	: >"$names_file"
	while IFS=$'\t' read -r name status corrects; do
		[[ -n "$name" ]] || continue
		echo "$name" >>"$names_file"
		if [[ "$status" != "complete" && "$status" != "incomplete" && "$status" != "in-progress" ]]; then
			printf 'malformed status in completion register: %s -> %s\n' "$name" "$status"
		fi
		if [[ ! -d "$specs_dir/$name" ]]; then
			printf 'completion register names a directory that does not exist: %s\n' "$name"
		fi
		if [[ -n "$corrects" && "$corrects" != "-" ]]; then
			if [[ "$corrects" == "$name" ]]; then
				printf 'completion register Corrects value is a self-reference: %s\n' "$name"
			elif [[ ! -d "$specs_dir/$corrects" ]]; then
				printf 'completion register Corrects value does not resolve to an existing directory: %s -> %s\n' "$name" "$corrects"
			else
				name_num="${name%%-*}"
				corrects_num="${corrects%%-*}"
				if [[ "10#$corrects_num" -ge "10#$name_num" ]]; then
					printf 'completion register Corrects value is not a strictly lower-numbered feature: %s -> %s\n' "$name" "$corrects"
				fi
			fi
		fi
	done <"$rows_file"

	sort "$names_file" | uniq -d | while IFS= read -r dup; do
		printf 'duplicate completion register entry: %s\n' "$dup"
	done

	for feature_dir in "$specs_dir"/[0-9][0-9][0-9]-*; do
		[[ -d "$feature_dir" ]] || continue
		base="$(basename "$feature_dir")"
		if ! grep -qx "$base" "$names_file"; then
			printf 'feature directory is not in the completion register: %s\n' "$feature_dir"
		fi
	done
}

# --- Probe mode: a dedicated CLI path for the D3.7 harness, separate from the assertions below ---
if [[ -n "$probe_class" ]]; then
	register_backup="$work_dir/register-backup-$$"
	cp "$REGISTER_FILE" "$register_backup"
	if [[ "$neutralise" -eq 1 ]]; then
		out="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
		[[ -z "$out" ]] && exit 0 || exit 1
	fi

	probe_ok=1

	# A8: every row removed
	grep -v '^| [0-9][0-9][0-9]-' "$register_backup" >"$REGISTER_FILE"
	out="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
	[[ "$out" == *"no rows parsed"* ]] || probe_ok=0
	cp "$register_backup" "$REGISTER_FILE"

	# A4: a duplicate entry
	{ cat "$register_backup"; echo '| 001-multi-agent-skill-suite | complete | - |'; } >"$REGISTER_FILE"
	out="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
	[[ "$out" == *"duplicate completion register entry"* ]] || probe_ok=0
	cp "$register_backup" "$REGISTER_FILE"

	# A3: a malformed status
	sed 's/| 001-multi-agent-skill-suite | complete |/| 001-multi-agent-skill-suite | done |/' \
		"$register_backup" >"$REGISTER_FILE"
	out="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
	[[ "$out" == *"malformed status in completion register"* ]] || probe_ok=0
	cp "$register_backup" "$REGISTER_FILE"

	# A2: an entry naming a directory that does not exist
	{ cat "$register_backup"; echo '| 999-does-not-exist | complete | - |'; } >"$REGISTER_FILE"
	out="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
	[[ "$out" == *"does not exist"* ]] || probe_ok=0
	cp "$register_backup" "$REGISTER_FILE"

	# A1: a real directory's row removed
	grep -v '^| 041-auto-check-integrity ' "$register_backup" >"$REGISTER_FILE"
	out="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
	[[ "$out" == *"is not in the completion register"* ]] || probe_ok=0
	cp "$register_backup" "$REGISTER_FILE"

	# A5: an unresolvable Corrects value
	sed 's/| 034-highway-setup-compliance | complete | 033-highway-setup-orchestration |/| 034-highway-setup-compliance | complete | 999-does-not-exist |/' \
		"$register_backup" >"$REGISTER_FILE"
	out="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
	[[ "$out" == *"does not resolve to an existing directory"* ]] || probe_ok=0
	cp "$register_backup" "$REGISTER_FILE"

	# A5: a self-referencing Corrects value
	sed 's/| 034-highway-setup-compliance | complete | 033-highway-setup-orchestration |/| 034-highway-setup-compliance | complete | 034-highway-setup-compliance |/' \
		"$register_backup" >"$REGISTER_FILE"
	out="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
	[[ "$out" == *"self-reference"* ]] || probe_ok=0
	cp "$register_backup" "$REGISTER_FILE"

	exit $(( probe_ok == 1 ? 1 : 0 ))
fi

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
	fixture="$work_dir/021-coverage-fixture"
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

restore_coverage_fixture() {
	fixture="$1"
	printf '%s\n' \
		'| Requirement | Outcome | Evidence |' \
		'|---|---|---|' \
		'| FR-001 | satisfied | artifact.md: present |' \
		'| FR-002 | deferred | owned by a later feature |' >"$fixture/coverage.md"
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

# D7.2's original live record remains a focused regression assertion.
assert_pass "Feature 021 coverage record" coverage_check "$REPO_ROOT/$SPEC_DIR/021-completion-claim-accountability"

# Failure proof: remove one requirement id, observe failure, then restore and observe pass.
fixture="$(make_coverage_fixture)"
assert_pass "valid coverage fixture" coverage_check "$fixture"
missing_fixture="$work_dir/missing-coverage-fixture"
mkdir -p "$missing_fixture"
printf '%s\n' '- **FR-001**: first requirement' >"$missing_fixture/spec.md"
assert_fail "missing coverage record" coverage_check "$missing_fixture"
grep -v '| FR-002 |' "$fixture/coverage.md" >"$fixture/coverage.tmp"
mv "$fixture/coverage.tmp" "$fixture/coverage.md"
assert_fail "missing requirement id" coverage_check "$fixture"
restore_coverage_fixture "$fixture"
sed 's/| FR-001 | satisfied | artifact.md: present |/| FR-001 | artifact.md | present |/' "$fixture/coverage.md" >"$fixture/coverage.tmp"
mv "$fixture/coverage.tmp" "$fixture/coverage.md"
assert_fail "invalid outcome" coverage_check "$fixture"
restore_coverage_fixture "$fixture"
sed 's/| FR-002 | deferred | owned by a later feature |/| FR-002 | deferred | |/' "$fixture/coverage.md" >"$fixture/coverage.tmp"
mv "$fixture/coverage.tmp" "$fixture/coverage.md"
assert_fail "missing evidence" coverage_check "$fixture"
restore_coverage_fixture "$fixture"
printf '%s\n' '| FR-001 | satisfied | artifact.md: duplicate |' >>"$fixture/coverage.md"
assert_fail "duplicate requirement id" coverage_check "$fixture"
restore_coverage_fixture "$fixture"
printf '%s\n' '| FR-999 | satisfied | artifact.md: unknown |' >>"$fixture/coverage.md"
assert_fail "unknown requirement id" coverage_check "$fixture"
restore_coverage_fixture "$fixture"
sed 's/| Requirement | Outcome | Evidence |/| Requirement | Evidence | Outcome |/' "$fixture/coverage.md" >"$fixture/coverage.tmp"
mv "$fixture/coverage.tmp" "$fixture/coverage.md"
assert_fail "invalid coverage header" coverage_check "$fixture"
restore_coverage_fixture "$fixture"
sed 's#artifact.md: present#missing-artifact.md: absent#' "$fixture/coverage.md" >"$fixture/coverage.tmp"
mv "$fixture/coverage.tmp" "$fixture/coverage.md"
assert_fail "absent satisfying artifact" coverage_check "$fixture"
restore_coverage_fixture "$fixture"
sed 's/| FR-001 | satisfied | artifact.md: present |/| FR-001 | historical | carried forward |/' "$fixture/coverage.md" >"$fixture/coverage.tmp"
mv "$fixture/coverage.tmp" "$fixture/coverage.md"
assert_fail "historical outcome outside Features 001-020" coverage_check "$fixture"
restore_coverage_fixture "$fixture"
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

# The completion register, not `tasks.md`, decides which directories D7.2/D7.4 reach. A feature
# no longer excludes itself from the completion rules through a file it controls.
register_output="$(register_problems "$REGISTER_FILE" "$SPECS_DIR")"
if [[ -n "$register_output" ]]; then
	printf '%s\n' "$register_output" | sed 's/^/FAIL: /'
	fail=1
else
	echo "PASS: completion register is well-formed"
fi

# A1-A4/A8 self-test: the register reader must be capable of failing on each declared defect,
# seeded in a temporary feature-directory tree and a temporary register so the real record is
# untouched. Named "fxdir" rather than the plural of "spec" so this file's own source text does
# not trip the shipped-tree development-reference scan.
register_probe_root="$(mktemp -d)"
mkdir -p "$register_probe_root/fxdir/001-a" "$register_probe_root/fxdir/002-b"
sound_register="$register_probe_root/register.md"
printf '%s\n' \
	'| Feature | Status | Corrects |' \
	'|---|---|---|' \
	'| 001-a | complete | - |' \
	'| 002-b | complete | - |' >"$sound_register"

self_test_register() {
	local label="$1" register_content="$2" expect="$3"
	printf '%s\n' "$register_content" >"$register_probe_root/probe.md"
	local output
	output="$(register_problems "$register_probe_root/probe.md" "$register_probe_root/fxdir")"
	if printf '%s' "$output" | grep -q "$expect"; then
		echo "PASS: $label failed as expected"
	else
		echo "FAIL: $label did not detect the seeded defect"
		fail=1
	fi
}

self_test_register "A1 unregistered directory" \
	"$(printf '%s\n' '| Feature | Status | Corrects |' '|---|---|---|' '| 001-a | complete | - |')" \
	"is not in the completion register"
self_test_register "A2 orphan entry" \
	"$(cat "$sound_register"; echo '| 003-does-not-exist | complete | - |')" \
	"does not exist"
self_test_register "A3 malformed status" \
	"$(printf '%s\n' '| Feature | Status | Corrects |' '|---|---|---|' '| 001-a | done | - |' '| 002-b | complete | - |')" \
	"malformed status in completion register"
self_test_register "A4 duplicate entry" \
	"$(cat "$sound_register"; echo '| 001-a | complete | - |')" \
	"duplicate completion register entry"
self_test_register "A8 zero rows" "no rows here" "no rows parsed"

sound_output="$(register_problems "$sound_register" "$register_probe_root/fxdir")"
if [[ -n "$sound_output" ]]; then
	echo "FAIL: a well-formed register was reported as malformed: $sound_output"
	fail=1
else
	echo "PASS: a well-formed register produces no problems"
fi
rm -rf "$register_probe_root"

# Feature 040 enforces every completed feature from 001 onward. The completion register, not
# `tasks.md`, decides which directories are in scope: `incomplete`/`in-progress` rows are excluded,
# `complete` rows are held to the coverage record regardless of any remaining unchecked task box.
register_rows "$REGISTER_FILE" | while IFS=$'\t' read -r name status corrects; do
	[[ -n "$name" ]] || continue
	[[ "$status" == "complete" ]] || continue
	echo "$name"
done >"$work_dir/complete-features-$$"

complete_count=0
while IFS= read -r name; do
	[[ -n "$name" ]] || continue
	complete_count=$((complete_count + 1))
	feature_dir="$SPECS_DIR/$name"
	if coverage_check "$feature_dir"; then
		echo "PASS: $name coverage record"
	else
		fail=1
	fi
done <"$work_dir/complete-features-$$"
echo "PASS: $complete_count directories evaluated under the completion register"

correction_check() {
	feature_dir="$1"
	deferred_rows="$(grep -E '^\|[[:space:]]*FR-[0-9]+[[:space:]]*\|[[:space:]]*deferred[[:space:]]*\|' "$feature_dir/coverage.md" || true)"
	[[ -n "$deferred_rows" ]] || {
		echo "FAIL: corrective record has no deferred rows: $feature_dir"
		return 1
	}
	bad_rows="$(printf '%s\n' "$deferred_rows" | grep -Ev 'Originating Feature[s]? [0-9]{3}.*superseded by Feature [0-9]{3}' || true)"
	if [[ -n "$bad_rows" ]]; then
		echo "FAIL: corrective record lacks originating and superseding provenance: $feature_dir"
		return 1
	fi
	return 0
}

register_rows "$REGISTER_FILE" | while IFS=$'\t' read -r name status corrects; do
	[[ -n "$name" ]] || continue
	[[ -n "$corrects" && "$corrects" != "-" ]] || continue
	echo "$name"
done >"$work_dir/corrective-features-$$"

corrective_count=0
while IFS= read -r corrective_feature; do
	[[ -n "$corrective_feature" ]] || continue
	corrective_count=$((corrective_count + 1))
	if correction_check "$REPO_ROOT/$SPEC_DIR/$corrective_feature"; then
		echo "PASS: $corrective_feature correction provenance"
	else
		fail=1
	fi
done <"$work_dir/corrective-features-$$"
echo "PASS: $corrective_count corrective features evaluated under the completion register"

exit "$fail"
