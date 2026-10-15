#!/usr/bin/env bash
# Verifies the Highway Reference Architecture workflow contract for Feature 175.
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
	probe_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-architecture-onboarding.XXXXXX")"
	probe_path="$probe_root/probe.md"
	trap 'rm -rf "$probe_root"' EXIT
	if [[ "$neutralise" -eq 1 ]]; then
		printf '%s\n' 'architecture contract token' >"$probe_path"
	else
		printf '%s\n' 'missing required token' >"$probe_path"
	fi
	grep -Fq 'architecture contract token' "$probe_path"
	exit $?
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-architecture/SKILL.md"
RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/architecture-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/architecture-catalog.md"

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
	require_text "$SKILL" "name: highway-architecture"
	require_text "$SKILL" "usage: \"Invoke as \`/highway-architecture\` with one ADR ID.\""
	require_text "$SKILL" "Exactly one explicit ADRXXXXXX identifier"
	require_text "$SKILL" "Next Action: Provide the Architecture Decision Record to use."
	require_text "$SKILL" "Which ADR would you like to convert into a Reference Architecture?"
	require_text "$SKILL" "ADR000001"
	require_text "$SKILL" "ADR000002"
	require_text "$SKILL" "must allocate no identifier, create no Reference Architecture, and select no ADR automatically"
	require_text "$SKILL" "canonical completeness validator"
	require_text "$SKILL" "canonical readiness validator"
	require_text "$SKILL" "must not select the newest or only ADR"
	require_text "$SKILL" "must not infer an ADR from context"
	require_text "$SKILL" "must not use filesystem order, timestamps, recency, environment state, or session memory"
	require_text "$SKILL" "preserve every pre-operation architecture and catalog byte"
	require_text "$SKILL" "status is accepted"
	require_text "$SKILL" ".highway/library/templates/output/architecture-record.md"
	require_text "$SKILL" ".highway/library/templates/output/architecture-catalog.md"
	require_text "$SKILL" "ARCHXXXXXX"
	require_text "$SKILL" "proposed"
	require_text "$SKILL" "missing -> continue"
	require_text "$SKILL" "blocked -> continue"
	require_text "$SKILL" "malformed or inconsistent -> abort without writes"
	require_text "$SKILL" "validation before persistence"
	require_text "$SKILL" "atomic"
	require_text "$SKILL" "ADR remains authoritative"
	require_text "$SKILL" "does not modify ADR, Discovery, Request, Profile, Objective"
	require_text "$SKILL" "reject duplicate"
	require_text "$SKILL" "bounded retry limit"
	require_text "$SKILL" "no partial output"
	require_text "$SKILL" "byte-identical"
	require_text "$SKILL" "No timestamps"
	require_text "$SKILL" "No capability artifacts"
	require_text "$SKILL" "Reference Implementation Guidance"
	require_text "$SKILL" "implementation authorization is excluded"
	forbidden_text "$SKILL" "generate a capability artifact"
	forbidden_text "$SKILL" "authorize implementation by Reference Architecture"
fi

if [[ -f "$RECORD_TEMPLATE" ]]; then
	require_text "$RECORD_TEMPLATE" "name: architecture-record"
	require_text "$RECORD_TEMPLATE" "id: ARCHXXXXXX"
	require_text "$RECORD_TEMPLATE" "adr: ADRXXXXXX"
	require_text "$RECORD_TEMPLATE" "status: proposed"
	for section in \
		"## ADR Reference" "## Context" "## Architecture Summary" "## Architecture Style" \
		"## Logical Components" "## Interaction Model" "## Trust Boundaries" "## Deployment Pattern" \
		"## Key Technologies" "## Inherited ADR Decisions" "## Constraints" "## Objective Relationships" \
		"## Control Relationships" "## NFR Relationships" "## Required Capabilities" "## Assumptions" \
		"## Risks" "## Reference Implementation Guidance" "## Traceability"; do
		require_text "$RECORD_TEMPLATE" "$section"
	done
fi

if [[ -f "$CATALOG_TEMPLATE" ]]; then
	require_text "$CATALOG_TEMPLATE" "name: architecture-catalog"
	require_text "$CATALOG_TEMPLATE" "Next ID: ARCHXXXXXX"
	require_text "$CATALOG_TEMPLATE" "## Architecture Index"
	require_text "$CATALOG_TEMPLATE" "ADR ID"
	require_text "$CATALOG_TEMPLATE" "Architecture Path"
	require_text "$CATALOG_TEMPLATE" "Entries are unique"
	require_text "$CATALOG_TEMPLATE" "appear at most once"
fi

if (( fail != 0 )); then
	exit 1
fi
printf '%s\n' "PASS: highway-architecture onboarding contract"
