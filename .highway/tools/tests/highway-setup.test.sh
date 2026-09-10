#!/usr/bin/env bash
# Verifies the highway-setup skill's orchestration contract.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0

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

require_text 'name: highway-setup'
require_text 'version: 1.0.0'
require_text 'Invoke as `/highway-setup`'
require_text 'organization.name'
require_text 'library/objectives/'
require_text 'library/governance/controls/'
require_text 'library/governance/nfrs/'
require_text '/highway-profile setup'
require_text '/highway-objectives setup'
require_text '/highway-controls'
require_text '/highway-nfrs'
require_text 'Control-owned NFR proposal path'
require_text 'pause setup with `Setup: In Progress`'
require_text 'accepted valid artifacts exist'
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
require_text 'reassess Profile and continue to Step 4'
require_text 'reassess Objectives and continue to Step 6'
require_text 'reassess Controls and continue to Step 8'
require_text 'author accepts proposed NFRs'
require_text 'do not invoke downstream workflows'
require_text 'Do not directly write'
require_text 'abort setup'
require_text 'withhold completion'
require_text 'preserve'
require_text 'bytes'
require_text 'pending'
require_text 'Profile `Missing` or `Blocked`'
require_text 'Business Objectives `Missing`'
require_text 'Controls `Missing`'
require_text 'NFRs `In Progress`'
require_text 'Profile: Missing'
require_text 'Business Objectives: Missing'
require_text 'Controls: Missing'
require_text 'NFRs: Not Evaluated'
require_text 'Setup: In Progress'
require_order 'Read the Profile state' 'Read the Business Objective state' 'Read the Control state' 'Read the NFR state'

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
