#!/usr/bin/env bash
# Tests the coverage summary contract: every constitution rule id appears in exactly one group,
# empty groups are printed rather than omitted, and unverified rules never fail the run.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# shellcheck source=tools/lib/constitution.sh
source "$HIGHWAY_ROOT/tools/lib/constitution.sh"

VALIDATE="$HIGHWAY_ROOT/tools/validate-skill.sh"
FIXTURES="$SCRIPT_DIR/fixtures"
CONSTITUTION="$HIGHWAY_ROOT/governance/constitution.md"
EXPERIENCE="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

output="$("$VALIDATE" "$FIXTURES/valid-skill" 2>/dev/null)"

# --- All five groups are present, even when empty --------------------------------------------

for group in CHECKED FAILED "N/A" DEFERRED UNCHECKED; do
	if ! printf '%s\n' "$output" | grep -q "^${group}:"; then
		echo "FAIL: coverage group '$group' was omitted from the output"
		fail=1
	fi
done

# FAILED is empty for a valid skill and must still be printed.
if ! printf '%s\n' "$output" | grep -qE '^FAILED: *$'; then
	echo "FAIL: the empty FAILED group was not printed as an empty group"
	fail=1
fi

# --- Every rule id appears exactly once across all groups --------------------------------------

reported="$(printf '%s\n' "$output" \
	| grep -E '^(CHECKED|FAILED|N/A|DEFERRED|UNCHECKED):' \
	| sed -E 's/^[A-Z/]+: *//' \
	| tr ' ' '\n' \
	| sed 's/=.*$//' \
	| grep -v '^$' \
	| sort)"

# A skill is judged against both shipping governance documents, so both contribute rule ids.
expected="$( { con_rule_ids "$CONSTITUTION"; [[ -f "$EXPERIENCE" ]] && con_rule_ids "$EXPERIENCE"; } | sort)"

reported_count="$(printf '%s\n' "$reported" | grep -c . | tr -d ' ')"
expected_count="$(printf '%s\n' "$expected" | grep -c . | tr -d ' ')"

# A namespace mismatch would leave one document contributing nothing while the count still
# matched by coincidence, so assert each document was actually read.
for doc in "$CONSTITUTION" "$EXPERIENCE"; do
	[[ -f "$doc" ]] || continue
	if [[ "$(con_rule_ids "$doc" | grep -c .)" -eq 0 ]]; then
		echo "FAIL: no rules were read from $doc; the reader matched nothing"
		fail=1
	fi
done

if [[ "$reported_count" != "$expected_count" ]]; then
	echo "FAIL: output reports $reported_count rule ids, the governance documents define $expected_count"
	fail=1
fi

dupes="$(printf '%s\n' "$reported" | uniq -d)"
if [[ -n "$dupes" ]]; then
	echo "FAIL: these rule ids appear in more than one group: $dupes"
	fail=1
fi

missing="$(comm -23 <(printf '%s\n' "$expected") <(printf '%s\n' "$reported"))"
if [[ -n "$missing" ]]; then
	echo "FAIL: these rule ids are missing from the output entirely: $missing"
	fail=1
fi

# --- Not-applicable entries name a permitted condition -------------------------------------------

na_line="$(printf '%s\n' "$output" | grep '^N/A:' | sed 's/^N\/A: *//')"
if [[ -n "$na_line" ]]; then
	for entry in $na_line; do
		if [[ "$entry" != *"="* ]]; then
			echo "FAIL: not-applicable entry '$entry' names no condition"
			fail=1
		elif [[ ! "${entry#*=}" =~ ^N[0-9]+$ ]]; then
			echo "FAIL: not-applicable entry '$entry' does not name a permitted condition id"
			fail=1
		fi
	done
fi

# --- Deferred and unchecked rules do not fail the run ---------------------------------------------

if ! "$VALIDATE" "$FIXTURES/valid-skill" >/dev/null 2>&1; then
	echo "FAIL: a valid skill exited non-zero despite deferred and unchecked rules being present"
	fail=1
fi

deferred_count="$(printf '%s\n' "$output" | grep '^DEFERRED:' | sed 's/^DEFERRED: *//' | wc -w | tr -d ' ')"
if [[ "$deferred_count" -eq 0 ]]; then
	echo "FAIL: expected some rules to be deferred; none were reported"
	fail=1
fi

# --- The result line reports the counts ------------------------------------------------------------

if ! printf '%s\n' "$output" | grep -qE "^OK: skill 'valid-skill' is valid \([0-9]+ rules checked, [0-9]+ deferred, [0-9]+ unchecked\)$"; then
	echo "FAIL: result line does not match the contract. Got:"
	printf '%s\n' "$output" | tail -1
	fail=1
fi

exit $fail
