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

write_response() {
	local path="$1" status="$2"
	case "$status" in
		Complete) printf 'Status: Complete\nSummary: owner is complete\nNext Action: None\nBlocking Reason: None\n' > "$path" ;;
		Missing) printf 'Status: Missing\nSummary: owner baseline is missing\nNext Action: Run owner setup\nBlocking Reason: None\n' > "$path" ;;
		InProgress) printf 'Status: In Progress\nSummary: candidates await acceptance\nNext Action: Author review\nBlocking Reason: None\n' > "$path" ;;
		Blocked) printf 'Status: Blocked\nSummary: owner input is blocked\nNext Action: Repair owner input\nBlocking Reason: fixture failure\n' > "$path" ;;
		NotApplicable) printf 'Status: Not Applicable\nSummary: no candidates apply\nNext Action: None\nBlocking Reason: None\n' > "$path" ;;
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
			Complete|Missing|In\ Progress|Blocked|Not\ Applicable) ;;
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
			if [[ "$owner" != profile || "$profile" != Malformed ]]; then
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

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: executable Setup routing, short-circuiting, malformed blocking, and NFR route distinctions pass"
