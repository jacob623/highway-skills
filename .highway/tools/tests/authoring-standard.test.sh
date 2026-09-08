#!/usr/bin/env bash
# Tests that the authoring standard cites constitution rule ids instead of restating rule text,
# so the two documents cannot drift apart (P7.3).
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# shellcheck source=tools/lib/constitution.sh
source "$HIGHWAY_ROOT/tools/lib/constitution.sh"

STANDARD="$HIGHWAY_ROOT/skills/_authoring-standard.md"
CONSTITUTION="$HIGHWAY_ROOT/governance/constitution.md"
fail=0

if [[ ! -f "$STANDARD" ]]; then
	echo "FAIL: authoring standard not found at $STANDARD"
	exit 1
fi

# --- The standard cites rule ids ------------------------------------------------------------

citation_count="$(grep -oE 'P[0-9]+\.[0-9]+' "$STANDARD" | sort -u | wc -l | tr -d ' ')"
if [[ "$citation_count" -lt 15 ]]; then
	echo "FAIL: the authoring standard cites only $citation_count distinct rule ids; expected at least 15"
	fail=1
fi

# --- Every cited rule id exists in the constitution -------------------------------------------

known_ids="$(con_rule_ids "$CONSTITUTION" | sort -u)"
for cited in $(grep -oE 'P[0-9]+\.[0-9]+' "$STANDARD" | sort -u); do
	if ! printf '%s\n' "$known_ids" | grep -qx "$cited"; then
		echo "FAIL: the authoring standard cites $cited, which the constitution does not define"
		fail=1
	fi
done

# --- No constitution rule text is restated ------------------------------------------------------

duplicated="$(con_rules "$CONSTITUTION" | cut -f3 | while IFS= read -r rule_text; do
	[[ ${#rule_text} -lt 25 ]] && continue
	if grep -qF "$rule_text" "$STANDARD"; then
		printf '%s\n' "$rule_text"
	fi
done)"

if [[ -n "$duplicated" ]]; then
	echo "FAIL: the authoring standard restates constitution rule text:"
	printf '%s\n' "$duplicated" | sed 's/^/    /'
	fail=1
fi

# --- The documented section list matches what validation requires ---------------------------------

# shellcheck source=tools/lib/frontmatter.sh
source "$HIGHWAY_ROOT/tools/lib/frontmatter.sh"
# shellcheck source=tools/lib/schema-validate.sh
source "$HIGHWAY_ROOT/tools/lib/schema-validate.sh"

for section in "${SV_REQUIRED_SECTIONS[@]}"; do
	if ! grep -qF "## $section" "$STANDARD"; then
		echo "FAIL: required section '$section' is not documented in the authoring standard"
		fail=1
	fi
done

exit $fail
