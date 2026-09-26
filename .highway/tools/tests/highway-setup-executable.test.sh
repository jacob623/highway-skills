#!/usr/bin/env bash
# Verifies deterministic Setup resume routing cases.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HELPERS="$SCRIPT_DIR/feature-093-helpers.sh"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
FIXTURES="$SCRIPT_DIR/fixtures/feature-093"
fail=0
if [[ ! -f "$HELPERS" ]]; then
	echo "FAIL: Feature 093 helper library is missing: $HELPERS" >&2
	exit 1
fi
source "$HELPERS"

setup_route_fixture() {
	local root="$1"
	local objective_status="$2"
	local objective_result="$3"
	local output="$4"
	local before after
	before="$root.before"
	after="$root.after"
	feature093_snapshot_tree "$root" "$before"
	{
		echo 'Profile: Complete'
		echo "Objectives: $objective_status"
		echo 'Progress: Objectives activity; 1 owner completed, 3 remaining'
		if [[ "$objective_status" == 'Missing' ]]; then
			echo "Let's identify some explicit outcomes worth pursuing."
			echo 'These give Highway something concrete to connect future decisions back to and help us evaluate whether you'
			echo "re accomplishing what you set out to do."
			echo "What's an important outcome you'd like to achieve?"
			echo 'Objective result: '"$objective_result"
			if [[ "$objective_result" == 'Complete' ]]; then
				echo 'Objectives readiness: Complete (fresh read)'
				echo 'Controls readiness requested'
			fi
		elif [[ "$objective_status" == 'Complete' ]]; then
			echo 'Controls readiness requested'
		else
			echo "Objective result: $objective_result"
			echo 'Setup stopped; Controls readiness not requested'
		fi
	} >"$output"
	feature093_snapshot_tree "$root" "$after"
	cmp -s "$before" "$after"
}

for fixture in objective-missing.txt objective-baseline.txt objective-blocked.txt; do
	if [[ -f "$FIXTURES/$fixture" ]]; then
		:
	else
		echo "FAIL: missing readiness fixture '$fixture'"; fail=1
	fi
done
feature093_require_text "$FIXTURES/objective-missing.txt" 'Status: Missing'
feature093_require_text "$FIXTURES/objective-baseline.txt" 'Status: Complete'
feature093_require_text "$FIXTURES/objective-blocked.txt" 'Status: Blocked'

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-setup-093.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
mkdir "$fixture_root/state"
missing_output="$fixture_root/missing.out"
if setup_route_fixture "$fixture_root/state" 'Missing' 'Complete' "$missing_output"; then
	feature093_require_text "$missing_output" 'Progress: Objectives activity; 1 owner completed, 3 remaining' || { echo 'FAIL: current owner progress was not emitted'; fail=1; }
	feature093_assert_order "$missing_output" "Let's identify some explicit outcomes worth pursuing." "What's an important outcome you'd like to achieve?" || { echo 'FAIL: Missing handoff ordering is invalid'; fail=1; }
	feature093_require_text "$missing_output" 'Objective result: Complete' || { echo 'FAIL: owner completion was not forwarded'; fail=1; }
	feature093_require_text "$missing_output" 'Controls readiness requested' || { echo 'FAIL: Setup did not continue after fresh terminal readiness'; fail=1; }
else
	echo 'FAIL: Missing handoff mutated the disposable Setup fixture'; fail=1
fi

complete_output="$fixture_root/complete.out"
if setup_route_fixture "$fixture_root/state" 'Complete' 'Complete' "$complete_output"; then
	feature093_forbid_text "$complete_output" "Let's identify some explicit outcomes worth pursuing." || { echo 'FAIL: Complete readiness emitted the Objective introduction'; fail=1; }
	feature093_forbid_text "$complete_output" "What's an important outcome you'd like to achieve?" || { echo 'FAIL: Complete readiness started Objective discovery'; fail=1; }
	feature093_require_text "$complete_output" 'Controls readiness requested' || { echo 'FAIL: Complete readiness did not continue to Controls'; fail=1; }
else
	echo 'FAIL: Complete readiness mutated the disposable Setup fixture'; fail=1
fi

blocked_output="$fixture_root/blocked.out"
if setup_route_fixture "$fixture_root/state" 'Missing' 'Blocked' "$blocked_output"; then
	feature093_require_text "$blocked_output" 'Objective result: Blocked' || { echo 'FAIL: owner failure was not forwarded'; fail=1; }
	feature093_forbid_text "$blocked_output" 'Controls readiness requested' || { echo 'FAIL: Setup continued after owner failure'; fail=1; }
else
	echo 'FAIL: blocked handoff mutated the disposable Setup fixture'; fail=1
fi
for case_text in 'No authoritative Profile' 'Valid incomplete Profile' 'Valid Complete Profile' 'Malformed Profile'; do
	grep -Fq "$case_text" "$SKILL" || { echo "FAIL: missing routing case '$case_text'"; fail=1; }
done
if grep -Fq 'Setup checkpoint' "$SKILL" && ! grep -Fq 'Never restore' "$SKILL"; then echo 'FAIL: Setup checkpoint behavior is ambiguous'; fail=1; fi
if [[ $fail -ne 0 ]]; then exit 1; fi
if ! feature093_assert_order "$SKILL" 'Profile readiness' 'Objectives readiness'; then
	echo 'FAIL: Setup does not request Objectives after Profile readiness'; fail=1
fi
if ! feature093_assert_order "$SKILL" 'Objectives readiness' 'Controls readiness'; then
	echo 'FAIL: Setup does not request Controls after Objectives readiness'; fail=1
fi
if ! feature093_require_text "$SKILL" 'terminal `Complete`, skip Objective introduction and discovery'; then
	echo 'FAIL: Complete Objective readiness branch is not explicit'; fail=1
fi
if ! feature093_require_text "$SKILL" 'after verified Objective completion, request fresh Objective readiness'; then
	echo 'FAIL: fresh Objective readiness recheck is not explicit'; fail=1
fi
if ! feature093_forbid_text "$SKILL" 'Setup persists Objective draft'; then
	echo 'FAIL: Setup still permits Objective draft persistence'; fail=1
fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Setup resume routing passes'
