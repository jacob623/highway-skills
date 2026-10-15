#!/usr/bin/env bash
# Verifies the Highway Reference Implementation workflow contract for Feature 176.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document
# Seeded failure probe: --probe source-document exercises the probe contract; --neutralise restores it.

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi
if [[ -n "$probe_class" ]]; then
	probe_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-implementation-onboarding.XXXXXX")"
	probe_path="$probe_root/probe.md"
	trap 'rm -rf "$probe_root"' EXIT
	if [[ "$neutralise" -eq 1 ]]; then
		printf '%s\n' 'implementation contract token' >"$probe_path"
	else
		printf '%s\n' 'missing required token' >"$probe_path"
	fi
	grep -Fq 'implementation contract token' "$probe_path"
	exit $?
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-implementation/SKILL.md"
RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/implementation-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/implementation-catalog.md"

fail=0
require_file() {
	if [[ ! -f "$1" ]]; then
		echo "FAIL: expected file does not exist: $1"
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
forbidden_text() {
	local file="$1" text="$2"
	if [[ -f "$file" ]] && grep -Fq -- "$text" "$file"; then
		echo "FAIL: forbidden '$text' present in $file"
		fail=1
	fi
}

require_file "$SKILL"
require_file "$RECORD_TEMPLATE"
require_file "$CATALOG_TEMPLATE"

if [[ -f "$SKILL" ]]; then
	require_text "$SKILL" "name: highway-implementation"
	require_text "$SKILL" "usage: \"Invoke as \`/highway-implementation\` with one Reference Architecture ID.\""
	require_text "$SKILL" "Exactly one explicit uppercase \`ARCH######\` identifier"
	require_text "$SKILL" "Next Action: Provide the Reference Architecture to implement."
	require_text "$SKILL" "Which Reference Architecture would you like to use?"
	require_text "$SKILL" "ARCH000001"
	require_text "$SKILL" "ARCH000002"
	require_text "$SKILL" "must allocate no identifier, create no implementation artifact, and select no architecture automatically"
	require_text "$SKILL" "canonical completeness validator"
	require_text "$SKILL" "canonical readiness validator"
	require_text "$SKILL" "must not select the newest or only ARCH"
	require_text "$SKILL" "must not infer an ARCH from context"
	require_text "$SKILL" "must not use filesystem order, timestamps, recency, environment state, or session memory"
	require_text "$SKILL" "preserve every pre-operation implementation and catalog byte"
	require_text "$SKILL" "status \`accepted\`"
	require_text "$SKILL" ".highway/library/templates/output/implementation-record.md"
	require_text "$SKILL" ".highway/library/templates/output/implementation-catalog.md"
	require_text "$SKILL" "RI######"
	require_text "$SKILL" "implementations/RIXXXXXX.md"
	require_text "$SKILL" "implementations/implementations.md"
	require_text "$SKILL" "proposed"
	require_text "$SKILL" "missing -> continue"
	require_text "$SKILL" "blocked -> continue"
	require_text "$SKILL" "malformed or inconsistent Profile, Objective, Control, or NFR -> abort without writes"
	require_text "$SKILL" "malformed Clarification"
	require_text "$SKILL" "Reference Architecture remains authoritative"
	require_text "$SKILL" "does not redesign architecture"
	require_text "$SKILL" "validation before persistence"
	require_text "$SKILL" "atomic"
	require_text "$SKILL" "no partial output"
	require_text "$SKILL" "byte-identical"
	require_text "$SKILL" "No timestamps"
	require_text "$SKILL" "retry an allocation conflict no more than three times"
	require_text "$SKILL" "all seven lifecycle activities"
	require_text "$SKILL" "Technology choices are permitted only"
	require_text "$SKILL" "Security Control Realization"
	require_text "$SKILL" "NFR Realization"
	require_text "$SKILL" "does not produce plans"
	require_text "$SKILL" "executable source code"
	forbidden_text "$SKILL" "create an architecture"
	forbidden_text "$SKILL" "authorize deployment"
fi

if [[ -f "$RECORD_TEMPLATE" ]]; then
	require_text "$RECORD_TEMPLATE" "name: implementation-record"
	require_text "$RECORD_TEMPLATE" "id: RIXXXXXX"
	require_text "$RECORD_TEMPLATE" "architecture: ARCHXXXXXX"
	require_text "$RECORD_TEMPLATE" "status: proposed"
	for section in \
		"## Architecture Reference" "## Context" "## Implementation Summary" "## Technology Realization" \
		"## Runtime Components" "## Deployment Topology" "## Environment Strategy" "## Data Realization" \
		"## Integration Realization" "## Security Control Realization" "## NFR Realization" \
		"## Lifecycle Activities" "## Assumptions" "## Risks" "## Constraints" "## Dependencies" "## Traceability"; do
		require_text "$RECORD_TEMPLATE" "$section"
	done
	for activity in Design Build Test Deploy Operate Monitor Improve; do
		require_text "$RECORD_TEMPLATE" "### $activity"
	done
fi

if [[ -f "$CATALOG_TEMPLATE" ]]; then
	require_text "$CATALOG_TEMPLATE" "name: implementation-catalog"
	require_text "$CATALOG_TEMPLATE" "Next ID: RIXXXXXX"
	require_text "$CATALOG_TEMPLATE" "## Implementation Index"
	require_text "$CATALOG_TEMPLATE" "Architecture ID"
	require_text "$CATALOG_TEMPLATE" "Implementation Path"
	require_text "$CATALOG_TEMPLATE" "architecture uniqueness"
	require_text "$CATALOG_TEMPLATE" "appear at most once"
fi

if (( fail != 0 )); then
	exit 1
fi
printf '%s\n' "PASS: highway-implementation onboarding contract"
