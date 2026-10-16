#!/usr/bin/env bash
# Contract checks for the Highway onboarding workflow.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-onboarding/SKILL.md"
ADR_SKILL="$HIGHWAY_ROOT/skills/highway-adr/SKILL.md"
ADR_RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/adr-record.md"
ADR_CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/adr-catalog.md"
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
require_text "$SKILL" 'usage: "Invoke as `/highway-onboarding`."'
for token in \
	"## Purpose" "## Experience" "## When to use" "## When not to use" "## Inputs" \
	"## Ownership and evidence precedence" "## Capability Discovery" "## Platform Mapping" \
	"## Proposed Pre-existing ADR" "## Outputs" "## Workflow" "## Verification" \
	"## Error Handling" "## Example"; do
	require_text "$SKILL" "$token"
done
for token in \
	"accepted Profile, Objective, Control, NFR, ADR, Architecture, and Implementation knowledge" \
	"one concise sentence" "What would you add, correct, or remove?" \
	"Working Idea" "Contribution Opportunity" "many-to-many" "optional primary" \
	"custom process" "explicit unknown" "without creating a separate platform" \
	"likely alternatives" "historical claims" "requester accepts"; do
	require_text "$SKILL" "$token"
done
for token in \
	"highway-adr" "direct onboarding path" "request: onboarding" "discovery: highway" \
	"exactly one scalar" "synthetic Discovery" "alternate ADR" \
	"highway-architecture" "highway-implementation" "ADR" "Reference Architecture" \
	"Reference Implementation" "retry" "three times" "manual resume" \
	"failed owner boundary" "without repeating successful owner mutations"; do
	require_text "$SKILL" "$token"
done
for token in "repository context" "conversation" "manually provided organization websites" "imported materials" "live enterprise"; do
	require_text "$SKILL" "$token"
done
require_text "$SKILL" "ADR Record Creation"
require_text "$SKILL" "creates the ADR record directly"
require_text "$SKILL" "adr-record.md"
require_text "$SKILL" "adr-catalog.md"
require_text "$SKILL" "ADR identifier allocation"
require_text "$ADR_SKILL" "exactly one explicit \`DISC######\` identifier"
require_absent "$ADR_SKILL" "onboarding mode"
require_absent "$ADR_SKILL" "request: onboarding"
require_absent "$ADR_SKILL" "discovery: highway"
require_file "$ADR_RECORD_TEMPLATE"
require_file "$ADR_CATALOG_TEMPLATE"
require_absent "$SKILL" "creates a platform inventory"
require_absent "$SKILL" "creates a fake Request"
require_absent "$SKILL" "creates a synthetic DISC record"
require_absent "$SKILL" "request: ["
require_absent "$SKILL" "discovery: ["

mapping_fixture="$WORK/mappings.md"
printf '%s\n' \
	"capability: order fulfillment | provider: commerce platform | primary: true" \
	"capability: order fulfillment | provider: warehouse process | primary: false" \
	"capability: customer support | provider: commerce platform | primary: true" >"$mapping_fixture"
if [[ "$(grep -c '^capability:' "$mapping_fixture")" -ne 3 ]]; then
	echo "FAIL: many-to-many mapping fixture was not retained"
	fail=1
fi

retry_fixture="$WORK/retry.md"
printf '%s\n' "attempt=1" "attempt=2" "attempt=3" "resume=implementation" >"$retry_fixture"
if [[ "$(grep -c '^attempt=' "$retry_fixture")" -ne 3 ]] || ! grep -Fq 'resume=implementation' "$retry_fixture"; then
	echo "FAIL: bounded retry/resume fixture is invalid"
	fail=1
fi

exit "$fail"
