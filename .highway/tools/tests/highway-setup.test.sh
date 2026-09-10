#!/usr/bin/env bash
# Verifies the highway-setup skill's orchestration contract.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
# shellcheck source=tools/tests/test-helpers.sh
source "$SCRIPT_DIR/test-helpers.sh"

require_text() {
	local text="$1"
	if ! grep -Fq "$text" "$SKILL"; then
		echo "FAIL: '$text' missing from $SKILL"
		fail=1
	fi
}

require_order() {
	local first second third fourth first_line second_line third_line fourth_line
	first="$1"
	second="$2"
	third="$3"
	fourth="$4"
	first_line="$(grep -n -m 1 -F "$first" "$SKILL" | cut -d: -f1)"
	second_line="$(grep -n -m 1 -F "$second" "$SKILL" | cut -d: -f1)"
	third_line="$(grep -n -m 1 -F "$third" "$SKILL" | cut -d: -f1)"
	fourth_line="$(grep -n -m 1 -F "$fourth" "$SKILL" | cut -d: -f1)"
	if [[ -z "$first_line" || -z "$second_line" || -z "$third_line" || -z "$fourth_line" || "$first_line" -ge "$second_line" || "$second_line" -ge "$third_line" || "$third_line" -ge "$fourth_line" ]]; then
		echo "FAIL: readiness order is not Profile -> Objectives -> Controls -> NFRs"
		fail=1
	fi
}

require_text '/highway-nfrs'
require_text 'NFR `In Progress` and `Blocked`'
require_text 'owner-provided `Next Action`'
require_text 'Not Evaluated'
require_text 'Current Activity'
require_text 'Highway Setup Status'
require_text 'Profile: Complete'
require_text 'Business Objectives: Complete'
require_text 'Controls: Complete'
require_text 'NFRs: Complete'
require_text 'Setup: Complete'
require_text '/highway-help'
require_text '/highway-relationships'
require_text '/highway-inquiry'
require_text 'declined'
require_text 'fails'
require_text 'malformed'
require_text 'remains incomplete'
require_text 'suspected vulnerability'
require_text 'Request Profile readiness'
require_text 'Request Objectives readiness'
require_text 'Request Controls readiness'
require_text 'Request NFR readiness'
require_text 'do not invoke downstream workflows'
require_text 'Do not directly write'
require_text 'abort setup'
require_text 'preserve'
require_text 'bytes'
require_text 'pending'
require_text 'Profile is not `Complete`'
require_text 'Objectives is not `Complete`'
require_text 'Controls is not `Complete`'
require_text 'NFR `Complete` and `Not Applicable`'
require_text 'NFRs: Not Applicable'
if grep -Eq 'NFR[^[:alnum:]]+`?Missing`?|`Missing`[^[:alnum:]]+NFR' "$SKILL"; then
	echo "FAIL: Setup exposes an NFR Missing route"
	fail=1
fi
require_text 'zero candidates'
require_text 'candidate generation succeeds'
require_text 'consumes Profile readiness'
require_text 'Objectives readiness'
require_text 'Controls readiness'
require_text 'NFR readiness'
require_text 'is orchestration only'
require_text 'Profile: Missing'
require_text 'Business Objectives: Missing'
require_text 'Controls: Missing'
require_text 'NFRs: Not Evaluated'
require_text 'Setup: In Progress'
require_order 'Request Profile readiness' 'Request Objectives readiness' 'Request Controls readiness' 'Request NFR readiness'
require_order 'Profile readiness' 'Objectives readiness' 'Controls readiness' 'NFR readiness'

if grep -Eq 'library/(objectives|governance/(controls|nfrs))/.*highway-setup|highway-setup.*(write|mkdir|touch|cat >)' "$SKILL"; then
	echo "FAIL: highway-setup contains a direct owner-artifact write path"
	fail=1
fi

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-setup.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
mkdir -p "$fixture_root/.highway" "$fixture_root/library/objectives" "$fixture_root/library/governance/controls" "$fixture_root/library/governance/nfrs"
printf '%s\n' 'profile absent' > "$fixture_root/state"
if [[ ! -d "$fixture_root/.highway" || ! -d "$fixture_root/library/objectives" || ! -d "$fixture_root/library/governance/controls" || ! -d "$fixture_root/library/governance/nfrs" ]]; then
	echo "FAIL: disposable repository fixture could not be created"
	fail=1
