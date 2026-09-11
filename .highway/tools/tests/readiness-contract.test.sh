#!/usr/bin/env bash
# Tests the shared readiness action and ownership contract in source skills.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
HIGHWAY_ROOT="$REPO_ROOT/.highway"
fail=0

expect_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: $file missing '$text'"
		fail=1
	fi
}

for owner in profile objectives controls nfrs; do
	file="$HIGHWAY_ROOT/skills/highway-$owner/SKILL.md"
	expect_text "$file" "readiness"
	expect_text "$file" "Status:"
	expect_text "$file" "Summary:"
	expect_text "$file" "Next Action:"
	expect_text "$file" "Blocking Reason:"
done

setup="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
expect_text "$setup" "Profile readiness"
expect_text "$setup" "Objectives readiness"
expect_text "$setup" "Controls readiness"
expect_text "$setup" "NFR readiness"
expect_text "$setup" "orchestration only"

workflow_rules="$(sed -n '/^## Workflow$/,/^## Ordered Readiness Rules$/p' "$setup")"
for forbidden in 'organization.name' 'next_id' 'valid Objective' 'valid Control'; do
	if printf '%s\n' "$workflow_rules" | grep -Fq "$forbidden"; then
		echo "FAIL: Setup workflow contains owner predicate '$forbidden'"
		fail=1
	fi
done

for readiness_owner in profile objectives controls; do
	owner_file="$HIGHWAY_ROOT/skills/highway-$readiness_owner/SKILL.md"
	for readiness_status in Complete Missing Blocked; do
		expect_text "$owner_file" "$readiness_status"
	done
done

nfr_file="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
for readiness_status in Complete Blocked 'In Progress' 'Not Applicable'; do
	expect_text "$nfr_file" "$readiness_status"
done
if grep -Eq 'NFR[^[:alnum:]]+`?Missing`?|`Missing`[^[:alnum:]]+NFR' "$nfr_file"; then
	echo "FAIL: NFR readiness contract exposes Missing"
	fail=1
fi

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: readiness contract is present"
