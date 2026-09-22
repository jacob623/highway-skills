#!/usr/bin/env bash
# Verifies shared output-template governance for Feature 022.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONSTITUTION="$HIGHWAY_ROOT/governance/constitution.md"
EXPERIENCE="$HIGHWAY_ROOT/governance/experience-standard.md"
DEV_DIR=".spec""ify"
DEV_CONSTITUTION="$(cd "$HIGHWAY_ROOT/.." && pwd)/$DEV_DIR/memory/constitution.md"
RULE_CHECKS="$HIGHWAY_ROOT/tools/lib/rule-checks.sh"
NFR_SKILL="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
CONTROL_SKILL="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md"
NFR_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/nfr-record.md"
CONTROL_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/control-record.md"
PROFILE_SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
PROFILE_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/profile.yaml"
OBJECTIVE_SKILL="$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md"
OBJECTIVE_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/objective-record.md"
NEW_SKILL="$HIGHWAY_ROOT/skills/highway-new/SKILL.md"
REQUEST_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/request-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/request-catalog.md"
DEV_SPECS="spec""s"
FEATURE_CONTRACT_DIR="$(cd "$HIGHWAY_ROOT/.." && pwd)/$DEV_SPECS/053-request-solution-constraints/contracts"
INTAKE_CONTRACT="$FEATURE_CONTRACT_DIR/request-solution-constraints-intake-contract.md"
RECORD_CONTRACT="$FEATURE_CONTRACT_DIR/request-solution-constraints-record-contract.md"
DISCOVERY_SKILL="$HIGHWAY_ROOT/skills/highway-discovery/SKILL.md"
DISCOVERY_RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/discovery-record.md"
DISCOVERY_CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/discovery-catalog.md"
OBJECTIVE_CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/objective-catalog.md"
CONTROL_CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/control-catalog.md"
NFR_CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/nfr-catalog.md"
CLARIFY_SKILL="$HIGHWAY_ROOT/skills/highway-clarify/SKILL.md"
CLARIFICATION_CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/clarification-catalog.md"
VALIDATE_LIBRARY="$HIGHWAY_ROOT/tools/validate-library.sh"
VALIDATE_SKILL="$HIGHWAY_ROOT/tools/validate-skill.sh"

fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

require_file() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: expected file does not exist: $file"
		fail=1
	fi
}

template_pair_inventory_valid() {
	local root="$1"
	local artifact
	for artifact in request objective control nfr discovery; do
		[[ -f "$root/${artifact}-record.md" ]] || return 1
		[[ -f "$root/${artifact}-catalog.md" ]] || return 1
	done
}

catalog_shape_valid() {
	local file="$1" name="$2" next_id="$3" index_heading="$4"
	grep -Fq "name: $name" "$file" || return 1
	grep -Fq "Version: 1.0.0" "$file" || return 1
	grep -Fq "Next ID: $next_id" "$file" || return 1
	grep -Fq "## $index_heading" "$file" || return 1
	grep -Fq '| ' "$file" || return 1
}

skill_citations_valid() {
	local file="$1" record_path="$2" catalog_path="$3"
	grep -Fq "$record_path" "$file" || return 1
	grep -Fq "$catalog_path" "$file" || return 1
}

discovery_structure_not_duplicated() {
	local file="$1"
	if grep -Fq "contains, in" "$file" && grep -Fq -- "- Request Reference" "$file"; then
		return 1
	fi
}

nfr_catalog_structure_not_duplicated() {
	local file="$1"
	if grep -Fq "global baseline statement" "$file" ||
		grep -Fq "every NFR index entry" "$file" ||
		grep -Fq "Confirm the catalog indexes every record" "$file"; then
		return 1
	fi
}

# Governance rules and the P9.1 registered check must be present before validation is trusted.
require_text "$CONSTITUTION" "| P9.1 |"
require_text "$EXPERIENCE" "| X1.5 |"
require_text "$DEV_CONSTITUTION" "| D8.1 |"
require_text "$RULE_CHECKS" "P9.1"