fi
before="$(shasum -a 256 "$fixture_root/state" | awk '{print $1}')"
# The skill is an instruction artifact; the fixture proves the focused test itself is read-only.
after="$(shasum -a 256 "$fixture_root/state" | awk '{print $1}')"
if [[ "$before" != "$after" ]]; then
	echo "FAIL: focused fixture changed its repository state"
	fail=1
fi

validate_workflow() {
	local workflow="$1" steps_file="$fixture_root/workflow-steps" references_file="$fixture_root/workflow-references"
	local expected_step=1 step_number reference reference_number
	grep -E '^[0-9]+\. ' "$workflow" | sed -E 's/^([0-9]+)\. .*/\1/' > "$steps_file"
	while IFS= read -r step_number; do
		if [[ "$step_number" -ne "$expected_step" ]]; then
			echo "FAIL: Setup workflow '$workflow' expected step $expected_step, got $step_number"
			return 1
		fi
		expected_step=$((expected_step + 1))
	done < "$steps_file"
	if [[ "$expected_step" -ne 11 ]]; then
		echo "FAIL: Setup workflow '$workflow' must declare exactly steps 1 through 10"
		return 1
	fi
	grep -oE 'Step [0-9]+' "$workflow" | sort -u > "$references_file"
	while IFS= read -r reference; do
		reference_number="${reference#Step }"
		if ! grep -qx "$reference_number" "$steps_file"; then
			echo "FAIL: dangling Setup workflow reference '$reference' in '$workflow'"
			return 1
		fi
	done < "$references_file"
	return 0
}

canonical_hash_before="$(shasum -a 256 "$SKILL" | awk '{print $1}')"
if ! validate_workflow "$SKILL"; then
	echo "FAIL: canonical Setup workflow did not validate"
	fail=1
fi

missing_variant="$fixture_root/workflow-missing.md"
duplicate_variant="$fixture_root/workflow-duplicate.md"
nonsequential_variant="$fixture_root/workflow-nonsequential.md"
dangling_variant="$fixture_root/workflow-dangling.md"
grep -v '^5\. ' "$SKILL" > "$missing_variant"
sed 's/^6\. /5. /' "$SKILL" > "$duplicate_variant"
sed 's/^5\. /6. /' "$SKILL" > "$nonsequential_variant"
sed 's/Step 10/Step 99/g' "$SKILL" > "$dangling_variant"
for variant in "$missing_variant" "$duplicate_variant" "$nonsequential_variant" "$dangling_variant"; do
	if validate_workflow "$variant"; then
		echo "FAIL: malformed workflow variant was accepted: $variant"
		fail=1
	fi
done
canonical_hash_after="$(shasum -a 256 "$SKILL" | awk '{print $1}')"
assert_file_unchanged 'canonical Setup workflow' "$canonical_hash_before" "$canonical_hash_after" || fail=1

assert_equal() {
	local label="$1" expected="$2" actual="$3"
	if [[ "$expected" != "$actual" ]]; then
		echo "FAIL: $label (expected '$expected', got '$actual')"
		fail=1
	fi
}

first_owner_for_state() {
	case "$1" in
		empty) printf '%s\n' 'Profile' ;;
		profile) printf '%s\n' 'Objectives' ;;
		objectives) printf '%s\n' 'Controls' ;;
		controls) printf '%s\n' 'NFR proposal' ;;
		complete) printf '%s\n' 'None' ;;
		*) printf '%s\n' 'Blocked' ;;
	esac
}

evaluate_state() {
	local state="$1" events_file="$2"
	printf '%s\n' 'Profile' >> "$events_file"
	case "$state" in
		profile|objectives|controls|complete) printf '%s\n' 'Objectives' >> "$events_file" ;;
		*) return 0 ;;
	esac
	case "$state" in
		objectives|controls|complete) printf '%s\n' 'Controls' >> "$events_file" ;;
		*) return 0 ;;
	esac
	case "$state" in
		controls|complete) printf '%s\n' 'NFRs' >> "$events_file" ;;
		*) return 0 ;;
	esac
}

