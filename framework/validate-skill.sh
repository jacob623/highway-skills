#!/usr/bin/env bash
# Validates one skill directory against the constitution at framework/constitution.md
# and against framework/authoring-standard.md.
#
# Usage: framework/validate-skill.sh [--no-cache] <skill-dir>
# Output format is a contract: per feature 003 (constitution enforcement).
# Exit 0: no check failed. Exit 1: at least one check failed.
# Deferred and unchecked rules never affect exit status; enforcing a subset of the rules is the
# intended state, so unverified must not read as failed.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/paths.sh
source "$SCRIPT_DIR/lib/paths.sh"
# shellcheck source=lib/frontmatter.sh
source "$HW_LIB/frontmatter.sh"
# shellcheck source=lib/frontmatter-contract.sh
source "$HW_LIB/frontmatter-contract.sh"
# shellcheck source=lib/yaml-frontmatter.sh
source "$HW_LIB/yaml-frontmatter.sh"
# shellcheck source=lib/schema-validate.sh
source "$HW_LIB/schema-validate.sh"
# shellcheck source=lib/constitution.sh
source "$HW_LIB/constitution.sh"
# shellcheck source=lib/body-scan.sh
source "$HW_LIB/body-scan.sh"
# shellcheck source=lib/rule-checks.sh
source "$HW_LIB/rule-checks.sh"
# shellcheck source=lib/validation-cache.sh
source "$HW_LIB/validation-cache.sh"
# shellcheck source=lib/library-schema.sh
source "$HW_LIB/library-schema.sh"
# shellcheck source=lib/flows.sh
source "$HW_LIB/flows.sh"

use_cache=1
if [[ ${1:-} == "--no-cache" ]]; then
	use_cache=0
	shift
fi

if [[ $# -ne 1 ]]; then
	echo "ERROR: [SCHEMA] usage: framework/validate-skill.sh <skill-dir>" >&2
	exit 1
fi

skill_dir="${1%/}"
skill_file="$skill_dir/SKILL.md"
id="$(basename "$skill_dir")"
constitution="$(con_file "$HW_ROOT")"

# A skill is subject to both shipping governance documents: the constitution governs its text, the
# experience standard governs what it emits. Its bundled files are judged by the former only (see
# the bundled file checks below).
GOVERNANCE_DOCS=("$constitution")
experience_standard="$(con_experience_file "$HW_ROOT")"
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

# A recorded verdict for these exact inputs is replayed rather than re-derived. The replay prints
# the full report because callers parse it; a hit that printed nothing would be observably
# different from a full run.
cache_dir=""
cache_key=""
if (( use_cache )); then
	cache_dir="$(vc_dir "$HW_ROOT")"
	if [[ -n "$cache_dir" ]]; then
		cache_key="$(vc_key "$skill_file" "$HW_ROOT")"
		if vc_lookup "$cache_dir" "$cache_key"; then
			exit 0
		fi
	fi
fi

if [[ ! -f "$constitution" ]]; then
	echo "ERROR: [SCHEMA] constitution not found at '$constitution'" >&2
	exit 1
fi

# A malformed frontmatter contract manifest is a hard failure before any per-skill check runs
# (FR-003): a manifest that cannot be trusted must not silently pass every skill.
manifest_errors="$(fc_validate_manifest "$HW_ROOT")"
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

# Frontmatter is judged as a client's strict YAML parser reads it. A block that does not parse is
# reported once, and the field checks that would only repeat it are skipped.
parsed="$(yf_parse "$skill_file")"
if [[ $? -ne 0 ]]; then
	collect "$parsed"
else
	collect "$(sv_validate_name "$(yf_value "$parsed" top name)" "$id")"
	collect "$(sv_validate_closed_key_set "$parsed" "$HW_ROOT")"
	collect "$(sv_validate_string_types "$parsed")"
	collect "$(sv_validate_fields "$parsed" "$HW_ROOT")"
	collect "$(sv_validate_agreement "$parsed" "$skill_file")"
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

# --- Bundled file checks -------------------------------------------------------------------

# A file the skill bundles is judged by the constitution's rules, never the experience standard's:
# it emits nothing. A complete template (a file in assets/ with a template section) also needs a
# name and description; a reference has no frontmatter, so it skips those. A file in assets/
# without a template section, such as a seeded skeleton, is not judged as a template.
# Findings fail the skill but leave the verdict lines, which describe SKILL.md, unchanged.
bundled_exempt="$(rc_bundled_exempt_ids)"
template_exempt="$(rc_template_exempt_ids)"
reference_exempt="$(rc_reference_exempt_ids)"
flow_exempt="$(rc_flow_exempt_ids)"
constitution_rules="$(con_rules "$constitution")"

# check_bundled <file> <template|reference|flow>
# A flow file is a file in references/ that the flows table names: steps moved out of SKILL.md,
# judged as SKILL.md's instructions are, so only rc_flow_exempt_ids apply.
check_bundled() {
	local file="$1" kind="$2" rel exempt="$bundled_exempt" rule_line rule_id rest tier check_fn findings observable finding
	rel="$(basename "$(dirname "$file")")/$(basename "$file")"
	if [[ "$kind" == "template" ]]; then
		exempt="$exempt"$'\n'"$template_exempt"
		collect "$({ ls_validate_name "$(fm_get "$file" name || true)"
			ls_validate_description "$(fm_get "$file" description || true)"; } \
			| sed -E "s#^ERROR: \[([^]]+)\] #ERROR: [\1] $rel: #")"
	elif [[ "$kind" == "flow" ]]; then
		exempt="$flow_exempt"
	else
		exempt="$exempt"$'\n'"$reference_exempt"
	fi
	while IFS= read -r rule_line; do
		rule_id="${rule_line%%	*}"
		rest="${rule_line#*	}"
		tier="${rest%%	*}"
		[[ "$tier" == "auto" ]] || continue
		printf '%s\n' "$exempt" | grep -qx "$rule_id" && continue
		check_fn="$(rc_check_fn "$rule_id")"
		[[ -n "$check_fn" ]] || continue
		findings="$("$check_fn" "$file")"
		[[ $? -eq 1 ]] || continue
		[[ " $failed_rules " == *" $rule_id "* ]] || failed_rules="$failed_rules $rule_id"
		observable="$(con_rule_field "$constitution" "$rule_id" observable)"
		while IFS= read -r finding; do
			[[ -z "$finding" ]] && continue
			collect "ERROR: [$rule_id] $rel: $finding ($observable)"
		done <<< "$findings"
	done <<< "$constitution_rules"
}

