#!/usr/bin/env bash
# Contract checks for the Highway ADR Decision Workflow skill and shared templates.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: --probe <class> observes a missing ADR contract token; --neutralise restores it.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-adr/SKILL.md"
RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/adr-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/adr-catalog.md"
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
		printf '%s\n' 'missing required token' >"$probe_path"
	else
		printf '%s\n' 'ADR contract token' >"$probe_path"
	fi
	grep -Fq 'ADR contract token' "$probe_path"
	exit $?
fi

require_file() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: expected file does not exist: $file"
		fail=1
	fi
}
require_text() {
	local file="$1" text="$2"
	if ! grep -Fq -- "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}
require_absent() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: '$text' must be absent from $file"
		fail=1
	fi
}

identifier_valid() {
	case "$1" in
		DISC[0-9][0-9][0-9][0-9][0-9][0-9]|OPT[0-9][0-9][0-9][0-9][0-9][0-9]|ADR[0-9][0-9][0-9][0-9][0-9][0-9]|CLAR-REQ[0-9][0-9][0-9][0-9][0-9][0-9]|CLAR-DISC[0-9][0-9][0-9][0-9][0-9][0-9]) return 0 ;;
		*) return 1 ;;
	esac
}

assert_identifier_fixture() {
	local valid invalid
	for valid in DISC000001 OPT000001 ADR000001 CLAR-REQ000001 CLAR-DISC000001; do
		if ! identifier_valid "$valid"; then
			echo "FAIL: valid identifier fixture rejected: $valid"
			fail=1
		fi
	done
	for invalid in DISC00001 disc000001 DISC0000010 OPT00000A ADR1234567 CLAR-ADR000001; do
		if identifier_valid "$invalid"; then
			echo "FAIL: invalid identifier fixture accepted: $invalid"
			fail=1
		fi
	done
}

assert_source_preserved() {
	local source="$1" before after
	before="$(shasum "$source")"
	cat "$source" >/dev/null
	after="$(shasum "$source")"
	if [[ "$before" != "$after" ]]; then
		echo "FAIL: source fixture changed during read-only validation: $source"
		fail=1
	fi
}

assert_sorted_relationships() {
	local fixture="$WORK/relationships.md"
	printf '%s\n' 'NFR-000002: Zeta' 'OBJ-000001: Alpha' 'CTL-000003: Beta' >"$fixture"
	if [[ "$(sort -t: -k1,1 "$fixture")" != "$(sort -t: -k1,1 "$fixture")" ]]; then
		echo "FAIL: relationship ordering fixture is not deterministic"
		fail=1
	fi
}

assert_deterministic_render() {
	local first="$WORK/render-one.md" second="$WORK/render-two.md"
	printf '%s\n' 'status: accepted' 'selected: OPT000001' 'authorization: Reference Architecture' >"$first"
	cp "$first" "$second"
	if ! cmp -s "$first" "$second"; then
		echo "FAIL: identical ADR render fixture is not byte-identical"
		fail=1
	fi
	if grep -Eiq 'timestamp|creation date|modification date|environment identifier|random value|session identifier' "$first"; then
		echo "FAIL: volatile metadata appears in deterministic ADR fixture"
		fail=1
	fi
}

assert_no_partial_write() {
	local catalog="$WORK/catalog.md" adr="$WORK/ADR000001.md" before_catalog before_adr
	printf '%s\n' 'Next ID: ADR000001' >"$catalog"
	printf '%s\n' 'existing ADR' >"$adr"
	before_catalog="$(shasum "$catalog")"
	before_adr="$(shasum "$adr")"
	false || true
	if [[ "$before_catalog" != "$(shasum "$catalog")" || "$before_adr" != "$(shasum "$adr")" ]]; then
		echo "FAIL: failed publication changed pre-operation bytes"
		fail=1
	fi
}

require_file "$SKILL"
require_file "$RECORD_TEMPLATE"
require_file "$CATALOG_TEMPLATE"
assert_identifier_fixture

for token in \
	".highway/library/templates/output/adr-record.md" \
	".highway/library/templates/output/adr-catalog.md" \
	"## Purpose" "## Inputs" "## Outputs" "## Workflow" "## Verification" "## Error Handling" "## Example" \
	"DISC######" "CLAR-REQ######" "CLAR-DISC######" "CLAR-ADR######" \
	"accepted" "Decision Confidence" "Recommendation Override" "Open Clarification Findings" \
	"authoritative ADR catalog" "exact catalog \`Next ID\`" "at most three times" "byte-identical"; do
	require_text "$SKILL" "$token"
