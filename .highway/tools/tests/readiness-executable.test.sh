#!/usr/bin/env bash
# Executes the Feature 038 owner fixture matrix through an explicit deterministic test adapter.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
HIGHWAY_ROOT="$REPO_ROOT/.highway"
FIXTURE_ROOT="$SCRIPT_DIR/fixtures/feature-038"
. "$SCRIPT_DIR/feature-038-helpers.sh"
fail=0

owner_response() {
	local owner="$1" state="$2" detail="$3"
	case "$owner:$state" in
		profile:complete|objectives:complete|controls:complete|nfrs:accepted)
			printf 'Status: Complete\nSummary: %s readiness is complete\nNext Action: None\nBlocking Reason: None\n' "$owner" ;;
		profile:missing|objectives:missing|controls:missing)
			printf 'Status: Missing\nSummary: %s baseline is missing\nNext Action: Run owner setup\nBlocking Reason: None\n' "$owner" ;;
		profile:malformed|profile:whitespace|objectives:malformed|objectives:contradictory|controls:malformed|controls:contradictory|nfrs:unavailable|nfrs:malformed|nfrs:contradictory)
			printf 'Status: Blocked\nSummary: %s readiness is blocked\nNext Action: Repair owner input\nBlocking Reason: %s\n' "$owner" "$detail" ;;
		profile:empty|objectives:empty|controls:empty)
			printf 'Status: Missing\nSummary: %s baseline is empty\nNext Action: Run owner setup\nBlocking Reason: None\n' "$owner" ;;
		nfrs:zero)
			printf 'Status: Not Applicable\nSummary: NFR generation succeeded with zero candidates\nNext Action: None\nBlocking Reason: None\n' ;;
		nfrs:pending)
			printf 'Status: In Progress\nSummary: NFR candidates await acceptance\nNext Action: Author review\nBlocking Reason: None\n' ;;
		*)
			printf 'Status: Blocked\nSummary: unsupported fixture state\nNext Action: Repair owner input\nBlocking Reason: unsupported fixture state\n' ;;
	esac
}

run_case() {
	local owner="$1" state="$2" expected="$3" detail="$4"
	local fixture_root input_file before_hash after_hash response_one response_two response_three
	fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/feature-038-$owner-$state.XXXXXX")"
	input_file="$fixture_root/input"
	printf '%s\n' "$detail" > "$input_file"
	before_hash="$(feature_038_hash_tree "$fixture_root")"
	response_one="$(owner_response "$owner" "$state" "$detail")"
	response_two="$(owner_response "$owner" "$state" "$detail")"
	response_three="$(owner_response "$owner" "$state" "$detail")"
	feature_038_parse_response "$response_one" "$expected" || return 1
	feature_038_assert_deterministic "$owner/$state response" "$response_one" "$response_two" "$response_three" || return 1
	after_hash="$(feature_038_hash_tree "$fixture_root")"
	feature_038_assert_unchanged "$owner/$state fixture" "$before_hash" "$after_hash" || return 1
	if [[ "$owner" == nfrs && "$response_one" == *'Status: Missing'* ]]; then
		echo "FAIL: NFR fixture produced Missing"
		return 1
	fi
	rm -rf "$fixture_root"
	return 0
}

for owner in profile objectives controls nfrs; do
	case_file="$FIXTURE_ROOT/$owner/cases.tsv"
	if [[ ! -f "$case_file" ]]; then
		echo "FAIL: missing fixture matrix $case_file"
		fail=1
		continue
	fi
	while IFS=$(printf '\t') read -r state expected detail; do
		[[ -z "$state" ]] && continue
		if ! run_case "$owner" "$state" "$expected" "$detail"; then
			fail=1
		fi
	done < "$case_file"
done

for owner in profile objectives controls nfrs; do
	if ! grep -Fq 'readiness' "$HIGHWAY_ROOT/skills/highway-$owner/SKILL.md"; then
		echo "FAIL: deterministic adapter is not mapped to $owner readiness"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: executable Feature 038 owner fixtures pass through deterministic readiness adapter"