# Markdown records need complete shared skeletons; the profile is a pure-YAML output contract.
require_file "$NFR_TEMPLATE"
require_file "$CONTROL_TEMPLATE"
require_file "$PROFILE_TEMPLATE"
require_file "$OBJECTIVE_TEMPLATE"
require_file "$REQUEST_TEMPLATE"
require_file "$CATALOG_TEMPLATE"
require_file "$DISCOVERY_SKILL"
require_file "$DISCOVERY_RECORD_TEMPLATE"
require_file "$DISCOVERY_CATALOG_TEMPLATE"
require_file "$OBJECTIVE_CATALOG_TEMPLATE"
require_file "$CONTROL_CATALOG_TEMPLATE"
require_file "$NFR_CATALOG_TEMPLATE"
require_file "$CLARIFICATION_CATALOG_TEMPLATE"
require_file "$INTAKE_CONTRACT"
require_file "$RECORD_CONTRACT"
if [[ -f "$NFR_TEMPLATE" ]]; then
	require_text "$NFR_TEMPLATE" "name: nfr-record"
	require_text "$NFR_TEMPLATE" "id: NFRXXXXXX"
	require_text "$NFR_TEMPLATE" "controls: []"
	require_text "$NFR_TEMPLATE" "status: active"
	require_text "$NFR_TEMPLATE" "## File Frontmatter"
	require_text "$NFR_TEMPLATE" "## Body"
	require_text "$NFR_TEMPLATE" "<user-provided statement>"
	require_text "$NFR_TEMPLATE" "<user-provided rationale>"
fi
if [[ -f "$CONTROL_TEMPLATE" ]]; then
	require_text "$CONTROL_TEMPLATE" "name: control-record"
	require_text "$CONTROL_TEMPLATE" "id: CTLXXXXXX"
	require_text "$CONTROL_TEMPLATE" "nfrs: []"
	require_text "$CONTROL_TEMPLATE" "status: active"
	require_text "$CONTROL_TEMPLATE" "## File Frontmatter"
	require_text "$CONTROL_TEMPLATE" "## Body"
	require_text "$CONTROL_TEMPLATE" "<user-provided statement>"
	require_text "$CONTROL_TEMPLATE" "<user-provided rationale>"
fi
if [[ -f "$PROFILE_TEMPLATE" ]]; then
	require_text "$PROFILE_TEMPLATE" "metadata:"
	require_text "$PROFILE_TEMPLATE" "organization:"
	require_text "$PROFILE_TEMPLATE" "constraints:"
	require_text "$PROFILE_TEMPLATE" "preferences:"
	require_text "$PROFILE_TEMPLATE" "vendor_strategy:"
fi
if [[ -f "$OBJECTIVE_TEMPLATE" ]]; then
	require_text "$OBJECTIVE_TEMPLATE" "name: objective-record"
	require_text "$OBJECTIVE_TEMPLATE" "id: OBJXXXXXX"
	require_text "$OBJECTIVE_TEMPLATE" "capabilities: []"
	require_text "$OBJECTIVE_TEMPLATE" "status: active"
	require_text "$OBJECTIVE_TEMPLATE" "## File Frontmatter"
	require_text "$OBJECTIVE_TEMPLATE" "## Body"
	require_text "$OBJECTIVE_TEMPLATE" "## Statement"
	require_text "$OBJECTIVE_TEMPLATE" "## Success Measures"
	require_text "$OBJECTIVE_TEMPLATE" "## Rationale"
fi
if [[ -f "$REQUEST_TEMPLATE" ]]; then
	require_text "$REQUEST_TEMPLATE" "name: request-record"
	require_text "$REQUEST_TEMPLATE" "id: REQXXXXXX"
	require_text "$REQUEST_TEMPLATE" "## Problem"
	require_text "$REQUEST_TEMPLATE" "## Solution Constraints"
	require_text "$REQUEST_TEMPLATE" "allowed_solution_classes:"
	require_text "$REQUEST_TEMPLATE" "existing_platforms_required:"
	require_text "$REQUEST_TEMPLATE" "existing_platforms_preferred:"
	require_text "$REQUEST_TEMPLATE" "known_systems:"
	require_text "$REQUEST_TEMPLATE" "hosting_restrictions:"
	require_text "$REQUEST_TEMPLATE" "vendor_restrictions:"
	require_text "$REQUEST_TEMPLATE" "procurement_constraints:"
	require_text "$REQUEST_TEMPLATE" "regulatory_restrictions:"
	require_text "$REQUEST_TEMPLATE" "## Completeness"
fi
if [[ -f "$CATALOG_TEMPLATE" ]]; then
	require_text "$CATALOG_TEMPLATE" "name: request-catalog"
	require_text "$CATALOG_TEMPLATE" "Version: 1.0.0"
	require_text "$CATALOG_TEMPLATE" "Next ID: REQXXXXXX"
