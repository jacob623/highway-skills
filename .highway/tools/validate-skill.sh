#!/usr/bin/env bash
# Validates one skill directory against the constitution at .highway/governance/constitution.md
# and against .highway/skills/_authoring-standard.md.
#
# Usage: .highway/tools/validate-skill.sh <skill-dir>
# Output format is a contract: per feature 003 (constitution enforcement).
# Exit 0: no check failed. Exit 1: at least one check failed.
# Deferred and unchecked rules never affect exit status; enforcing a subset of the rules is the
# intended state, so unverified must not read as failed.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=tools/lib/frontmatter.sh
source "$SCRIPT_DIR/lib/frontmatter.sh"
# shellcheck source=tools/lib/frontmatter-contract.sh
source "$SCRIPT_DIR/lib/frontmatter-contract.sh"
# shellcheck source=tools/lib/frontmatter-lexicon.sh
source "$SCRIPT_DIR/lib/frontmatter-lexicon.sh"
# shellcheck source=tools/lib/schema-validate.sh
source "$SCRIPT_DIR/lib/schema-validate.sh"
# shellcheck source=tools/lib/constitution.sh
source "$SCRIPT_DIR/lib/constitution.sh"
# shellcheck source=tools/lib/body-scan.sh
source "$SCRIPT_DIR/lib/body-scan.sh"
# shellcheck source=tools/lib/rule-checks.sh
source "$SCRIPT_DIR/lib/rule-checks.sh"
# shellcheck source=tools/lib/dependency-check.sh
source "$SCRIPT_DIR/lib/dependency-check.sh"