for bundled_file in "$skill_dir"/assets/*.md; do
	[[ -f "$bundled_file" ]] || continue
	grep -Eq '^## (File Frontmatter|Body|Catalog Structure)[[:space:]]*$' "$bundled_file" || continue
	check_bundled "$bundled_file" template
done
flow_files="$(fl_files "$skill_dir")"
for bundled_file in "$skill_dir"/references/*.md; do
	[[ -f "$bundled_file" ]] || continue
	if printf '%s\n' "$flow_files" | grep -qxF "references/$(basename "$bundled_file")"; then
		check_bundled "$bundled_file" flow
	else
		check_bundled "$bundled_file" reference
	fi
done

# --- Report --------------------------------------------------------------------------------

if [[ -n "$errors" ]]; then
	printf '%s' "$errors" >&2
fi

sorted() { printf '%s' "$1" | tr ' ' '\n' | grep -v '^$' | sort -V | tr '\n' ' ' | sed 's/ $//'; }

report="CHECKED:   $(sorted "$checked")"$'\n'
report="${report}FAILED:    $(sorted "$failed_rules")"$'\n'
report="${report}N/A:       $(sorted "$na")"$'\n'
report="${report}DEFERRED:  $(sorted "$deferred")"$'\n'
report="${report}UNCHECKED: $(sorted "$unchecked")"$'\n'

count() { printf '%s' "$1" | tr ' ' '\n' | grep -cv '^$' | tr -d ' '; }

if [[ -n "$errors" ]]; then
	finding_count="$(printf '%s' "$errors" | grep -c '^ERROR: ' | tr -d ' ')"
	report="${report}FAILED: skill '$id' violates $finding_count rule(s)"$'\n'
	printf '%s' "$report"
	exit 1
fi

report="${report}OK: skill '$id' is valid ($(count "$checked") rules checked, $(count "$deferred") deferred, $(count "$unchecked") unchecked)"$'\n'
printf '%s' "$report"

# Recorded only on success, so a defective skill is re-validated and re-reported every time.
if (( use_cache )) && [[ -n "$cache_dir" && -n "$cache_key" ]]; then
	vc_record "$cache_dir" "$cache_key" "$report"
fi
exit 0