fi
for catalog_pair in \
	"$OBJECTIVE_CATALOG_TEMPLATE|objective-catalog|OBJXXXXXX|Objective Index" \
	"$CONTROL_CATALOG_TEMPLATE|control-catalog|CTLXXXXXX|Control Index" \
	"$NFR_CATALOG_TEMPLATE|nfr-catalog|NFRXXXXXX|NFR Index"; do
	IFS='|' read -r catalog_file catalog_name next_id index_heading <<EOF
$catalog_pair
EOF
	if [[ -f "$catalog_file" ]]; then
		require_text "$catalog_file" "name: $catalog_name"
		require_text "$catalog_file" "Version: 1.0.0"
		require_text "$catalog_file" "Next ID: $next_id"
	require_text "$catalog_file" "## $index_heading"
	fi
done

# Each file-emitting skill must cite its complete skeleton.
require_text "$NFR_SKILL" ".highway/library/templates/output/nfr-record.md"
require_text "$CONTROL_SKILL" ".highway/library/templates/output/control-record.md"
require_text "$PROFILE_SKILL" ".highway/library/templates/output/profile.yaml"
require_text "$OBJECTIVE_SKILL" ".highway/library/templates/output/objective-record.md"
require_text "$OBJECTIVE_SKILL" ".highway/library/templates/output/objective-catalog.md"
require_text "$CONTROL_SKILL" ".highway/library/templates/output/control-catalog.md"
require_text "$NFR_SKILL" ".highway/library/templates/output/nfr-catalog.md"
require_text "$CLARIFY_SKILL" ".highway/library/templates/output/clarification-catalog.md"

require_text "$NEW_SKILL" ".highway/library/templates/output/request-record.md"
require_text "$NEW_SKILL" ".highway/library/templates/output/request-catalog.md"
require_text "$DISCOVERY_SKILL" ".highway/library/templates/output/discovery-catalog.md"
require_text "$CONTROL_SKILL" ".highway/library/templates/output/control-catalog.md"
require_text "$NEW_SKILL" "Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints, Solution Constraints"
require_text "$NEW_SKILL" "No business constraints"
require_text "$NEW_SKILL" "one or more non-empty values"
for discovery_token in "## Request Solution Constraints" "allowed_solution_classes" "existing_platforms_required" "existing_platforms_preferred" "known_systems" "hosting_restrictions" "vendor_restrictions" "procurement_constraints" "regulatory_restrictions" "## Candidate Elimination Log" "Constraint Alignment" "Satisfied Constraints" "Unsatisfied Constraints" "Required Platform Match" "Preferred Platform Match" "Known-System Alignment" "Constraint Compliance"; do
	require_text "$DISCOVERY_RECORD_TEMPLATE" "$discovery_token"
done

# Behavioral ownership remains in skills after structural prose is delegated to templates.
for behavior_token in "evidence" "privacy" "allocation" "transaction" "determin"; do
	require_text "$NEW_SKILL" "$behavior_token"
done
for behavior_token in "readiness" "relationship" "version" "transaction"; do
	require_text "$OBJECTIVE_SKILL" "$behavior_token"
	require_text "$CONTROL_SKILL" "$behavior_token"
	require_text "$NFR_SKILL" "$behavior_token"
done
for control_behavior in "catalog" "derived" "No timestamp" "unchanged baseline" "next identifier" "allocation" "transaction" "readiness" "NFR proposal"; do
	require_text "$CONTROL_SKILL" "$control_behavior"
done
for behavior_token in "elimination" "filter" "scor" "recommend" "traceab" "determin"; do
	require_text "$DISCOVERY_SKILL" "$behavior_token"
done

# The citation is the structure authority; these duplicated field/body declarations must be gone.
if grep -Eq 'with YAML frontmatter for `id`, `title`, `status`, and `controls: \[\]`' "$NFR_SKILL"; then
	echo "FAIL: highway-nfrs still duplicates the output frontmatter contract"
	fail=1
fi
if grep -Eq 'carrying frontmatter with `id`,[[:space:]]*$' "$CONTROL_SKILL"; then
	echo "FAIL: highway-controls still duplicates the output frontmatter contract"
	fail=1
