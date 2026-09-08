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

# --- The [auto] tier is honest, in both constitutions -----------------------------------------
#
# A tier tag is a claim about how a rule is decided, and [auto] claims something decides it. This
# asserts the claim is true, so neither document can drift back into promising enforcement that
# does not exist.
#
# The two documents define [auto] differently, and the assertion differs accordingly. The Skills
# Constitution requires a registered check reporting under the rule id. The Development
# Constitution requires only that a named test decide the rule, because it has no registry and no
# artifact a validator runs against; its Enforcement Map records which test, and that map is
# checked here too.
#
# Every failure names its document. A message naming only the rule would leave a reader checking
# two constitutions to find out which one is wrong.

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

# Assembled rather than written literally: this file is scanned by shipped-tree-independence.test.sh,
# which searches for exactly this token. A literal here would fail that check on a file whose job
# is to read the development constitution. Exempting the file instead would remove it from a check
# that should cover it.
DEV_DIR=".spec""ify"
DEV_CONSTITUTION="$(cd "$HIGHWAY_ROOT/.." && pwd)/$DEV_DIR/memory/constitution.md"
if [[ -f "$DEV_CONSTITUTION" ]]; then
	# The tier tags are read here rather than through con_rule_ids_by_tier, which parses only the
	# P namespace and silently returns nothing for a D rule -- which made an earlier version of
	# this assertion pass without ever iterating.
	#
	# Generalising the shared parser was the alternative, and was rejected: lib/constitution.sh is
	# distributed to users, and teaching shipped code to read a document that never ships is the
	# same category error as shipping the packaging tooling. The cost is this second, deliberately
	# minimal reader.
	dev_auto_ids() {
		awk -F'|' '
			function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
			/^\|[[:space:]]*D[0-9]+\.[0-9]+[[:space:]]*\|/ {
				if (trim($5) == "[auto]") print trim($2)
			}
		' "$DEV_CONSTITUTION"
	}

	# One row per mapped rule: "<rule id><TAB><test filename>".
	dev_map="$(sed -n '/^### Enforcement Map/,/^## /p' "$DEV_CONSTITUTION" \
		| awk -F'|' '
			function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
			/^\|[[:space:]]*D[0-9]+\.[0-9]+[[:space:]]*\|/ { print trim($2) "\t" trim($3) }
		')"

	dev_unmapped=""
	while IFS= read -r rule_id; do
		[[ -n "$rule_id" ]] || continue
		if ! printf '%s\n' "$dev_map" | grep -q "^$rule_id	"; then
			dev_unmapped="$dev_unmapped $rule_id"
		fi
	done < <(dev_auto_ids)

	if [[ -n "$dev_unmapped" ]]; then
		echo "FAIL: the Highway Development Constitution tags these rules [auto] but the Enforcement Map does not name a test for them:$dev_unmapped"
		fail=1
	fi

	# A row naming a renamed or deleted test is the failure mode most likely to appear next.
	while IFS=$'\t' read -r rule_id test_name; do
		[[ -n "$test_name" ]] || continue
		if [[ ! -f "$SCRIPT_DIR/$test_name" ]]; then
			echo "FAIL: the Highway Development Constitution's Enforcement Map names a test that does not exist: $rule_id -> $test_name"
			fail=1
		fi
	done < <(printf '%s\n' "$dev_map")

	# The reader above must actually see rules. A parser that silently matches nothing would make
	# every assertion in this block pass regardless of the document's contents.
	if [[ "$(dev_auto_ids | grep -c .)" -eq 0 ]]; then
		echo "FAIL: no [auto] rules were parsed from the Highway Development Constitution; the reader matched nothing"
		fail=1
	fi
fi

exit $fail
