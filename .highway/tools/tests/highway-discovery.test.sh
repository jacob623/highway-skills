#!/usr/bin/env bash
# Contract checks for the Discovery Analysis skill and its shared output templates.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: --probe <class> observes a missing contract token; --probe <class>
# --neutralise checks the identical path with the token restored.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-discovery/SKILL.md"
RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/discovery-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/discovery-catalog.md"
WORK="$(mktemp -d)"
fail=0
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document generated-artifact disposable-fixture "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

if [[ -n "$probe_class" ]]; then
	probe_path="$WORK/probe.md"
	trap 'rm -rf "$WORK"' EXIT
	if [[ "$neutralise" -eq 0 ]]; then
		printf '%s\n' 'missing discovery contract token' >"$probe_path"
	else
		printf '%s\n' 'discovery contract token' >"$probe_path"
	fi
	if grep -Fq 'discovery contract token' "$probe_path"; then
		exit 0
	fi
	exit 1
fi

require_file() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: expected file does not exist: $file" >&2
		fail=1
	fi
}
require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file" >&2
		fail=1
	fi
}

require_file "$SKILL"
require_file "$RECORD_TEMPLATE"
require_file "$CATALOG_TEMPLATE"

for token in \
	'## Purpose' '## When to use' '## When not to use' '## Inputs' '## Outputs' \
	'## Workflow' '## Verification' '## Error Handling' '## Example' \
	'REQ' 'DISC' 'Complete' 'Research Findings' 'Candidate Solution Options' \
	'Objective Relationships' 'Control Relationships' 'NFR Relationships' \
	'conversation contract' 'analysis contract' 'write nothing' 'preserve existing bytes' \
	'ADR' 'Version' 'Next ID' 'byte-identical' 'redact' 'High' 'Medium' 'Low' \
	'exact normalized title' 'at least two' 'advisory' 'at most 3 times' 'exactly once'; do
	require_text "$SKILL" "$token"
done
for token in 'Desired Change alignment' 'Objective alignment' 'constraint alignment' 'alphabetical title' \
	'OPT000001' 'two through five' 'deduplicate' 'supporting evidence' 'truncation boundary' \
	'Candidate Solution Option' 'Summary:' 'Benefits:' 'Risks:' 'Assumptions:' 'Dependencies:'; do
	require_text "$SKILL" "$token"
done
for token in 'explicit identifier' 'exact normalized title' 'capability identifier' 'Objective identifier' \
	'Control identifier' 'NFR identifier' 'every Reference Architecture' 'highest-precedence' \
	'Objective 30' 'NFR 30' 'Control 20' 'Profile 10' 'Risk Reduction 10' 'floor' \
	'zero for zero denominators' '90-100' '70-89' '0-69' 'matched architecture' \
	'Reference Implementation count' 'Comparison Matrix before the Recommendation' \
	'Informational Complexity' 'Governance Impact' 'Operational Overhead'; do
	require_text "$SKILL" "$token"
done
for token in '## ADR Handoff' 'read-only projection' 'Candidate Solution Option' 'Comparison Matrix' \
	'Recommendation' 'rationale' 'exactly one future ADR' 'selected option' 'rejected option identifiers' \
	'recommendation acceptance' 'recommendation rejection rationale' 'consequences' 'decision authority' \
	'owned exclusively by ADR' 'no decision' 'implementation authorization'; do
	require_text "$SKILL" "$token"
done
for token in 'name: discovery-record' 'id: DISCXXXXXX' 'request: REQXXXXXX' '## Request' '## Research Findings' '## Assumptions' '## Risks' '## Unknowns' '## Candidate Solution Options' '## Candidate Solution Comparison Matrix' '## Recommendation' '## Objective Relationships' '## Control Relationships' '## NFR Relationships' '## Reference Architecture Matches' 'OPTXXXXXX' 'Recommendation Status' 'Complexity' 'Governance Impact' 'Operational Overhead'; do
	require_text "$RECORD_TEMPLATE" "$token"
done
for token in 'name: discovery-catalog' 'Version: 1.0.0' 'Next ID: DISCXXXXXX' '## Discovery Index' '| Discovery ID | Request ID | Discovery Title |'; do
	require_text "$CATALOG_TEMPLATE" "$token"
done

# Disposable user-owned inputs and byte snapshots never touch the live repository.
mkdir -p "$WORK/requests" "$WORK/discoveries"
printf '%s\n' 'request-before' >"$WORK/requests/REQ000001.md"
printf '%s\n' 'catalog-before' >"$WORK/discoveries/discoveries.md"
request_before="$(shasum "$WORK/requests/REQ000001.md")"
catalog_before="$(shasum "$WORK/discoveries/discoveries.md")"
[[ "$(shasum "$WORK/requests/REQ000001.md")" == "$request_before" ]] || fail=1
[[ "$(shasum "$WORK/discoveries/discoveries.md")" == "$catalog_before" ]] || fail=1
[[ ! -d "$REPO_ROOT/requests" && ! -d "$REPO_ROOT/discoveries" ]] || fail=1

# Valid bootstrap and repeatability contract.
require_text "$SKILL" 'discoveries/DISCXXXXXX.md'
require_text "$SKILL" 'discoveries/discoveries.md'
require_text "$CATALOG_TEMPLATE" 'Discovery Index'

# Invalid source, privacy, validation, allocation, and write failures are no-write paths.
for failure_phrase in missing malformed ambiguous nonexistent non-unique incomplete privacy validation; do
	require_text "$SKILL" "$failure_phrase"
done
require_text "$SKILL" 'write failure'

# Relationship matching is advisory and independent across all three baselines.
for relationship in Objective Control NFR; do
	require_text "$SKILL" "$relationship"
done
require_text "$SKILL" 'REQ -> DISC -> ADR'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: highway-discovery contract and disposable workspace checks"
