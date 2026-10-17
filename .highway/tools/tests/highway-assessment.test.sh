#!/usr/bin/env bash
# Contract checks for the Highway assessment workflow.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-assessment/SKILL.md"
FINDINGS="$HIGHWAY_ROOT/library/knowledge/assessment-findings.md"
WORK="$(mktemp -d)"
fail=0
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

require_file() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: expected file does not exist: $file"
		fail=1
	fi
}
require_text() {
	local file="$1" text="$2"
	if [[ ! -f "$file" ]] || ! grep -Fq -- "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}
require_absent() {
	local file="$1" text="$2"
	if [[ -f "$file" ]] && grep -Fq -- "$text" "$file"; then
		echo "FAIL: '$text' must be absent from $file"
		fail=1
	fi
}

require_file "$SKILL"
require_file "$FINDINGS"
for token in \
	'usage: "Invoke as `/highway-assessment`."' \
	"## Purpose" "## Experience" "## Response Support Text" "## Interpretation Confidence" \
	"## Assessment Contribution Opportunity" "## When to use" "## Inputs" \
	"## Ownership and evidence precedence" "## Finding Categories" "## Finding Identity and Persistence" \
	"## Finding Review" "## Finding Statuses" "## Advisory Boundary and Routing" "## Verification"; do
	require_text "$SKILL" "$token"
done
for token in \
	"/highway-assessment architectures" "/highway-assessment implementations" "/highway-assessment portfolio" \
	"portfolio" "Coverage" "Consistency" "Dependency" "Opportunity" "Reuse" "Risk" \
	"Open" "Accepted" "Dismissed" "Resolved" "Superseded" "Request More Information" \
	"Fingerprint" "revision" "stale revision" "What would you add, correct, or remove?"; do
	require_text "$SKILL" "$token"
done
for token in \
	"adrs/adrs.md" "architectures/architectures.md" "implementations/implementations.md" \
	"implementations/capabilities.md" "catalog indexes are the starting point for navigation" \
	"source records are opened selectively for detailed evidence" \
	"Realized By" "technology inventory" "row order" "read-only"; do
	require_text "$SKILL" "$token"
done
for token in \
	"name: assessment-findings" "metadata:" "revision: 0" "| ID | Category | Domain | Finding | Fingerprint | Status | Disposition |"; do
	require_text "$FINDINGS" "$token"
done
require_absent "$SKILL" "creates architecture"
require_absent "$SKILL" "creates implementation"
require_absent "$SKILL" "creates a dependency"
require_absent "$SKILL" "ASF000001"

fixture="$WORK/findings.md"
printf '%s\n' \
	"---" "revision: 2" "---" \
	"| ID | Category | Domain | Finding | Fingerprint | Status | Disposition |" \
	"| F001 | Dependency | Portfolio | Commerce and accounting appear related. | dependency|portfolio|commerce and accounting appear related. | Open | None |" \
	"| F002 | Opportunity | Implementations | Three implementations share a deployment pattern. | opportunity|implementations|three implementations share a deployment pattern. | Accepted | Future reuse |" >"$fixture"
if [[ "$(grep -c '^| F[0-9][0-9][0-9] |' "$fixture")" -ne 2 ]]; then
	echo "FAIL: findings fixture does not retain two rows"
	fail=1
fi
if [[ "$(grep -c 'revision: 2' "$fixture")" -ne 1 ]]; then
	echo "FAIL: findings fixture revision is not retained"
	fail=1
fi

exit "$fail"
