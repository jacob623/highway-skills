#!/usr/bin/env bash
# Verifies the highway-clarify skill and shared clarification output contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: each declared class must fail before neutralisation.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-clarify/SKILL.md"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/clarification-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/clarification-catalog.md"
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
	if [[ "$neutralise" -eq 0 ]]; then
		printf '%s\n' 'missing contract marker' >"$probe_path"
	else
		printf '%s\n' 'clarification contract token' >"$probe_path"
	fi
	if grep -Fq 'clarification contract token' "$probe_path"; then exit 0; fi
	exit 1
fi

require_file() { [[ -f "$1" ]] || { echo "FAIL: missing $1"; fail=1; }; }
require_text() { grep -Fq "$2" "$1" || { echo "FAIL: '$2' missing from $1"; fail=1; }; }
require_file "$SKILL"
require_file "$TEMPLATE"
require_file "$CATALOG_TEMPLATE"
for token in \
	'Generates, updates, validates, and serves deterministic clarification records for Highway artifacts.' \
	'## Purpose' '## When to use' '## When not to use' '## Inputs' '## Outputs' \
	'## Workflow' '## Verification' '## Error Handling' '## Example' \
	'/highway-clarify <ARTIFACT-ID>' '/highway-clarify update <ARTIFACT-ID>' \
	'/highway-clarify inspect <ARTIFACT-ID>' '/highway-clarify read <ARTIFACT-ID>' \
	'/highway-clarify status <ARTIFACT-ID>' \
	'REQ######' 'DISC######' 'ADR######' 'RA######' \
	'contradiction' 'missing_input' 'unknown_value' 'ambiguity' 'unresolved_assumption' \
	'case-sensitive' 'filesystem ordering' 'colocated' 'source artifact' \
	'revision' 'expected_revision' 'actual_revision' 'no automatic merging' \
	'at most 3 times' 'advisory' 'any repository user' 'write nothing' \
	'CLAR-<ARTIFACT-ID>' 'artifact-local' 'artifact-type' 'global' \
	'clarification-catalog.md' 'clarifications/clarifications.md' \
	'Artifact Type, then Artifact ID' 'one row per clarification' \
	'catalog rows use supported types and statuses' 'duplicate mapping' \
	'preserve catalog bytes' 'Catalog write failure' \
	'Ambiguity Vocabulary Contract' 'TBD' 'TBA' 'unknown' 'undecided' \
	'unspecified' 'not defined' 'not determined' 'pending' 'future decision' \
	'future work' 'exact normalized phrase comparison' 'Partial-word matching' \
	'regular expressions' 'semantic similarity' 'Contradiction Rule Contract' \
	'Rule Identifier' 'Artifact Type Scope' 'Source Field A' 'Source Field B' \
	'Contradiction Condition' 'Finding Summary Template' 'general knowledge' \
	'architectural recommendations' 'Finding Identity Contract' \
	'CLAR-<ARTIFACT-ID>-NNN' 'Fingerprint' 'retired' 'blocked' 'in-progress' \
	'not-started' 'Clarification Path' 'bootstrap' 'in-memory' 'pre-operation bytes' \
	'open_findings' 'resolved_findings' 'total_findings' 'blocking_reason' \
	'unchanged evidence' 'resolution history' 'source field name' \
	'<secret-redacted>' '<pii-redacted>' 'not-started' 'complete' 'blocked' \
	'recalculate current findings' 'preserving finding identities' 'retaining history' \
	'category priority' 'source artifact order' 'finding identifier' 'identical inputs' \
	'Fingerprint Normalization Contract' 'Normalize line endings to LF' 'trim leading and trailing whitespace' \
	'collapse consecutive whitespace' 'canonical declared source-field name' 'generated only after normalization' \
	'Finding State Contract' 'supported finding states' 'open' 'resolved' 'open -> resolved' \
	'resolved findings retain identifiers' 'resolved findings never transition to open' \
	'total_findings = open_findings + resolved_findings' 'malformed count relationships produce `blocked`' \
	'catalog entry resolves to an existing clarification artifact' 'every clarification artifact has exactly one catalog entry' \
	'catalog status equals clarification status' 'Clarification Path resolves to the referenced clarification artifact' \
	'default ambiguity vocabulary' 'may extend' 'MUST NOT remove' 'no volatile metadata'; do
	require_text "$SKILL" "$token"
done
for token in 'name: clarification-catalog' 'Version: 1.1.0' '## Clarification Index' \
	'Clarification ID' 'Artifact ID' 'Artifact Type' 'Status' 'REQ' 'DISC' 'ADR' 'RA' \
	'not-started' 'in-progress' 'complete' 'blocked'; do
	require_text "$CATALOG_TEMPLATE" "$token"
done
for token in 'name: clarification-record' 'revision: 1' 'artifact_id:' 'artifact_type:' 'source_path:' \
	'status:' 'open_findings:' 'resolved_findings:' 'total_findings:' 'blocking_reason:' \
	'id: CLAR-REQ000001' '## Findings' '## Resolution History' '## Source' '## Status' \
	'finding_id: CLAR-REQ000001-001' 'finding_id: CLAR-REQ000001-002' 'evidence_ref:' 'retired identifiers' 'fingerprint:' \
	'State: resolved' 'Open Findings: 1' 'Resolved Findings: 1' 'Total Findings: 2' \
	'<secret-redacted>' '<pii-redacted>' 'finding_id:' 'evidence_ref:' 'State:'; do
	require_text "$TEMPLATE" "$token"
done

mkdir -p "$WORK/requests"
printf '%s\n' 'source-before' >"$WORK/requests/REQ000001.md"
before="$(shasum "$WORK/requests/REQ000001.md")"
[[ "$(shasum "$WORK/requests/REQ000001.md")" == "$before" ]] || fail=1
[[ ! -d "$HIGHWAY_ROOT/requests" ]] || fail=1

normalize_probe() {
	printf '%s' "$1" | tr '\r' '\n' | tr '\n' ' ' | tr '[:upper:]' '[:lower:]' | awk '{$1=$1; print}'
}

normalized_mixed="$(normalize_probe $'  REQUIREMENTS\r\n\tFIELD  ')"
normalized_lf="$(normalize_probe $'requirements\nfield')"
[[ "$normalized_mixed" == "$normalized_lf" ]] || {
	echo "FAIL: line endings, case, and whitespace did not normalize equivalently"
	fail=1
}
normalized_distinct="$(normalize_probe 'requirements other-field')"
[[ "$normalized_mixed" != "$normalized_distinct" ]] || {
	echo "FAIL: distinct normalized evidence was merged"
	fail=1
}

counts_valid() {
	local open_count="$1" resolved_count="$2" total_count="$3"
	[[ "$open_count" -ge 0 && "$resolved_count" -ge 0 && "$total_count" -ge 0 ]] || return 1
	[[ "$total_count" -eq $((open_count + resolved_count)) ]]
}
counts_valid 1 1 2 || { echo "FAIL: valid finding counts were rejected"; fail=1; }
if counts_valid 1 1 3; then
	echo "FAIL: inconsistent finding counts were accepted"
	fail=1
fi
catalog_before="$(printf '%s' 'catalog-before' | shasum)"
catalog_after="$(printf '%s' 'catalog-before' | shasum)"
[[ "$catalog_before" == "$catalog_after" ]] || { echo "FAIL: disposable catalog bytes changed"; fail=1; }

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo "PASS: highway-clarify contract and disposable workspace checks"
