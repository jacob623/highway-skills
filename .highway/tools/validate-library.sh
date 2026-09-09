#!/usr/bin/env bash
# Validates one shared library file (template, knowledge, or governance) against the
# constitution at .highway/governance/constitution.md, the same way validate-skill.sh validates a
# skill. Output format is a contract: per feature 005 (rename content to library).
#
# Usage: .highway/tools/validate-library.sh <library-file>
# Exit 0: no check failed. Exit 1: at least one check failed.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=tools/lib/frontmatter.sh
source "$SCRIPT_DIR/lib/frontmatter.sh"
# shellcheck source=tools/lib/library-schema.sh
source "$SCRIPT_DIR/lib/library-schema.sh"
# shellcheck source=tools/lib/constitution.sh
source "$SCRIPT_DIR/lib/constitution.sh"
# shellcheck source=tools/lib/body-scan.sh
source "$SCRIPT_DIR/lib/body-scan.sh"
# shellcheck source=tools/lib/rule-checks.sh
source "$SCRIPT_DIR/lib/rule-checks.sh"

if [[ $# -ne 1 ]]; then
	echo "ERROR: [SCHEMA] usage: .highway/tools/validate-library.sh <library-file>" >&2
	exit 1
fi

library_file="$1"
constitution="$(con_file "$HIGHWAY_ROOT")"

if [[ ! -f "$library_file" ]]; then
	echo "ERROR: [SCHEMA] no library file found at '$library_file'" >&2
	exit 1
fi

if [[ ! -f "$constitution" ]]; then
	echo "ERROR: [SCHEMA] constitution not found at '$constitution'" >&2
	exit 1
fi
# --- Framework containment ---------------------------------------------------------------------

# A file outside this framework root belongs to the user, not to Highway, and is not judged here.
# Without this the classification below matches on a path glob alone, so the same user file is
# judged when named by an absolute path and declined when named by a relative one -- containment
# that depends on how a path is typed is not containment.
#
# Scoped to the framework root rather than to its library/ subdirectory: the test fixtures live
# under tools/tests/fixtures/library/, so the narrower scope would decline every one of them.
library_file_abs="$(cd "$(dirname "$library_file")" 2>/dev/null && pwd)/$(basename "$library_file")"
case "$library_file_abs" in
	"$HIGHWAY_ROOT"/*) ;;
	*)
		echo "ERROR: [OUT-OF-SCOPE] '$library_file' is outside the Highway framework root; it belongs to the repository and is not validated here" >&2
		exit 1
		;;
esac
# --- Library type detection (FR-001 through FR-004) -----------------------------------------

library_type=""
case "$library_file" in
	*/library/templates/*) library_type="template" ;;
	*/library/knowledge/*) library_type="knowledge" ;;
	*/library/governance/*) library_type="governance" ;;
esac

if [[ -z "$library_type" ]]; then
	echo "ERROR: [LIBRARY-TYPE] '$library_file' is not located under library/templates/, library/knowledge/, or library/governance/" >&2
	exit 1
fi

name="$(fm_get "$library_file" name || true)"

errors=""
failed_rules=""

collect() {
	local out="$1"
	[[ -n "$out" ]] && errors="${errors}${out}"$'\n'
	return 0
}

# --- Schema-level checks (minimal frontmatter shape, FR-014) --------------------------------

collect "$(ls_validate_name "$name")"
collect "$(ls_validate_description "$(fm_get "$library_file" description || true)")"

# --- Rule-level checks --------------------------------------------------------------------

template_exempt=""
if [[ "$library_type" == "template" ]]; then
	template_exempt="$(rc_template_exempt_ids)"
fi
# Applies to every library type, unlike template_exempt above.
library_exempt="$(rc_library_exempt_ids)"

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

	if printf '%s\n' "$library_exempt" | grep -qx "$rule_id"; then
		na="$na ${rule_id}=N2"
		continue
	fi

	check_fn="$(rc_check_fn "$rule_id")"
	if [[ -z "$check_fn" ]]; then
		unchecked="$unchecked $rule_id"
		continue
	fi

	findings="$("$check_fn" "$library_file")"
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
	echo "FAILED: library '$library_type/$name' violates $finding_count rule(s)"
	exit 1
fi

echo "OK: library '$library_type/$name' is valid ($(count "$checked") rules checked, $(count "$deferred") deferred, $(count "$unchecked") unchecked)"