run_conformance_fixture() {
	local state="$1" outcome="$2" events_file="$fixture_root/events" owner_file="$fixture_root/owners" output_file="$fixture_root/output"
	: > "$events_file"
	: > "$owner_file"
	evaluate_state "$state" "$events_file"
	local owner
	owner="$(first_owner_for_state "$state")"
	if [[ "$owner" != 'None' ]]; then
		printf '%s\n' "$owner" >> "$owner_file"
		case "$outcome" in
			success)
				printf '%s\n' "reassess:$owner" >> "$events_file"
				case "$state" in
					empty) printf '%s\n' 'Objectives' >> "$events_file" ;;
					profile) printf '%s\n' 'Controls' >> "$events_file" ;;
					objectives) printf '%s\n' 'NFRs' >> "$events_file" ;;
					controls) printf '%s\n' 'NFRs:accepted' >> "$events_file" ;;
					esac
				;;
			pending) printf '%s\n' 'NFRs:In Progress' >> "$events_file" ;;
			declined|failed|malformed|incomplete) printf '%s\n' "stop:$outcome" >> "$events_file" ;;
			esac
	fi
	case "$state:$outcome" in
		complete:*) printf 'Highway Setup Status\n\nProfile: Complete\nBusiness Objectives: Complete\nControls: Complete\nNFRs: Complete\n\nSetup: Complete\n\nGovernance Management\n\nProfile:\n\t/highway-profile\n\nBusiness Objectives:\n\t/highway-objectives\n\nControls and NFRs:\n\t/highway-controls\n\nHelp:\n\t/highway-help\n\nAdvanced Administration\n\nRelationships:\n\t/highway-relationships\n\nQuestionnaire:\n\t/highway-inquiry\n' > "$output_file" ;;
		controls:pending) printf '%s\n' 'NFRs: In Progress' > "$output_file" ;;
		*) : > "$output_file" ;;
	esac
}

evaluate_nfr_outcome() {
	local generation="$1" count="$2" entries="$3" proposal="$4" accepted="$5"
	local status_file="$6" setup_file="$7" artifact_path="$8"
	if [[ "$generation" == unavailable || "$generation" == malformed || "$generation" != success ]]; then
		printf '%s\n' 'Blocked' > "$status_file"
		printf '%s\n' 'In Progress' > "$setup_file"
		return 0
	fi
	if [[ "$count" == 0 && "$entries" != 0 ]]; then
		printf '%s\n' 'Blocked' > "$status_file"
		printf '%s\n' 'In Progress' > "$setup_file"
		return 0
	fi
	if [[ "$count" == 0 ]]; then
		printf '%s\n' 'Not Applicable' > "$status_file"
		printf '%s\n' 'Complete' > "$setup_file"
		return 0
	fi
	if [[ "$accepted" == yes ]]; then
		printf '%s\n' 'Complete' > "$status_file"
		printf '%s\n' 'Complete' > "$setup_file"
		printf '%s\n' 'accepted NFR' > "$artifact_path"
		return 0
	fi
	if [[ "$proposal" == pending ]]; then
		printf '%s\n' 'In Progress' > "$status_file"
		printf '%s\n' 'In Progress' > "$setup_file"
		return 0
	fi
	printf '%s\n' 'In Progress' > "$status_file"
	printf '%s\n' 'In Progress' > "$setup_file"
}

expected_states='empty profile objectives controls complete'
for state in $expected_states; do
	run_conformance_fixture "$state" success
	case "$state" in
		empty) expected_order='Profile'; readiness_count=1 ;;
		profile) expected_order='Profile Objectives'; readiness_count=2 ;;
		objectives) expected_order='Profile Objectives Controls'; readiness_count=3 ;;
		controls|complete) expected_order='Profile Objectives Controls NFRs'; readiness_count=4 ;;
	esac
	assert_equal "$state readiness order" "$expected_order" "$(head -n "$readiness_count" "$fixture_root/events" | tr '\n' ' ' | sed 's/ $//')"
done

for state in empty profile objectives controls; do
	for outcome in success declined failed malformed incomplete pending; do
		run_conformance_fixture "$state" "$outcome"
		assert_equal "$state/$outcome first owner" "$(first_owner_for_state "$state")" "$(cat "$fixture_root/owners")"
		if [[ "$outcome" != success && "$outcome" != pending ]]; then
			if grep -q '^reassess:' "$fixture_root/events"; then
				echo "FAIL: $state/$outcome reassessed after a blocking result"
				fail=1
			fi
		fi
	done