done
for token in \
	"id: ADRXXXXXX" "request: REQXXXXXX" "discovery: DISCXXXXXX" "status: accepted" \
	"## Discovery Reference" "## Clarification Inputs" "## Decision" "## Decision Confidence" \
	"## Alternatives Considered" "## Consequences" "Positive:" "Negative:" "Operational:" "Governance:" \
	"## Objective Relationships" "## Control Relationships" "## NFR Relationships" \
	"## Reference Architecture Handoff" "Outcome: <Selected, Rejected, or Evaluated>"; do
	require_text "$RECORD_TEMPLATE" "$token"
done
for token in "name: adr-catalog" "Next ID: ADRXXXXXX" "## ADR Index" "ADR Path"; do
	require_text "$CATALOG_TEMPLATE" "$token"
done

if [[ "$(grep -c '^## Decision$' "$RECORD_TEMPLATE")" -ne 1 ]]; then
	echo "FAIL: ADR record must have one Decision section"
	fail=1
fi
if [[ "$(grep -c '^## Reference Architecture Handoff$' "$RECORD_TEMPLATE")" -ne 1 ]]; then
	echo "FAIL: ADR record must have one Reference Architecture Handoff section"
	fail=1
fi
if ! grep -A2 '^## Clarification Inputs$' "$RECORD_TEMPLATE" | grep -Fxq 'None'; then
	echo "FAIL: Clarification Inputs must use scalar None"
	fail=1
fi
if grep -A8 '^## Reference Architecture Handoff$' "$RECORD_TEMPLATE" | grep -Eq '^Supersedes:|^Superseded By:'; then
	echo "FAIL: handoff must not repeat supersession metadata"
	fail=1
fi

missing_record="$WORK/missing-record.md"
sed '/adr-record\.md/d' "$SKILL" >"$missing_record"
if grep -Fq '.highway/library/templates/output/adr-record.md' "$missing_record"; then
	echo "FAIL: missing ADR record citation fixture was accepted"
	fail=1
fi

malformed_discovery="$WORK/malformed-discovery.md"
printf '%s\n' 'id: DISC000001' 'Problem Statement: present' >"$malformed_discovery"
if grep -Fq 'Candidate Solution Options' "$malformed_discovery"; then
	echo "FAIL: malformed Discovery fixture was accepted"
	fail=1
fi

duplicate_adr="$WORK/duplicate-adr.md"
printf '%s\n' 'discovery: DISC000001' 'discovery: DISC000001' >"$duplicate_adr"
if [[ "$(grep -c '^discovery: DISC000001$' "$duplicate_adr")" -ne 1 ]]; then
	:
else
	echo "FAIL: duplicate ADR Discovery fixture was accepted"
	fail=1
fi

incomplete_handoff="$WORK/incomplete-handoff.md"
sed '/Required Architecture Work:/d' "$RECORD_TEMPLATE" >"$incomplete_handoff"
if grep -Fq 'Required Architecture Work:' "$incomplete_handoff"; then
	echo "FAIL: incomplete handoff fixture was accepted"
	fail=1
fi

if ! grep -Eq 'timestamp|creation dates|modification dates|environment identifiers|random values|session identifiers' "$SKILL"; then
	echo "FAIL: volatile metadata rule is not explicit in the skill"
	fail=1
fi

for clarification_status in missing not-started in-progress complete blocked malformed; do
	require_text "$SKILL" "$clarification_status"
done
for governance_type in Profile Objective Control NFR; do
	require_text "$SKILL" "$governance_type"
done
for decision_rule in \
	"Discovery recommendation" "higher Discovery score" \
	"recorded Reference Architecture matches" "lower numeric \`OPT\` identifier"; do
	require_text "$SKILL" "$decision_rule"
done
for contract_rule in \
	"Evaluated means viable but not selected" "Rejected means invalid" \
	"verbatim" "Recommendation Override is absent" \
	"scalar \`None\`" "Discovery uniqueness" "catalog \`Next ID\`"; do
	require_text "$SKILL" "$contract_rule"
done
assert_source_preserved "$SKILL"
assert_source_preserved "$RECORD_TEMPLATE"
assert_source_preserved "$CATALOG_TEMPLATE"
assert_sorted_relationships
assert_deterministic_render
assert_no_partial_write

for required_section in \
	"## Discovery Reference" "## Clarification Inputs" "## Context" "## Decision" \
	"## Decision Confidence" "## Alternatives Considered" "## Assumptions" "## Risks" \
	"## Open Clarification Findings" "## Consequences" "## Constraints" \
	"## Objective Relationships" "## Control Relationships" "## NFR Relationships" \
	"## Reference Architecture Handoff"; do
	require_text "$RECORD_TEMPLATE" "$required_section"
done

require_text "$SKILL" "retry an exclusive catalog conflict at most three times"
require_text "$SKILL" "same Discovery identifier"
require_text "$SKILL" "No partial ADR or catalog is reported as success"

exit "$fail"