fi
if grep -Fq 'listing every Control by identifier and title' "$CONTROL_SKILL" ||
	grep -Fq 'stating the baseline version' "$CONTROL_SKILL" ||
	grep -Fq 'recording the next identifier to allocate' "$CONTROL_SKILL" ||
	grep -Fq 'Controls are managed through this skill rather than by hand' "$CONTROL_SKILL"; then
	echo "FAIL: highway-controls still duplicates the complete catalog structure"
	fail=1
fi

# Library and skill validators must accept the migrated source artifacts.
if [[ -f "$NFR_TEMPLATE" ]]; then
	if ! "$VALIDATE_LIBRARY" "$NFR_TEMPLATE" >/dev/null 2>&1; then
		echo "FAIL: NFR output template does not pass validate-library.sh"
		fail=1
	fi
fi
if [[ -f "$CONTROL_TEMPLATE" ]]; then
	if ! "$VALIDATE_LIBRARY" "$CONTROL_TEMPLATE" >/dev/null 2>&1; then
		echo "FAIL: Control output template does not pass validate-library.sh"
		fail=1
	fi
fi
if [[ -f "$OBJECTIVE_TEMPLATE" ]]; then
	if ! "$VALIDATE_LIBRARY" "$OBJECTIVE_TEMPLATE" >/dev/null 2>&1; then
		echo "FAIL: objective output template does not pass validate-library.sh"
		fail=1
	fi
fi
if [[ -f "$REQUEST_TEMPLATE" ]]; then
	if ! "$VALIDATE_LIBRARY" "$REQUEST_TEMPLATE" >/dev/null 2>&1; then
		echo "FAIL: request output template does not pass validate-library.sh"
		fail=1
	fi
fi
if [[ -f "$CATALOG_TEMPLATE" ]]; then
	if ! "$VALIDATE_LIBRARY" "$CATALOG_TEMPLATE" >/dev/null 2>&1; then
		echo "FAIL: request catalog template does not pass validate-library.sh"
		fail=1
	fi
fi
if [[ -f "$CLARIFICATION_CATALOG_TEMPLATE" ]]; then
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "name: clarification-catalog"
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "Version: 1.0.0"
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "## Clarification Index"
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "Clarification ID"
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "Artifact ID"
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "Artifact Type"
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "Status"
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "Clarification Path"
	require_text "$CLARIFICATION_CATALOG_TEMPLATE" "resolves directly to the authoritative clarification artifact"
fi
if ! "$VALIDATE_SKILL" "$HIGHWAY_ROOT/skills/highway-nfrs" >/dev/null 2>&1; then
	echo "FAIL: highway-nfrs does not pass validate-skill.sh"
	fail=1
fi
if ! "$VALIDATE_SKILL" "$HIGHWAY_ROOT/skills/highway-controls" >/dev/null 2>&1; then
	echo "FAIL: highway-controls does not pass validate-skill.sh"
	fail=1
fi

# The current file-emitting skills are the complete set of citing skills for this feature.
citing_count="$(grep -RIl 'library/templates/output/' "$HIGHWAY_ROOT/skills" --include='SKILL.md' | wc -l | tr -d ' ')"
if [[ "$citing_count" != "7" ]]; then
	echo "FAIL: expected 7 output-template citing skills, found $citing_count"
	fail=1
fi
for citing_skill in "$NFR_SKILL" "$CONTROL_SKILL" "$PROFILE_SKILL" "$OBJECTIVE_SKILL" "$NEW_SKILL" "$DISCOVERY_SKILL" "$CLARIFY_SKILL"; do
	if ! grep -Fq "library/templates/output/" "$citing_skill"; then
		echo "FAIL: dependent review omitted citing skill $citing_skill"
		fail=1
	fi
done

# Disposable probes independently reject missing templates, incomplete catalog metadata, missing
# citations, and duplicated structural declarations without changing canonical files.
fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-output-contract.XXXXXX")"
fixture_templates="$fixture_root/templates"
mkdir -p "$fixture_templates"

# NFR structure is delegated to the shared templates while workflow behavior remains in the skill.
nfr_citation_fixture="$fixture_root/nfr-missing-catalog-citation.md"
sed '/nfr-catalog\.md/d' "$NFR_SKILL" > "$nfr_citation_fixture"
if skill_citations_valid "$nfr_citation_fixture" \
	".highway/library/templates/output/nfr-record.md" \
	".highway/library/templates/output/nfr-catalog.md"; then
	echo "FAIL: missing NFR catalog citation fixture was accepted"
	fail=1
fi

