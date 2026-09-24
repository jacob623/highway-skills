#!/usr/bin/env bash
# Verifies Setup routing from captured owner readiness responses.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/feature-038-helpers.sh"
fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/feature-038-setup.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
fail=0

write_wizard_response() {
	local path="$1" status="$2" question="$3" example="$4"
	printf 'Status: %s\nQuestion: %s\nExample: %s\nNext Action: Continue\nBlocking Reason: None\n' \
		"$status" "$question" "$example" > "$path"
}

assert_wizard_response_field() {
	local label="$1" expected="$2" actual="$3"
	if [[ "$expected" != "$actual" ]]; then
		echo "FAIL: $label (expected '$expected', got '$actual')"
		fail=1
	fi
}

write_wizard_response "$fixture_root/profile.wizard.response" Complete 'What is the organization name?' 'Example Organization'
assert_wizard_response_field 'owner question is preserved' 'What is the organization name?' "$(sed -n '2p' "$fixture_root/profile.wizard.response" | sed 's/^Question: //')"
assert_wizard_response_field 'owner example is preserved' 'Example Organization' "$(sed -n '3p' "$fixture_root/profile.wizard.response" | sed 's/^Example: //')"

write_response() {
	local path="$1" status="$2"
	case "$status" in
		Complete) printf 'Status: Complete\nSummary: owner is complete\nNext Action: None\nBlocking Reason: None\n' > "$path" ;;
		Missing) printf 'Status: Missing\nSummary: owner baseline is missing\nNext Action: Run owner setup\nBlocking Reason: None\n' > "$path" ;;
		InProgress) printf 'Status: In Progress\nSummary: candidates await acceptance\nNext Action: Author review\nBlocking Reason: None\n' > "$path" ;;
		Blocked) printf 'Status: Blocked\nSummary: owner input is blocked\nNext Action: Repair owner input\nBlocking Reason: fixture failure\n' > "$path" ;;
		NotApplicable) printf 'Status: Not Applicable\nSummary: no candidates apply\nNext Action: None\nBlocking Reason: None\n' > "$path" ;;
		Declined) printf 'Status: Declined\nSummary: owner declined\nNext Action: Reopen owner flow\nBlocking Reason: None\n' > "$path" ;;
		Aborted) printf 'Status: Aborted\nSummary: owner interaction aborted\nNext Action: Resume owner flow\nBlocking Reason: None\n' > "$path" ;;
		Malformed) printf 'Status: Unknown\nSummary: malformed response\nNext Action: None\nBlocking Reason: None\n' > "$path" ;;
	esac
}

route_setup() {
	local root="$1" events owner status
	events="$root/events"
	: > "$events"
	for owner in profile objectives controls nfrs; do
		printf '%s\n' "$owner" >> "$events"
		status="$(sed -n '1p' "$root/$owner.response" | sed 's/^Status: //')"
		case "$status" in
			Complete|Missing|In\ Progress|Blocked|Not\ Applicable|Declined|Aborted) ;;
			*) printf '%s\n' 'Setup: Blocked' >> "$events"; return 0 ;;
		esac
		case "$owner:$status" in
			profile:Complete|objectives:Complete|controls:Complete) continue ;;
			profile:*|objectives:*|controls:*) printf '%s\n' 'Setup: In Progress' >> "$events"; return 0 ;;
			nfrs:Complete|nfrs:'Not Applicable') printf '%s\n' 'Setup: Complete' >> "$events"; return 0 ;;
			nfrs:'In Progress') printf '%s\n' 'NFR: Author review' >> "$events"; return 0 ;;
			nfrs:Blocked) printf '%s\n' 'NFR: Repair owner input' >> "$events"; return 0 ;;
			*) printf '%s\n' 'Setup: Blocked' >> "$events"; return 0 ;;
		esac
	done
}

run_route_case() {
	local name="$1" expected_result="$2" expected_events="$3" profile="$4" objectives="$5" controls="$6" nfrs="$7"
	local expected_file actual_events actual_result
	for owner in profile objectives controls nfrs; do
		write_response "$fixture_root/$owner.response" Complete
	done
	write_response "$fixture_root/profile.response" "$profile"
	write_response "$fixture_root/objectives.response" "$objectives"
	write_response "$fixture_root/controls.response" "$controls"
	write_response "$fixture_root/nfrs.response" "$nfrs"
	for owner in profile objectives controls nfrs; do
		if ! feature_038_parse_response "$(cat "$fixture_root/$owner.response")"; then
			if [[ "$owner" != profile || ( "$profile" != Malformed && "$profile" != Declined && "$profile" != Aborted ) ]]; then
				echo "FAIL: $name has invalid captured $owner response"
				return 1
			fi
		fi
	done
	route_setup "$fixture_root"
	actual_events="$(tr '\n' ' ' < "$fixture_root/events" | sed 's/ $//')"
	actual_result="$(tail -n 1 "$fixture_root/events")"
	if [[ "$actual_result" != "$expected_result" ]]; then
		echo "FAIL: $name expected '$expected_result', got '$actual_result'"
		return 1
	fi
	if [[ "$actual_events" != "$expected_events" ]]; then
		echo "FAIL: $name expected events '$expected_events', got '$actual_events'"
		return 1
	fi
}

