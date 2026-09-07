#!/usr/bin/env bash
# Validates one shared content file (template, knowledge, or governance) against the
# constitution at .specify/memory/constitution.md, the same way validate-skill.sh validates a
# skill. See specs/004-shared-content-library/contracts/content-validation-output.md.
#
# Usage: .highway/tools/validate-content.sh <content-file>
# Exit 0: no check failed. Exit 1: at least one check failed.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
# shellcheck source=tools/lib/frontmatter.sh
source "$SCRIPT_DIR/lib/frontmatter.sh"
# shellcheck source=tools/lib/content-schema.sh
source "$SCRIPT_DIR/lib/content-schema.sh"
# shellcheck source=tools/lib/constitution.sh
source "$SCRIPT_DIR/lib/constitution.sh"
# shellcheck source=tools/lib/body-scan.sh
source "$SCRIPT_DIR/lib/body-scan.sh"
# shellcheck source=tools/lib/rule-checks.sh
source "$SCRIPT_DIR/lib/rule-checks.sh"

if [[ $# -ne 1 ]]; then
	echo "ERROR: [SCHEMA] usage: .highway/tools/validate-content.sh <content-file>" >&2
	exit 1
fi

content_file="$1"
constitution="$(con_file "$REPO_ROOT")"

if [[ ! -f "$content_file" ]]; then
	echo "ERROR: [SCHEMA] no content file found at '$content_file'" >&2
	exit 1
fi

if [[ ! -f "$constitution" ]]; then
	echo "ERROR: [SCHEMA] constitution not found at '$constitution'" >&2
	exit 1
fi

# --- Content type detection (FR-001 through FR-004) ----------------------------------------

content_type=""
case "$content_file" in
	*/content/templates/*) content_type="template" ;;
	*/content/knowledge/*) content_type="knowledge" ;;
	*/content/governance/*) content_type="governance" ;;
esac

if [[ -z "$content_type" ]]; then
	echo "ERROR: [CONTENT-TYPE] '$content_file' is not located under content/templates/, content/knowledge/, or content/governance/" >&2
	exit 1
fi

name="$(fm_get "$content_file" name || true)"

errors=""
failed_rules=""

collect() {
	local out="$1"
	[[ -n "$out" ]] && errors="${errors}${out}"$'\n'
	return 0
}

# --- Schema-level checks (minimal frontmatter shape, FR-014) --------------------------------

collect "$(cs_validate_name "$name")"
collect "$(cs_validate_description "$(fm_get "$content_file" description || true)")"

# --- Rule-level checks --------------------------------------------------------------------

template_exempt=""
if [[ "$content_type" == "template" ]]; then
	template_exempt="$(rc_template_exempt_ids)"
fi

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

	if [[ -n "$template_exempt" ]] && printf '%s\n' "$template_exempt" | grep -qx "$rule_id"; then
		na="$na ${rule_id}=N2"
		continue
	fi

	check_fn="$(rc_check_fn "$rule_id")"
	if [[ -z "$check_fn" ]]; then
		unchecked="$unchecked $rule_id"
		continue
	fi

	findings="$("$check_fn" "$content_file")"
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
	echo "FAILED: content '$content_type/$name' violates $finding_count rule(s)"
	exit 1
fi

echo "OK: content '$content_type/$name' is valid ($(count "$checked") rules checked, $(count "$deferred") deferred, $(count "$unchecked") unchecked)"
exit 0