if [[ $# -ne 1 ]]; then
	echo "ERROR: [SCHEMA] usage: .highway/tools/validate-skill.sh <skill-dir>" >&2
	exit 1
fi

skill_dir="${1%/}"
skill_file="$skill_dir/SKILL.md"
id="$(basename "$skill_dir")"
constitution="$(con_file "$HIGHWAY_ROOT")"

# A skill is subject to both shipping governance documents: the constitution governs its text, the
# experience standard governs what it emits. validate-library.sh deliberately loads only the
# former -- library content emits nothing, so experience rules would judge it against obligations
# it cannot have.
GOVERNANCE_DOCS=("$constitution")
experience_standard="$(con_experience_file "$HIGHWAY_ROOT")"
if [[ -f "$experience_standard" ]]; then
	GOVERNANCE_DOCS+=("$experience_standard")
fi

# Prints one field of a rule, searching each governance document in turn.
gov_rule_field() {
	local rule_id="$1" field="$2" doc value
	for doc in "${GOVERNANCE_DOCS[@]}"; do
		value="$(con_rule_field "$doc" "$rule_id" "$field")"
		if [[ -n "$value" ]]; then
			printf '%s' "$value"
			return 0
		fi
	done
}

if [[ ! -f "$skill_file" ]]; then
	echo "ERROR: [SCHEMA] no SKILL.md found at '$skill_file'" >&2
	exit 1
fi

if [[ ! -f "$constitution" ]]; then
	echo "ERROR: [SCHEMA] constitution not found at '$constitution'" >&2
	exit 1
fi

# A malformed frontmatter contract manifest is a hard failure before any per-skill check runs
# (FR-003): a manifest that cannot be trusted must not silently pass every skill.
manifest_errors="$(fc_validate_manifest "$HIGHWAY_ROOT")"
if [[ $? -ne 0 ]]; then
	printf '%s\n' "$manifest_errors" >&2
	exit 1
fi

errors=""
failed_rules=""

collect() {
	local out="$1"
	[[ -n "$out" ]] && errors="${errors}${out}"$'\n'
	return 0
}

# --- Schema-level checks (identity and frontmatter shape) ---------------------------------

collect "$(sv_validate_id "$id")"
collect "$(sv_validate_name "$(fm_get "$skill_file" name || true)" "$id")"

description_value="$(fm_get "$skill_file" description || true)"
description_errors="$(sv_validate_description "$description_value" "$HIGHWAY_ROOT")"
collect "$description_errors"
# The lexicon check is skipped once the length/presence check for a field has already failed, so
# a single nonsense field (e.g. an over-length placeholder) is reported once, not once per
# concern (mirrors the existing presence_failed skip-pattern for body-section rule checks below).
if [[ -z "$description_errors" ]]; then
	collect "$(fl_check_field "$HIGHWAY_ROOT" "description" "$description_value")"
fi

usage_value="$(fm_get "$skill_file" usage || true)"
usage_errors="$(sv_validate_usage "$usage_value" "$HIGHWAY_ROOT")"
collect "$usage_errors"
if [[ -z "$usage_errors" ]]; then
	collect "$(fl_check_field "$HIGHWAY_ROOT" "usage" "$usage_value")"
fi

collect "$(sv_validate_compatibility "$(fm_get "$skill_file" compatibility || true)" "$HIGHWAY_ROOT")"
collect "$(sv_validate_required_keys "$skill_file" "$HIGHWAY_ROOT")"
collect "$(sv_validate_closed_key_set "$skill_file" "$HIGHWAY_ROOT")"
collect "$(sv_validate_duplicate_keys "$skill_file")"

agent_exceptions="$(fm_get_agent_exceptions "$skill_file")"
if [[ -n "$agent_exceptions" ]]; then
	collect "$(printf '%s\n' "$agent_exceptions" | sv_validate_agent_exceptions "$HIGHWAY_ROOT")"
	while IFS='|' read -r _agent deviation; do
		[[ -z "$_agent" && -z "$deviation" ]] && continue
		collect "$(fl_check_field "$HIGHWAY_ROOT" "metadata.agent_exceptions[].deviation" "$deviation")"
	done <<< "$agent_exceptions"
fi

# --- Dependency checks (metadata.dependencies -> .highway/library/) -----------------------

dependency_findings="$(dc_validate_dependencies "$skill_file" "$HIGHWAY_ROOT")"
if [[ -n "$dependency_findings" ]]; then
	while IFS= read -r finding; do
		[[ -z "$finding" ]] && continue
		collect "ERROR: [DEPENDENCY] $finding"
	done <<< "$dependency_findings"
fi

# Required-section findings are tagged with the rule that owns each section.
section_findings="$(sv_validate_body_sections "$skill_file")"
collect "$section_findings"

# Rules whose presence check already failed above are not re-run, so one missing section
# produces one finding rather than two.
presence_failed=""
for tag in P7.1 P8.3; do
	if printf '%s\n' "$section_findings" | grep -q "\[$tag\]"; then
		presence_failed="$presence_failed $tag"
		failed_rules="$failed_rules $tag"
	fi
done

# --- Rule-level checks --------------------------------------------------------------------

checked=""
na=""
deferred=""
unchecked=""

while IFS= read -r rule_line; do
	rule_id="${rule_line%%	*}"
	rest="${rule_line#*	}"
	tier="${rest%%	*}"

	if [[ "$tier" != "auto" ]]; then
		deferred="$deferred $rule_id"
		continue
	fi

	check_fn="$(rc_check_fn "$rule_id")"
	if [[ -z "$check_fn" ]]; then
		unchecked="$unchecked $rule_id"
		continue
	fi

	if [[ " $presence_failed " == *" $rule_id "* ]]; then
		checked="$checked $rule_id"
		continue
	fi

	findings="$("$check_fn" "$skill_file")"
	status=$?

	case $status in
		2)
			na="$na ${rule_id}=$(rc_na_condition "$rule_id")"
			;;
		1)
			checked="$checked $rule_id"
			failed_rules="$failed_rules $rule_id"
				observable="$(gov_rule_field "$rule_id" observable)"
			while IFS= read -r finding; do
				[[ -z "$finding" ]] && continue
				collect "ERROR: [$rule_id] $finding ($observable)"
			done <<< "$findings"
			;;
		*)
			checked="$checked $rule_id"
			;;
	esac
done <<< "$(for doc in "${GOVERNANCE_DOCS[@]}"; do con_rules "$doc"; done)"

# --- Report --------------------------------------------------------------------------------

if [[ -n "$errors" ]]; then
	printf '%s' "$errors" >&2
fi

sorted() { printf '%s' "$1" | tr ' ' '\n' | grep -v '^$' | sort -V | tr '\n' ' ' | sed 's/ $//'; }

echo "CHECKED:   $(sorted "$checked")"
echo "FAILED:    $(sorted "$failed_rules")"
echo "N/A:       $(sorted "$na")"
echo "DEFERRED:  $(sorted "$deferred")"
echo "UNCHECKED: $(sorted "$unchecked")"

count() { printf '%s' "$1" | tr ' ' '\n' | grep -cv '^$' | tr -d ' '; }

if [[ -n "$errors" ]]; then
	finding_count="$(printf '%s' "$errors" | grep -c '^ERROR: ' | tr -d ' ')"
	echo "FAILED: skill '$id' violates $finding_count rule(s)"
	exit 1
fi

echo "OK: skill '$id' is valid ($(count "$checked") rules checked, $(count "$deferred") deferred, $(count "$unchecked") unchecked)"
exit 0