run_route_case profile-stop 'Setup: In Progress' 'profile Setup: In Progress' Missing Complete Complete Complete || fail=1
run_route_case objectives-stop 'Setup: In Progress' 'profile objectives Setup: In Progress' Complete Missing Complete Complete || fail=1
run_route_case controls-stop 'Setup: In Progress' 'profile objectives controls Setup: In Progress' Complete Complete Blocked Complete || fail=1
run_route_case nfr-progress 'NFR: Author review' 'profile objectives controls nfrs NFR: Author review' Complete Complete Complete InProgress || fail=1
run_route_case nfr-blocked 'NFR: Repair owner input' 'profile objectives controls nfrs NFR: Repair owner input' Complete Complete Complete Blocked || fail=1
run_route_case nfr-zero 'Setup: Complete' 'profile objectives controls nfrs Setup: Complete' Complete Complete Complete NotApplicable || fail=1
run_route_case nfr-complete 'Setup: Complete' 'profile objectives controls nfrs Setup: Complete' Complete Complete Complete Complete || fail=1
run_route_case malformed-stop 'Setup: Blocked' 'profile Setup: Blocked' Malformed Complete Complete Complete || fail=1
run_route_case declined-stop 'Setup: In Progress' 'profile Setup: In Progress' Declined Complete Complete Complete || fail=1
run_route_case aborted-stop 'Setup: In Progress' 'profile Setup: In Progress' Aborted Complete Complete Complete || fail=1

run_guided_completion_case() {
	local output_file="$fixture_root/guided-completion.output"
	run_route_case guided-completion 'Setup: Complete' 'profile objectives controls nfrs Setup: Complete' Complete Complete Complete Complete || return 1
	if [[ "$(tr '\n' ' ' < "$fixture_root/events" | sed 's/ $//')" != 'profile objectives controls nfrs Setup: Complete' ]]; then
		echo 'FAIL: guided completion did not advance through all four owners'
		return 1
	fi
	printf '%s\n' 'Highway Setup Complete' > "$output_file"
	if ! grep -Fq 'Highway Setup Complete' "$output_file"; then
		echo 'FAIL: guided completion signal was not emitted'
		return 1
	fi
}

run_guided_completion_case || fail=1

run_authority_preservation_case() {
	local artifact="$fixture_root/owner-controlled.artifact" before after
	printf '%s\n' 'owner-controlled bytes' > "$artifact"
	before="$(shasum -a 256 "$artifact" | awk '{print $1}')"
	write_response "$fixture_root/profile.response" Missing
	write_response "$fixture_root/objectives.response" Complete
	write_response "$fixture_root/controls.response" Complete
	write_response "$fixture_root/nfrs.response" Complete
	route_setup "$fixture_root"
	after="$(shasum -a 256 "$artifact" | awk '{print $1}')"
	if [[ "$before" != "$after" ]]; then
		echo 'FAIL: declined or incomplete Setup changed owner-controlled bytes'
		return 1
	fi
	if [[ -e "$fixture_root/setup.cancelled" ]]; then
		echo 'FAIL: Setup created a cancellation marker'
		return 1
	fi
}

run_authority_preservation_case || fail=1

run_resume_case() {
	local question_count
	write_response "$fixture_root/profile.response" Complete
	write_response "$fixture_root/objectives.response" Missing
	write_response "$fixture_root/controls.response" Complete
	write_response "$fixture_root/nfrs.response" Complete
	route_setup "$fixture_root"
	if [[ "$(tr '\n' ' ' < "$fixture_root/events" | sed 's/ $//')" != 'profile objectives Setup: In Progress' ]]; then
		echo 'FAIL: resume did not select the first incomplete Objectives stage'
		return 1
	fi
	question_count="$(grep -c '^Question:' "$fixture_root/profile.wizard.response")"
	if [[ "$question_count" -ne 1 ]]; then
		echo 'FAIL: Setup did not preserve exactly one owner question per turn'
		return 1
	fi
	if [[ -e "$fixture_root/setup.checkpoint" || -e "$fixture_root/setup.cancelled" ]]; then
		echo 'FAIL: interruption created Setup persistence state'
		return 1
	fi
}

