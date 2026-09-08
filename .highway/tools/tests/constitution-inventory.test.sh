#!/usr/bin/env bash
# Tests that the rule inventory is parsed from the constitution and that a malformed rule table
# fails loudly rather than silently shrinking the inventory.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# shellcheck source=tools/lib/constitution.sh
source "$HIGHWAY_ROOT/tools/lib/constitution.sh"

CONSTITUTION="$HIGHWAY_ROOT/governance/constitution.md"
fail=0

# --- The parsed inventory matches the constitution itself ---------------------------------

expected_total="$(grep -cE '^\| P[0-9]+\.[0-9]+ ' "$CONSTITUTION" | tr -d ' ')"
actual_total="$(con_rules "$CONSTITUTION" | wc -l | tr -d ' ')"
if [[ "$actual_total" != "$expected_total" ]]; then
	echo "FAIL: parsed $actual_total rules, constitution contains $expected_total"
	fail=1
fi

for tier in auto agent-checkable human-review; do
	expected="$(grep -cE "\[$tier\] \|\$" "$CONSTITUTION" | tr -d ' ')"
	actual="$(con_rule_ids_by_tier "$CONSTITUTION" "$tier" | wc -l | tr -d ' ')"
	if [[ "$actual" != "$expected" ]]; then
		echo "FAIL: tier '$tier' parsed $actual rules, constitution declares $expected"
		fail=1
	fi
done

# --- Every rule id is unique and well formed ----------------------------------------------

dupes="$(con_rule_ids "$CONSTITUTION" | sort | uniq -d)"
if [[ -n "$dupes" ]]; then
	echo "FAIL: duplicate rule ids parsed: $dupes"
	fail=1
fi

malformed_ids="$(con_rule_ids "$CONSTITUTION" | grep -vE '^P[0-9]+\.[0-9]+$' || true)"
if [[ -n "$malformed_ids" ]]; then
	echo "FAIL: malformed rule ids parsed: $malformed_ids"
	fail=1
fi

# --- Field lookup returns the constitution's own text -------------------------------------

tier="$(con_rule_field "$CONSTITUTION" P7.1 tier)"
if [[ "$tier" != "auto" ]]; then
	echo "FAIL: expected P7.1 tier 'auto', got '$tier'"
	fail=1
fi

observable="$(con_rule_field "$CONSTITUTION" P7.1 observable)"
if [[ -z "$observable" ]]; then
	echo "FAIL: P7.1 observable is empty"
	fail=1
fi

# --- A malformed rule row fails loudly rather than shrinking the inventory ------------------

tmp_constitution="$(mktemp)"
trap 'rm -f "$tmp_constitution"' EXIT
sed 's/^| P7\.1 |.*$/| P7.1 | rule text with no observable and no tier |/' "$CONSTITUTION" >"$tmp_constitution"

if con_rules "$tmp_constitution" >/dev/null 2>&1; then
	echo "FAIL: a malformed rule row was accepted instead of reported"
	fail=1
fi

malformed_output="$(con_rules "$tmp_constitution" 2>&1 >/dev/null)"
if [[ "$malformed_output" != *"P7.1"* ]]; then
	echo "FAIL: malformed row error did not name the offending rule id. Got: $malformed_output"
	fail=1
fi

# --- Token lists and their exclusions come from the constitution ----------------------------

token_count="$(con_token_list "$CONSTITUTION" 'Prohibited Vagueness List' | wc -l | tr -d ' ')"
if [[ "$token_count" -lt 20 ]]; then
	echo "FAIL: parsed only $token_count prohibited vagueness tokens"
	fail=1
fi

exclusions="$(con_token_list_exclusions "$CONSTITUTION" 'Prohibited Vagueness List')"
if [[ "$exclusions" != *"Illustrative Examples"* ]]; then
	echo "FAIL: exclusions were not read from the constitution. Got: $exclusions"
	fail=1
fi

# --- The [auto] tier is honest ---------------------------------------------------------------
#
# A tier tag is a claim about how a rule is decided, and [auto] claims a script decides it. This
# asserts the claim is true for every rule, so the tier cannot drift back into promising
# enforcement that does not exist.
#
# Scope is the Highway Skills Constitution only, and the failure message says so. The Highway
# Development Constitution has the same defect and is addressed separately; a guard that appeared
# to cover governance in general would turn that open gap into an apparently closed one.

# shellcheck source=tools/lib/rule-checks.sh
source "$HIGHWAY_ROOT/tools/lib/rule-checks.sh"

registered="$(rc_registered_ids | tr ' ' '\n' | sort -u)"
unenforced=""
while IFS= read -r rule_id; do
	[[ -n "$rule_id" ]] || continue
	if ! printf '%s\n' "$registered" | grep -qx "$rule_id"; then
		unenforced="$unenforced $rule_id"
	fi
done < <(con_rule_ids_by_tier "$CONSTITUTION" auto)

if [[ -n "$unenforced" ]]; then
	echo "FAIL: the Highway Skills Constitution tags these rules [auto] but no check decides them:$unenforced"
	fail=1
fi

exit $fail