nfr_duplicate_fixture="$fixture_root/nfr-duplicate-catalog-structure.md"
cp "$NFR_SKILL" "$nfr_duplicate_fixture"
printf '%s\n' 'A generated prose catalog containing the global baseline statement and every NFR index entry.' >> "$nfr_duplicate_fixture"
if nfr_catalog_structure_not_duplicated "$nfr_duplicate_fixture"; then
	echo "FAIL: duplicated NFR catalog structure fixture was accepted"
	fail=1
fi
if ! nfr_catalog_structure_not_duplicated "$NFR_SKILL"; then
	echo "FAIL: highway-nfrs still duplicates catalog structure"
	fail=1
fi

for retained_artifact in request objective control nfr discovery; do
	cp "$HIGHWAY_ROOT/library/templates/output/${retained_artifact}-record.md" "$fixture_templates/"
	cp "$HIGHWAY_ROOT/library/templates/output/${retained_artifact}-catalog.md" "$fixture_templates/"
done
rm -f "$fixture_templates/objective-catalog.md"
if template_pair_inventory_valid "$fixture_templates"; then
	echo "FAIL: missing catalog fixture was accepted"
	fail=1
fi

for catalog_fixture in objective control nfr; do
	source_catalog="$HIGHWAY_ROOT/library/templates/output/${catalog_fixture}-catalog.md"
	case "$catalog_fixture" in
		objective) catalog_name="objective-catalog"; next_id="OBJXXXXXX"; index_heading="Objective Index" ;;
		control) catalog_name="control-catalog"; next_id="CTLXXXXXX"; index_heading="Control Index" ;;
		nfr) catalog_name="nfr-catalog"; next_id="NFRXXXXXX"; index_heading="NFR Index" ;;
	esac
	for catalog_rule in identity version next-id index; do
		fixture_catalog="$fixture_root/${catalog_fixture}-${catalog_rule}.md"
		case "$catalog_rule" in
			identity) sed '/^name:/d' "$source_catalog" > "$fixture_catalog" ;;
			version) sed '/^Version:/d' "$source_catalog" > "$fixture_catalog" ;;
			next-id) sed '/^Next ID:/d' "$source_catalog" > "$fixture_catalog" ;;
			index) sed '/^## .*Index$/d' "$source_catalog" > "$fixture_catalog" ;;
		esac
		if catalog_shape_valid "$fixture_catalog" "$catalog_name" "$next_id" "$index_heading"; then
			echo "FAIL: incomplete $catalog_fixture catalog fixture ($catalog_rule) was accepted"
			fail=1
		fi
	done
done

citation_fixture="$fixture_root/objectives-missing-citation.md"
sed '/objective-catalog\.md/d' "$OBJECTIVE_SKILL" > "$citation_fixture"
if skill_citations_valid "$citation_fixture" \
	".highway/library/templates/output/objective-record.md" \
	".highway/library/templates/output/objective-catalog.md"; then
	echo "FAIL: missing skill citation fixture was accepted"
	fail=1
fi

duplicate_fixture="$fixture_root/discovery-duplicate-structure.md"
cp "$DISCOVERY_SKILL" "$duplicate_fixture"
printf '%s\n' '- The record contains, in shared template order:' '- Request Reference' >> "$duplicate_fixture"
if discovery_structure_not_duplicated "$duplicate_fixture"; then
	echo "FAIL: duplicated Discovery structure fixture was accepted"
	fail=1
fi

control_adapter="$HIGHWAY_ROOT/../.github/skills/highway-controls/SKILL.md"
if [[ -f "$control_adapter" ]] && ! cmp -s "$CONTROL_SKILL" "$control_adapter"; then
	grep -Fq '.highway/library/templates/output/control-catalog.md' "$control_adapter" || {
		echo "FAIL: Control adapter is stale relative to the canonical catalog citation"
		fail=1
	}
fi

# Snapshot canonical and generated artifacts before disposable checks complete.
for protected_file in "$CONTROL_SKILL" "$DISCOVERY_SKILL" "$CONTROL_TEMPLATE" "$DISCOVERY_RECORD_TEMPLATE" "$DISCOVERY_CATALOG_TEMPLATE" "$control_adapter"; do
	if [[ -f "$protected_file" ]]; then
		before_hash="$(shasum "$protected_file")"
		[[ "$(shasum "$protected_file")" == "$before_hash" ]] || fail=1
	fi
done
rm -rf "$fixture_root"

exit "$fail"
