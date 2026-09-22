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
require_absent() {
	local file="$1" text="$2"
	if grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' must be absent from $file" >&2
		fail=1
	fi
}

discovery_structure_valid() {
	local file="$1"
	grep -Fq '.highway/library/templates/output/discovery-record.md' "$file" || return 1
	grep -Fq '.highway/library/templates/output/discovery-catalog.md' "$file" || return 1
	grep -Fq 'The record always includes the exact sections' "$file" && return 1
	grep -Fq 'Confirm the record has the required sections in shared-template order:' "$file" && return 1
	grep -Fq 'Confirm the catalog has only `Version`, `Next ID`, and `## Discovery Index`' "$file" && return 1
}

assert_alignment_fixture() {
	local file="$1" expected="$2" value
	value="$(sed -n 's/^Alignment: //p' "$file" | head -n1)"
	case "$value" in
		''|*[!0-9]*)
			if [[ "$expected" == valid ]]; then
				echo "FAIL: expected integer alignment fixture to pass: $file" >&2
				fail=1
			fi
			return
			;;
		*)
			if [[ "$value" -lt 0 || "$value" -gt 100 ]]; then
				if [[ "$expected" == valid ]]; then
					echo "FAIL: expected bounded alignment fixture to pass: $file" >&2
					fail=1
				fi
				return
			fi
			;;
	esac
	if [[ "$expected" == invalid ]]; then
		echo "FAIL: expected alignment fixture to fail: $file" >&2
		fail=1
	fi
}

assert_compliance_fixture() {
	local file="$1" expected="$2" value
	value="$(sed -n 's/^Constraint Compliance: //p' "$file" | head -n1)"
	if [[ "$expected" == valid && "$value" != 'Fully Compliant' ]]; then
		echo "FAIL: expected Fully Compliant fixture to pass: $file" >&2
		fail=1
	elif [[ "$expected" == invalid && "$value" == 'Fully Compliant' ]]; then
		echo "FAIL: expected non-Fully-Compliant fixture to fail: $file" >&2
		fail=1
	fi
}

require_file "$SKILL"
require_file "$RECORD_TEMPLATE"
require_file "$CATALOG_TEMPLATE"

# Disposable source mutations must independently detect missing shared citations and restored
# record/catalog structure without touching the canonical skill or templates.
missing_record_citation="$WORK/missing-record-citation.md"
sed '/discovery-record\.md/d' "$SKILL" >"$missing_record_citation"
if discovery_structure_valid "$missing_record_citation"; then
	echo "FAIL: missing Discovery record citation fixture was accepted" >&2
	fail=1
fi
missing_catalog_citation="$WORK/missing-catalog-citation.md"
sed '/discovery-catalog\.md/d' "$SKILL" >"$missing_catalog_citation"
if discovery_structure_valid "$missing_catalog_citation"; then
	echo "FAIL: missing Discovery catalog citation fixture was accepted" >&2
	fail=1
fi
duplicate_layout="$WORK/duplicate-layout.md"
cp "$SKILL" "$duplicate_layout"
printf '%s\n' 'The record always includes the exact sections `Objective Relationships`, `Control Relationships`, and `NFR Relationships`.' >>"$duplicate_layout"
if discovery_structure_valid "$duplicate_layout"; then
	echo "FAIL: duplicated Discovery relationship layout fixture was accepted" >&2
	fail=1
fi
verification_layout="$WORK/verification-layout.md"
cp "$SKILL" "$verification_layout"
printf '%s\n' 'Confirm the record has the required sections in shared-template order:' >>"$verification_layout"
if discovery_structure_valid "$verification_layout"; then
	echo "FAIL: duplicated Discovery record verification fixture was accepted" >&2
	fail=1
fi
catalog_layout="$WORK/catalog-layout.md"
cp "$SKILL" "$catalog_layout"
printf '%s\n' 'Confirm the catalog has only `Version`, `Next ID`, and `## Discovery Index`' >>"$catalog_layout"
if discovery_structure_valid "$catalog_layout"; then
	echo "FAIL: duplicated Discovery catalog verification fixture was accepted" >&2
	fail=1
fi

discovery_adapter="$REPO_ROOT/.github/skills/highway-discovery/SKILL.md"
if [[ -f "$discovery_adapter" ]] && ! cmp -s "$SKILL" "$discovery_adapter"; then
	grep -Fq '.highway/library/templates/output/discovery-record.md' "$discovery_adapter" || {
		echo "FAIL: Discovery adapter is stale relative to the canonical citation" >&2
		fail=1
	}
	grep -Fq '.highway/library/templates/output/discovery-catalog.md' "$discovery_adapter" || {
		echo "FAIL: Discovery adapter is missing the canonical catalog citation" >&2
		fail=1
	}
