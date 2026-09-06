#!/usr/bin/env bash
# Validates one skill directory against the constitution at .specify/memory/constitution.md and
# against .highway/skills/_authoring-standard.md.
#
# Usage: .highway/tools/validate-skill.sh <skill-dir>
# Output format is a contract: see specs/003-constitution-enforcement/contracts/validation-output.md
# Exit 0: no check failed. Exit 1: at least one check failed.
# Deferred and unchecked rules never affect exit status; enforcing a subset of the rules is the
# intended state, so unverified must not read as failed.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
# shellcheck source=tools/lib/frontmatter.sh
source "$SCRIPT_DIR/lib/frontmatter.sh"
# shellcheck source=tools/lib/schema-validate.sh
source "$SCRIPT_DIR/lib/schema-validate.sh"
# shellcheck source=tools/lib/constitution.sh
source "$SCRIPT_DIR/lib/constitution.sh"
# shellcheck source=tools/lib/body-scan.sh
source "$SCRIPT_DIR/lib/body-scan.sh"
# shellcheck source=tools/lib/rule-checks.sh
source "$SCRIPT_DIR/lib/rule-checks.sh"

if [[ $# -ne 1 ]]; then
	echo "ERROR: [SCHEMA] usage: .highway/tools/validate-skill.sh <skill-dir>" >&2
	exit 1
fi

skill_dir="${1%/}"
skill_file="$skill_dir/SKILL.md"
id="$(basename "$skill_dir")"
constitution="$(con_file "$REPO_ROOT")"

if [[ ! -f "$skill_file" ]]; then
	echo "ERROR: [SCHEMA] no SKILL.md found at '$skill_file'" >&2
	exit 1
fi

if [[ ! -f "$constitution" ]]; then
	echo "ERROR: [SCHEMA] constitution not found at '$constitution'" >&2
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
collect "$(sv_validate_description "$(fm_get "$skill_file" description || true)")"
collect "$(sv_validate_compatibility "$(fm_get "$skill_file" compatibility || true)")"

agent_exceptions="$(fm_get_agent_exceptions "$skill_file")"
if [[ -n "$agent_exceptions" ]]; then
	collect "$(printf '%s\n' "$agent_exceptions" | sv_validate_agent_exceptions)"
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
			observable="$(con_rule_field "$constitution" "$rule_id" observable)"
			while IFS= read -r finding; do
				[[ -z "$finding" ]] && continue
				collect "ERROR: [$rule_id] $finding ($observable)"
			done <<< "$findings"
			;;
		*)
			checked="$checked $rule_id"
			;;
	esac
done <<< "$(con_rules "$constitution")"

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
