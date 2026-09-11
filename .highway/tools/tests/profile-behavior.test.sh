#!/usr/bin/env bash
# Verifies the highway-profile skill's behavioral contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
PROFILE="$HIGHWAY_ROOT/library/templates/output/profile.yaml"
# shellcheck source=tools/lib/profile.sh
source "$HIGHWAY_ROOT/tools/lib/profile.sh"
source "$SCRIPT_DIR/test-helpers.sh"
fail=0

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-profile.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT

write_profile_fixture() {
	local path="$1" name_state="$2"
	case "$name_state" in
		missing)
			printf '%s\n' 'organization: {}' > "$path"
			;;
		empty)
			printf '%s\n' 'organization:' '  name: ""' > "$path"
			;;
		whitespace)
			printf '%s\n' 'organization:' '  name: "   "' > "$path"
			;;
		valid)
			printf '%s\n' 'organization:' '  name: "Wayfinder"' > "$path"
			;;
		malformed)
			printf '%s\n' 'organization:' ' name: [malformed' > "$path"
			;;
		esac
}

profile_fixture_status() {
	local input="$1" confirmation="$2" output="$3" name
	if [[ ! -f "$input" ]]; then
		printf '%s\n' 'Missing'
		return 0
	fi
	if ! ruby -e 'require "yaml"; YAML.load_file(ARGV[0])' "$input" >/dev/null 2>&1; then
		printf '%s\n' 'Blocked'
		return 0
	fi
	name="$(awk '/^[[:space:]]+name:/ { sub(/^[^:]*:[[:space:]]*/, ""); gsub(/^"|"$/, ""); print; exit }' "$input")"
	if [[ -z "${name//[[:space:]]/}" ]]; then
		printf '%s\n' 'Missing'
		return 0
	fi
	if [[ "$confirmation" != confirmed ]]; then
		printf '%s\n' 'Declined'
		return 0
	fi
	cp "$input" "$output"
	printf '%s\n' 'Complete'
}

run_profile_fixture() {
	local label="$1" name_state="$2" confirmation="$3" expected_status="$4" expected_write="$5"
	local input="$fixture_root/$label-input.yaml" output="$fixture_root/$label-output.yaml"
	local before after observed
	rm -f "$input" "$output"
	write_profile_fixture "$input" "$name_state"
	if [[ "$label" == absent ]]; then
		rm -f "$input"
	fi
	if [[ "$expected_write" == no-write ]]; then
		if [[ -f "$input" ]]; then
			cp "$input" "$output"
		fi
	fi
	before="$(if [[ -f "$output" ]]; then shasum -a 256 "$output" | awk '{print $1}'; else printf '%s' absent; fi)"
	observed="$(profile_fixture_status "$input" "$confirmation" "$output")"
	after="$(if [[ -f "$output" ]]; then shasum -a 256 "$output" | awk '{print $1}'; else printf '%s' absent; fi)"
	assert_status "$label status" "$expected_status" "$observed" || fail=1
	if [[ "$expected_write" == no-write ]]; then
		assert_file_unchanged "$label bytes" "$before" "$after" || fail=1
	else
		[[ -f "$output" ]] || { echo "FAIL: $label did not write output"; fail=1; }
	fi
}

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

require_text "$SKILL" '.highway/library/templates/output/profile.yaml'
require_text "$SKILL" 'setup'
require_text "$SKILL" 'configure'
require_text "$SKILL" 'view'
require_text "$SKILL" 'show'
require_text "$SKILL" 'describe'
require_text "$SKILL" 'add'
require_text "$SKILL" 'update'
require_text "$SKILL" 'remove'
require_text "$SKILL" 'reset'
require_text "$SKILL" 'Confirmation Status'
require_text "$SKILL" 'Affected Entries'
require_text "$SKILL" 'NFR'
require_text "$SKILL" 'Control'
require_text "$SKILL" 'byte-for-byte unchanged'
require_text "$SKILL" 'fourteen context questions'
require_text "$SKILL" 'business_context'
require_text "$SKILL" 'vendor_strategy'
require_text "$SKILL" 'user-supplied organization identity'
require_text "$SKILL" 'Empty and whitespace-only answers are invalid'
require_text "$SKILL" 'Profile cannot report `Complete`'
require_text "$SKILL" 'does not infer organization identity'
require_text "$SKILL" 'Proposed Profile declined'
require_text "$SKILL" 'Preserve original bytes'

run_profile_fixture absent missing confirmed Missing no-write
run_profile_fixture empty empty confirmed Missing no-write
run_profile_fixture whitespace whitespace confirmed Missing no-write
run_profile_fixture valid valid confirmed Complete write
run_profile_fixture declined valid declined Declined no-write
run_profile_fixture malformed malformed confirmed Blocked no-write

for repeat in 1 2 3; do
	input="$fixture_root/repeat-$repeat-input.yaml"
	output="$fixture_root/repeat-$repeat-output.yaml"
	write_profile_fixture "$input" valid
	observed="$(profile_fixture_status "$input" confirmed "$output")"
	assert_status "repeat $repeat status" Complete "$observed" || fail=1
	grep -Fq 'Wayfinder' "$output" || { echo "FAIL: repeat $repeat lost supplied organization name"; fail=1; }
	if [[ "$repeat" -gt 1 ]]; then
		assert_deterministic "repeat $repeat deterministic output" "$repeat_hash" "$(shasum -a 256 "$output" | awk '{print $1}')" || fail=1
	fi
	repeat_hash="$(shasum -a 256 "$output" | awk '{print $1}')"
done

if grep -Eq 'timestamp|random identifier|environment-derived value' "$PROFILE"; then
	echo "FAIL: distributed profile contains a generated-value marker"
	fail=1
fi

before="$(shasum -a 256 "$PROFILE" | awk '{print $1}')"
# Read-only contract checks are static because the skill is an instruction artifact.
require_text "$SKILL" 'without changing it'
require_text "$SKILL" 'without creating a file'
after="$(shasum -a 256 "$PROFILE" | awk '{print $1}')"
if [[ "$before" != "$after" ]]; then
	echo "FAIL: read-only checks changed the distributed profile"
	fail=1
fi

[[ "$(profile_next_version 1.0.0 add)" == "1.0.1" ]] || { echo "FAIL: add version increment"; fail=1; }
[[ "$(profile_next_version 1.0.1 update)" == "1.0.2" ]] || { echo "FAIL: update version increment"; fail=1; }
[[ "$(profile_next_version 1.0.2 remove)" == "1.0.3" ]] || { echo "FAIL: remove version increment"; fail=1; }
[[ "$(profile_next_version 1.0.3 reset)" == "1.1.0" ]] || { echo "FAIL: reset version increment"; fail=1; }
[[ "$(profile_next_version 1.1.0 schema-breaking)" == "2.0.0" ]] || { echo "FAIL: schema-breaking version increment"; fail=1; }
if profile_next_version 1.0.0 declined >/dev/null 2>&1; then
	echo "FAIL: declined operation produced a version"
	fail=1
fi

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: profile behavior contract passes"