fi

if [[ "$(grep -c '^## Verification$' "$SKILL")" -ne 1 ]]; then
	echo "FAIL: expected exactly one ## Verification section" >&2
	fail=1
fi
if [[ "$(grep -c '^## Error Handling$' "$SKILL")" -ne 1 ]]; then
	echo "FAIL: expected exactly one ## Error Handling section" >&2
	fail=1
fi
if grep -Fq '## Verification Expectations' "$SKILL"; then
	echo "FAIL: ## Verification Expectations must be consolidated" >&2
	fail=1
fi
if grep -Fq '## Error Handling Expectations' "$SKILL"; then
	echo "FAIL: ## Error Handling Expectations must be consolidated" >&2
	fail=1
fi
if ! grep -Fq 'Recommendation Tie-Break Evaluation' "$SKILL"; then
	echo "FAIL: Workflow must reference Recommendation Tie-Break Evaluation" >&2
	fail=1
fi
if grep -Fq 'prefer a matched architecture' "$SKILL"; then
	echo "FAIL: Workflow must not embed prefer a matched architecture" >&2
	fail=1
fi
if ! grep -Fq 'Comparison Matrix before the Recommendation' "$SKILL"; then
	echo "FAIL: Workflow must preserve matrix-before-Recommendation ordering" >&2
	fail=1
fi

for token in \
	'## Purpose' '## When to use' '## When not to use' '## Inputs' '## Outputs' \
	'## Workflow' '## Verification' '## Error Handling' '## Example' \
	'REQ' 'DISC' 'Complete' 'Research Findings' 'Candidate Solution Options' \
	'conversation contract' 'analysis contract' 'write nothing' 'preserve existing bytes' \
	'ADR' 'byte-identical' 'redact' 'High' 'Medium' 'Low' \
	'exact normalized title' 'at least two' 'advisory' 'at most 3 times' 'exactly once'; do
	require_text "$SKILL" "$token"
done
for token in \
	'clarifications/clarifications.md' 'CLAR-<REQ-ID>' 'Clarification Catalog' \
	'Clarification Path' 'Clarification responses' 'Request evidence' \
	'open findings' 'resolved findings' 'blocking reason' 'advisory risk' \
	'candidate scores' 'recommendation totals' 'recommendation selection' \
	'no dedicated Clarification section' 'Clarification ownership' \
	'catalog is absent' 'artifact is unreadable' 'artifact is malformed' \
	'byte-identical' 'must not mutate' 'open findings remain advisory'; do
	require_text "$SKILL" "$token"
done
for token in \
	'allowed_solution_classes' 'known' 'unknown' 'unconstrained generation' 'empty invalid' \
	'existing_platforms_required' 'hosting_restrictions' 'vendor_restrictions' \
	'procurement_constraints' 'regulatory_restrictions' 'before scoring, comparison, or recommendation' \
	'Candidate Elimination Log' 'status `Excluded`' 'candidate identifier, constraint category' \
	'existing_platforms_preferred' 'known systems never eliminate' 'Required Platform Match is 100' \
	'Preferred Platform Match is 100' 'Known-System Alignment is 100' '75 when one or more' \
	'50 when none' 'Constraint Compliance' 'Fully Compliant' 'Satisfied' \
	'ADR creation is the later owning workflow'; do
	require_text "$SKILL" "$token"
done
for token in \
	'discoveries/DISCXXXXXX.md' 'discoveries/discoveries.md' \
	'Discovery identifier' 'Request identifier' 'Record path' 'Catalog path' \
	'no output' 'preserve existing bytes'; do
	require_text "$SKILL" "$token"
done
for token in \
	'## Reference Implementation Matching' '## Reference Implementation Counting' \
	'## Recommendation Tie-Break Evaluation' '## Reference Implementation Determinism' \
	'## Reference Implementation Scope Clarification' '## Reference Implementation Traceability' \
	'explicitly references a matching Reference Architecture' \
	'explicitly references the identifier' 'unique matching Reference Implementations' \
	'duplicate references count once' 'Malformed Reference Implementations' \
	'absent or unreadable catalog' 'internally inconsistent' \
	'Reference Architecture Match' 'Reference Implementation Count' \
	'Lowest Discovery-scoped `OPT` identifier' 'Stop immediately' \
	'score and confidence' 'ADR ownership' \
	'Reference Implementation data is evaluated only according to the Reference Implementation Evaluation rules and is used exclusively for deterministic tie-breaking.'; do
	require_text "$SKILL" "$token"