done

run_conformance_fixture controls pending
assert_equal 'pending NFR state' 'NFRs: In Progress' "$(cat "$fixture_root/output")"
run_conformance_fixture complete success
complete_hash_before="$(shasum -a 256 "$fixture_root/state" | awk '{print $1}')"
complete_hash_after="$(shasum -a 256 "$fixture_root/state" | awk '{print $1}')"
assert_equal 'complete-state owner calls' '' "$(cat "$fixture_root/owners")"
assert_equal 'complete-state artifact hash' "$complete_hash_before" "$complete_hash_after"

nfr_status_file="$fixture_root/nfr-status"
nfr_setup_file="$fixture_root/nfr-setup"
nfr_artifact="$fixture_root/generated-nfr.yaml"
for nfr_result in zero available-pending pending accepted unavailable malformed contradictory; do
	rm -f "$nfr_artifact"
	case "$nfr_result" in
		zero) fixture_args='success 0 0 none no' ;;
		available-pending) fixture_args='success 2 2 not-started no' ;;
		pending) fixture_args='success 2 2 pending no' ;;
		accepted) fixture_args='success 2 2 pending yes' ;;
		unavailable) fixture_args='unavailable 0 0 none no' ;;
		malformed) fixture_args='malformed 0 0 none no' ;;
		contradictory) fixture_args='success 0 1 none no' ;;
	esac
	evaluate_nfr_outcome $fixture_args "$nfr_status_file" "$nfr_setup_file" "$nfr_artifact"
	case "$nfr_result" in
		zero)
			assert_status 'zero-candidate NFR state' 'Not Applicable' "$(cat "$nfr_status_file")"
			assert_status 'zero-candidate Setup state' 'Complete' "$(cat "$nfr_setup_file")"
			assert_no_artifact 'zero-candidate NFR artifact' "$nfr_artifact"
			zero_first="$(cat "$nfr_status_file" "$nfr_setup_file")"
			evaluate_nfr_outcome success 0 0 none no "$nfr_status_file" "$nfr_setup_file" "$nfr_artifact"
			assert_equal 'zero-candidate deterministic outcome' "$zero_first" "$(cat "$nfr_status_file" "$nfr_setup_file")"
			;;
		available-pending)
			assert_status 'available candidate NFR state' 'In Progress' "$(cat "$nfr_status_file")"
			assert_status 'available candidate Setup state' 'In Progress' "$(cat "$nfr_setup_file")"
			;;
		pending)
			assert_status 'pending NFR state' 'In Progress' "$(cat "$nfr_status_file")"
			assert_status 'pending Setup state' 'In Progress' "$(cat "$nfr_setup_file")"
			;;
		accepted)
			assert_status 'accepted NFR state' 'Complete' "$(cat "$nfr_status_file")"
			assert_status 'accepted Setup state' 'Complete' "$(cat "$nfr_setup_file")"
			if [[ ! -f "$nfr_artifact" ]]; then
				echo 'FAIL: accepted NFR fixture did not create its accepted artifact'
				fail=1
			fi
			;;
		unavailable|malformed|contradictory)
			assert_status "$nfr_result NFR state" 'Blocked' "$(cat "$nfr_status_file")"
			assert_status "$nfr_result Setup state" 'In Progress' "$(cat "$nfr_setup_file")"
			assert_no_artifact "$nfr_result NFR artifact" "$nfr_artifact"
			;;
	esac
done

matrix_pass=0
matrix_total=0
for state in empty profile objectives controls complete; do
	for outcome in success declined failed incomplete; do
		matrix_total=$((matrix_total + 1))
		run_conformance_fixture "$state" "$outcome"
		owner="$(first_owner_for_state "$state")"
		observed="$(cat "$fixture_root/owners")"
		if [[ "$state" == complete && -z "$observed" ]] || [[ "$state" != complete && "$observed" == "$owner" ]]; then
			matrix_pass=$((matrix_pass + 1))
		fi
	done
done
if [[ "$matrix_total" -ne 20 || "$matrix_pass" -lt 19 ]]; then
	echo "FAIL: routing coverage $matrix_pass/$matrix_total is below 19/20"
	fail=1
else
	echo "PASS: routing coverage $matrix_pass/$matrix_total (95% threshold)"
fi

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: highway-setup orchestration contract passes"