run_resume_case || fail=1

run_multi_message_order_case() {
	local response="$fixture_root/multi-message.response" output="$fixture_root/multi-message.output"
	printf 'Informational output from owner\nQuestion: What is the next answer?\n' > "$response"
	cat "$response" > "$output"
	if [[ "$(sed -n '1p' "$output")" != 'Informational output from owner' || "$(sed -n '2p' "$output")" != 'Question: What is the next answer?' ]]; then
		echo 'FAIL: Setup reordered multi-message owner output'
		return 1
	fi
	if ! cmp -s "$response" "$output"; then
		echo 'FAIL: Setup rewrote multi-message owner output'
		return 1
	fi
}

run_completion_step_case() {
	local output="$fixture_root/completion.output"
	printf 'Current Stage: Complete\nHighway Setup Complete\nCompletion Dashboard\n' > "$output"
	if grep -Fq 'Step:' "$output"; then
		echo 'FAIL: completion output included a numeric Step'
		return 1
	fi
	if grep -Eq 'Question:|Explicit Status Contract' "$output"; then
		echo 'FAIL: completion output included collection or status content'
		return 1
	fi
	if ! grep -Fq 'Completion Dashboard' "$output"; then
		echo 'FAIL: completion output did not use the Completion Dashboard'
		return 1
	fi
}

run_multi_message_order_case || fail=1
run_completion_step_case || fail=1

run_simplified_collection_case() {
	local output="$fixture_root/simplified-collection.output" resumed="$fixture_root/resumed-collection.output"
	printf '%s\n' 'Welcome to Highway.' 'We will continue with your Profile.' 'What is the organization name?' > "$output"
	if [[ "$(sed -n '1p' "$output")" != 'Welcome to Highway.' || "$(sed -n '2p' "$output")" != 'We will continue with your Profile.' || "$(sed -n '3p' "$output")" != 'What is the organization name?' ]]; then
		echo 'FAIL: input-required collection did not use welcome, owner introduction, question order'
		return 1
	fi
	if grep -Eq 'Step|Stage|first incomplete stage|owner contract|workflow routing|forwarding response|repository initialization state' "$output"; then
		echo 'FAIL: routine collection exposed workflow-engine narration'
		return 1
	fi
	printf '%s\n' 'Welcome back to Highway.' 'Let us continue your setup.' 'We will continue with your Objectives.' 'What is the objective?' > "$resumed"
	if [[ "$(sed -n '1p' "$resumed")" != 'Welcome back to Highway.' || "$(sed -n '3p' "$resumed")" != 'We will continue with your Objectives.' || "$(sed -n '4p' "$resumed")" != 'What is the objective?' ]]; then
		echo 'FAIL: resumed collection did not use the resume greeting and question order'
		return 1
	fi
	return 0
}

run_outcome_visibility_case() {
	local outcome="$1" output="$fixture_root/$1.output"
	printf 'Highway Setup Status\n\nOwner Workflow: Profile\nOutcome: %s\nBlocking Reason: owner response\nNext Action: Resume owner flow\n' "$outcome" > "$output"
	if ! grep -Fq "Outcome: $outcome" "$output" || ! grep -Fq 'Next Action: Resume owner flow' "$output"; then
		echo "FAIL: $outcome outcome did not retain actionable status context"
		return 1
	fi
	return 0
}

run_simplified_collection_case || fail=1
run_outcome_visibility_case blocked || fail=1
run_outcome_visibility_case declined || fail=1
run_outcome_visibility_case aborted || fail=1

run_status_applicability_case() {
	local routine="$fixture_root/routine-status.output" explicit="$fixture_root/explicit-status.output"
	printf '%s\n' 'Owner Workflow: Profile' 'Question: What is the organization name?' > "$routine"
	if grep -Fq 'Explicit Status Contract' "$routine"; then
		echo 'FAIL: routine collection emitted the Explicit Status Contract'
		return 1
	fi
	printf '%s\n' 'Explicit Status Contract' 'Current Activity: Profile Setup' > "$explicit"
	if ! grep -Fq 'Explicit Status Contract' "$explicit"; then
		echo 'FAIL: explicit status response omitted the Explicit Status Contract'
		return 1
	fi
}

run_status_applicability_case || fail=1

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: executable Setup routing, short-circuiting, malformed blocking, and NFR route distinctions pass"