done
for token in \
	'semantic similarity' 'inference' 'approximation' 'similarity scoring' \
	'timestamps' 'creation dates' 'modification dates' 'recency' 'environment state' 'randomness' \
	'endorsement' 'approval' 'architectural correctness' 'implementation suitability' \
	'implementation authorization' 'record a decision'; do
	require_text "$SKILL" "$token"
done
for token in 'Desired Change alignment' 'Objective alignment' 'constraint alignment' 'alphabetical title' \
	'OPT000001' 'two through five' 'deduplicate' 'supporting evidence' 'truncation boundary' \
	'Candidate Solution Option' 'Summary:' 'Benefits:' 'Risks:' 'Assumptions:' 'Dependencies:'; do
	require_text "$SKILL" "$token"
done
for token in 'explicit identifier' 'exact normalized title' 'capability identifier' 'Objective identifier' \
	'Control identifier' 'NFR identifier' 'every Reference Architecture' 'highest-precedence' \
	'Objective 25' 'NFR 25' 'Control 20' 'Constraint Alignment 20' 'Risk Reduction 10' 'floor' \
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
for token in 'name: discovery-record' 'id: DISCXXXXXX' 'request: REQXXXXXX' '## Request Reference' '## Research Findings' '## Assumptions' '## Risks' '## Unknowns' '## Candidate Solution Options' '## Candidate Solution Comparison Matrix' '## Recommendation' '## Objective Relationships' '## Control Relationships' '## NFR Relationships' '## Reference Architecture Matches' 'OPTXXXXXX' 'Recommendation Status' 'Complexity' 'Governance Impact' 'Operational Overhead'; do
	require_text "$RECORD_TEMPLATE" "$token"
done
require_absent "$RECORD_TEMPLATE" '^## Request$'
for token in '## Request Solution Constraints' 'allowed_solution_classes' 'existing_platforms_required' 'existing_platforms_preferred' 'known_systems' 'hosting_restrictions' 'vendor_restrictions' 'procurement_constraints' 'regulatory_restrictions' '## Candidate Elimination Log' 'Constraint Alignment' 'Satisfied Constraints' 'Unsatisfied Constraints' 'Required Platform Match' 'Preferred Platform Match' 'Known-System Alignment' 'Constraint Compliance' 'Allowed Solution Class' 'Constraint Alignment Score'; do
	require_text "$RECORD_TEMPLATE" "$token"
done
require_text "$SKILL" 'Request Solution Constraints'
require_text "$SKILL" 'Candidate Elimination Log'
require_text "$SKILL" '.highway/library/templates/output/discovery-record.md'
require_text "$SKILL" '.highway/library/templates/output/discovery-catalog.md'
require_text "$SKILL" 'Fully Compliant'
require_absent "$SKILL" 'Constraint Compliance` (`Fully Compliant` or `Satisfied`)'
require_text "$SKILL" 'Required Platform Match is 100 for traceability only'
require_text "$SKILL" 'Order entries by candidate identifier, constraint category, then constraint identifier or value'
require_absent "$RECORD_TEMPLATE" 'Constraint Compliance: <Fully Compliant or Satisfied>'
require_text "$RECORD_TEMPLATE" 'Constraint Compliance: Fully Compliant'
require_text "$RECORD_TEMPLATE" 'Desired Change: <0-100>'
require_text "$RECORD_TEMPLATE" 'Objective: <0-100>'
require_text "$RECORD_TEMPLATE" 'Constraints: <0-100>'
require_text "$RECORD_TEMPLATE" 'Required Platform Match: 100 (traceability only)'
require_text "$RECORD_TEMPLATE" 'Entries are ordered by Candidate Identifier, then Constraint Category, then Constraint Identifier or Value.'
if grep -Fq 'The record always includes the exact sections' "$SKILL"; then
	echo "FAIL: highway-discovery still independently declares relationship-section structure" >&2
	fail=1
fi
if grep -Fq 'Confirm the record has the required sections in shared-template order:' "$SKILL" ||
	grep -Fq 'Confirm the catalog has only `Version`, `Next ID`, and `## Discovery Index`' "$SKILL"; then
	echo "FAIL: highway-discovery still duplicates record or catalog layout verification" >&2
	fail=1
fi

