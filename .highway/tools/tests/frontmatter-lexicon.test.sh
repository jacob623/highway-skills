#!/usr/bin/env bash
# Tests lib/frontmatter-lexicon.sh: lexicon shape, individual unrecognized-word reporting via
# validate-skill.sh, and identifier-resolution acceptance paths (rule id, skill id). Per
# feature 045 (frontmatter contract hardening).
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-skill.sh"
FIXTURES="$SCRIPT_DIR/fixtures"

# shellcheck source=tools/lib/constitution.sh
source "$HIGHWAY_ROOT/tools/lib/constitution.sh"
# shellcheck source=tools/lib/frontmatter-lexicon.sh
source "$HIGHWAY_ROOT/tools/lib/frontmatter-lexicon.sh"

fail=0

# --- Lexicon shape: one lowercase alphanumeric/hyphen word per line, sorted, no duplicates ------

if ! fl_validate_lexicon "$HIGHWAY_ROOT"; then
	echo "FAIL: the frontmatter lexicon is malformed"
	fail=1
fi

lexicon_file="$(fl_file "$HIGHWAY_ROOT")"
if [[ ! -s "$lexicon_file" ]]; then
	echo "FAIL: the frontmatter lexicon is empty or missing at $lexicon_file"
	fail=1
fi

# --- Individual reporting: a nonexistent skill id is named individually, not just counted -------

out="$("$VALIDATE" "$FIXTURES/invalid-skill-unrecognized-word" 2>&1)"
if [[ "$out" != *"unrecognized word 'nfrz'"* ]]; then
	echo "FAIL: expected the unrecognized-word fixture to name 'nfrz' individually. Got: $out"
	fail=1
fi

# --- Skill-id resolution: an existing skill id in a field is accepted, not flagged --------------

if ! fl_check_field "$HIGHWAY_ROOT" "test" "highway-help"; then
	echo "FAIL: an existing skill id ('highway-help') was not accepted"
	fail=1
fi

if fl_check_field "$HIGHWAY_ROOT" "test" "highway-nfrz" >/dev/null; then
	echo "FAIL: a nonexistent skill id ('highway-nfrz') was incorrectly accepted"
	fail=1
fi

# --- Rule-id resolution: P- and X-prefixed rule ids that exist are accepted ----------------------

if ! fl_check_field "$HIGHWAY_ROOT" "test" "P6.4"; then
	echo "FAIL: an existing P-prefixed rule id (P6.4) was not accepted"
	fail=1
fi

if ! fl_check_field "$HIGHWAY_ROOT" "test" "X1.4"; then
	echo "FAIL: an existing X-prefixed rule id (X1.4) was not accepted"
	fail=1
fi

# --- D-prefixed (development-only) rule ids are never resolved, per D1.1 -------------------------
# A shipped artifact (this lexicon checker ships under .highway/tools/) MUST NOT reference a
# development-only location, so a D-prefixed token is treated like any other unrecognized word
# rather than being resolved as a rule id.

if fl_resolve_rule_id "$HIGHWAY_ROOT" "D1.1"; then
	echo "FAIL: a D-prefixed rule id resolved, but D-rules live only in the (non-shipped) dev constitution"
	fail=1
fi

# --- Pattern operands are matched literally, not expanded ---------------------------------------
# Membership is a substring test against an in-memory blob. If the operand were left unquoted, a
# value of '*' would be treated as a pattern and match anything, so every unrecognized word would
# be silently accepted and this checker would report nothing, ever. That failure is invisible in
# ordinary use, so it is asserted directly.

for fl_probe in '*' '?' '[a-z]'; do
	if fl_word_in_lexicon "$HIGHWAY_ROOT" "$fl_probe"; then
		echo "FAIL: the pattern '$fl_probe' was accepted as a lexicon word; the match operand is being expanded"
		fail=1
	fi
	if fl_resolve_rule_id "$HIGHWAY_ROOT" "$fl_probe"; then
		echo "FAIL: the pattern '$fl_probe' resolved as a rule id; the match operand is being expanded"
		fail=1
	fi
done

# --- The per-word path does not spawn a process per word ----------------------------------------
# Asserted by cost rather than by reading the source, because the source can be rewritten while
# still passing a text search. A field of 400 unrecognized words costs well under a second when
# membership is answered from memory; an implementation that runs a matcher per word takes several
# seconds. The threshold is loose on purpose -- this is a guard against reintroducing per-word
# process creation, not a benchmark, and it must not fail merely because a machine is busy.

fl_many=""
for ((fl_i = 0; fl_i < 400; fl_i++)); do
	fl_many="$fl_many zzqqx$fl_i"
done

fl_started=$SECONDS
fl_check_field "$HIGHWAY_ROOT" "test" "$fl_many" >/dev/null
fl_elapsed=$((SECONDS - fl_started))

if [[ $fl_elapsed -gt 3 ]]; then
	echo "FAIL: checking 400 words took ${fl_elapsed}s; the per-word path appears to spawn a process per word"
	fail=1
fi

# The cost assertion above would also pass if the checker silently accepted everything, so confirm
# it still reports each unrecognized word.
fl_reported="$(fl_check_field "$HIGHWAY_ROOT" "test" "zzqqx1 zzqqx2" 2>&1)"
if [[ "$fl_reported" != *"unrecognized word 'zzqqx1'"* || "$fl_reported" != *"unrecognized word 'zzqqx2'"* ]]; then
	echo "FAIL: expected both unrecognized words to be reported individually. Got: $fl_reported"
	fail=1
fi

exit $fail