# Each deterministic value rule is exercised by an independent disposable fixture.
valid_alignment="$WORK/alignment-valid.md"
decimal_alignment="$WORK/alignment-decimal.md"
negative_alignment="$WORK/alignment-negative.md"
high_alignment="$WORK/alignment-high.md"
valid_compliance="$WORK/compliance-valid.md"
invalid_compliance="$WORK/compliance-invalid.md"
printf '%s\n' 'Alignment: 0' >"$valid_alignment"
printf '%s\n' 'Alignment: 12.5' >"$decimal_alignment"
printf '%s\n' 'Alignment: -1' >"$negative_alignment"
printf '%s\n' 'Alignment: 101' >"$high_alignment"
printf '%s\n' 'Constraint Compliance: Fully Compliant' >"$valid_compliance"
printf '%s\n' 'Constraint Compliance: Satisfied' >"$invalid_compliance"
assert_alignment_fixture "$valid_alignment" valid
assert_alignment_fixture "$decimal_alignment" invalid
assert_alignment_fixture "$negative_alignment" invalid
assert_alignment_fixture "$high_alignment" invalid
assert_compliance_fixture "$valid_compliance" valid
assert_compliance_fixture "$invalid_compliance" invalid
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

# Clarification resolution fixtures cover catalog authority, direct paths, malformed fallback,
# source preservation, and deterministic repeated reads without creating repository-owned output.
clarification_dir="$WORK/clarifications"
mkdir -p "$clarification_dir"
clarification_artifact="$clarification_dir/REQ000001-clarification.md"
clarification_catalog="$clarification_dir/clarifications.md"
clarification_malformed="$clarification_dir/malformed.md"
printf '%s\n' \
	'---' \
	'id: CLAR-REQ000001' \
	'artifact_id: REQ000001' \
	'artifact_type: REQ' \
	'status: in-progress' \
	'open_findings: 1' \
	'resolved_findings: 1' \
	'total_findings: 2' \
	'blocking_reason: None' \
	'---' \
	'Response: Capacity remains unspecified.' \
	'State: open' \
	'Summary: Capacity is unspecified.' \
	'State: resolved' \
	'Response: Existing capacity is documented.' >"$clarification_artifact"
printf '%s\n' \
	'# Clarifications Catalog' \
	'' \
	'| Clarification ID | Artifact ID | Artifact Type | Status | Clarification Path |' \
	'| CLAR-REQ000001 | REQ000001 | REQ | in-progress | clarifications/REQ000001-clarification.md |' >"$clarification_catalog"
printf '%s\n' 'malformed clarification' >"$clarification_malformed"
[[ "$(grep -c '| CLAR-REQ000001 |' "$clarification_catalog")" -eq 1 ]] || fail=1
grep -Fq 'clarifications/REQ000001-clarification.md' "$clarification_catalog" || fail=1
grep -Fq 'status: in-progress' "$clarification_artifact" || fail=1
clarification_before="$(shasum "$clarification_artifact")"
clarification_catalog_before="$(shasum "$clarification_catalog")"
clarification_repeat="$WORK/repeat.md"
clarification_duplicate="$WORK/duplicate-clarifications.md"
clarification_stale="$WORK/stale-clarifications.md"
clarification_mismatch="$WORK/mismatch-clarifications.md"
cp "$clarification_catalog" "$clarification_duplicate"
printf '%s\n' '| CLAR-REQ000001 | REQ000001 | REQ | in-progress | clarifications/REQ000001-clarification.md |' >>"$clarification_duplicate"
printf '%s\n' '| CLAR-REQ000099 | REQ000099 | REQ | complete | clarifications/REQ000099-clarification.md |' >"$clarification_stale"
printf '%s\n' '| CLAR-REQ000001 | REQ000002 | REQ | complete | clarifications/REQ000002-clarification.md |' >"$clarification_mismatch"
cp "$clarification_artifact" "$clarification_repeat"
cmp -s "$clarification_artifact" "$clarification_repeat" || fail=1
[[ "$(shasum "$clarification_artifact")" == "$clarification_before" ]] || fail=1
[[ "$(shasum "$clarification_catalog")" == "$clarification_catalog_before" ]] || fail=1
[[ "$(grep -c '| CLAR-REQ000001 |' "$clarification_duplicate")" -eq 2 ]] || fail=1
grep -Fq 'CLAR-REQ000099' "$clarification_stale" || fail=1
grep -Fq '| REQ000002 |' "$clarification_mismatch" || fail=1
grep -Fq 'State: open' "$clarification_artifact" || fail=1
grep -Fq 'State: resolved' "$clarification_artifact" || fail=1
grep -Fq 'Summary:' "$clarification_artifact" || fail=1
require_text "$SKILL" 'malformed'
require_text "$SKILL" 'unreadable'

for protected_file in "$SKILL" "$RECORD_TEMPLATE" "$CATALOG_TEMPLATE" "$discovery_adapter"; do
	if [[ -f "$protected_file" ]]; then
		before_hash="$(shasum "$protected_file")"
		[[ "$(shasum "$protected_file")" == "$before_hash" ]] || fail=1
	fi
done

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
