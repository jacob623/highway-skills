#!/usr/bin/env bash
# Tests that the rule inventory is parsed from the constitution and that a malformed rule table
# fails loudly rather than silently shrinking the inventory. Also decides D3.7: it is the harness
# that runs every other [auto] check's declared probe and requires the seeded/neutralised pair to
# behave per contracts/probe-mode.md.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document
# Seeded failure probe: --probe <class> seeds a defect and observes detection; --probe <class>
# --neutralise runs the identical path unseeded and requires a clean pass. See the Feature 041
# probe-mode contract.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

# Runs the seeded/neutralised pair for one (rule, test, class) and reports per the contract's
# failure-message table. Shared by the harness loop below and by this file's own probe (T038), so
# the same function decides D3.7 in both normal mode and under a self-probe.
harness_probe_pair() {
	local rule_id="$1" test_name="$2" class="$3"
	local test_path="$SCRIPT_DIR/$test_name"
	local seeded_exit neutral_exit problem=0

	bash "$test_path" --probe "$class" >/dev/null 2>&1
	seeded_exit=$?
	bash "$test_path" --probe "$class" --neutralise >/dev/null 2>&1
	neutral_exit=$?

	if [[ "$seeded_exit" -eq 2 ]] || [[ "$neutral_exit" -eq 2 ]]; then
		echo "FAIL: $rule_id test probes a class it does not declare: $test_name -> $class"
		problem=1
	elif [[ "$seeded_exit" -eq 0 ]]; then
		echo "FAIL: $rule_id probe for $class did not fail on a seeded defect: $test_name"
		problem=1
	elif [[ "$neutral_exit" -ne 0 ]]; then
		echo "FAIL: $rule_id probe for $class fails without a seeded defect: $test_name"
		problem=1
	fi
	return $problem
}

# For each "<rule id><TAB><test filename>" row in $1: reads the test's declared artifact classes
# and exercises each with harness_probe_pair. Fails if any pair misbehaves, or if zero pairs were
# exercised at all (a map with no rows, or rows whose tests declare no classes, must not pass
# silently).
#
# A test file mapped by more than one rule (e.g. distribution-packaging.test.sh names both D1.2
# and D4.3) is probed once, not once per row: the probe proves the same property -- that the test
# can fail for each declared class -- regardless of which rule id sent it. Re-running it per row
# is pure duplicate work against the 180s runtime budget (research: Phase 5 (US2) resolution).
# Each unique test file's classes are still counted toward the zero-pairs assertion exactly once.
harness_run() {
	local map_text="$1"
	local rule_id test_name test_path classes class pairs=0 problems=0
	local seen=""
	while IFS=$'\t' read -r rule_id test_name; do
		[[ -n "$rule_id" ]] || continue
		[[ "$seen" == *" $test_name "* ]] && continue
		seen="$seen $test_name "
		test_path="$SCRIPT_DIR/$test_name"
		[[ -f "$test_path" ]] || continue
		classes="$(grep '^# Artifact classes:' "$test_path" | head -1 \
			| sed -e 's/^# Artifact classes:[[:space:]]*//' -e 's/,/ /g')"
		if [[ -z "$classes" ]]; then
			echo "FAIL: $rule_id test does not implement probe mode: $test_name"
			problems=1
			continue
		fi
		for class in $classes; do
			harness_probe_pair "$rule_id" "$test_name" "$class" || problems=1
			pairs=$((pairs + 1))
		done
	done <<<"$map_text"
	if [[ "$pairs" -eq 0 ]]; then
		echo "FAIL: no rule/class pairs were exercised; the harness matched nothing"
		problems=1
	fi
	return $problems
}

# --- Probe mode: returns here, before the harness loop further down (T037). Without this guard,
# the harness loop's own row for D3.7 would invoke this file with --probe and recurse without
# bound; the recursive invocation instead takes this branch and exits immediately. ---
#
# Seeds by breaking a real mapped test's declared probe and requires harness_probe_pair (the same
# function the harness loop below uses) to catch it. This is a source-document probe: the artifact
# perturbed is another test's own source file, not a copy.
#
# harness_probe_pair has three ways of reporting, and a leg that seeds only one defect proves only
# the branch that defect happens to reach. Until Feature 042 this leg seeded a probe that always
# fails, which reaches the neutral_exit branch; the seeded_exit branch -- the one that catches a
# probe unable to detect its own seeded defect, which is the whole point of D3.7 -- could be
# deleted with this suite still reporting green. Each branch is now seeded separately and all
# three must report, so removing any one of them makes this leg exit 0.
if [[ -n "$probe_class" ]]; then
	case "$probe_class" in
		source-document)
			TARGET="$SCRIPT_DIR/generate-catalog.test.sh"
			BACKUP="$(mktemp)"
			cp "$TARGET" "$BACKUP"
			trap 'cp "$BACKUP" "$TARGET"; rm -f "$BACKUP"' EXIT
			if [[ "$neutralise" -eq 1 ]]; then
				if harness_probe_pair "D4.2" "generate-catalog.test.sh" "generated-artifact" >/dev/null 2>&1; then
					exit 0
				fi
				exit 1
			fi
			undetected=0
			# A probe that cannot fail on its own seeded defect. Only the seeded_exit branch reports this.
			sed 's/^probe_generated_artifact() {/probe_generated_artifact() { return 0;/' "$BACKUP" >"$TARGET"
			harness_probe_pair "D4.2" "generate-catalog.test.sh" "generated-artifact" >/dev/null 2>&1 && undetected=1
			# A probe that fails with nothing seeded. Only the neutral_exit branch reports this.
			sed 's/^probe_generated_artifact() {/probe_generated_artifact() { return 1;/' "$BACKUP" >"$TARGET"
			harness_probe_pair "D4.2" "generate-catalog.test.sh" "generated-artifact" >/dev/null 2>&1 && undetected=1
			# A class the test does not declare. Only the exit-2 branch reports this.
			cp "$BACKUP" "$TARGET"
			harness_probe_pair "D4.2" "generate-catalog.test.sh" "undeclared-probe-class-$$" >/dev/null 2>&1 && undetected=1
			if [[ "$undetected" -eq 0 ]]; then
				exit 1
			fi
			exit 0
			;;
	esac
fi

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

# The same assertion for the Experience Standard. It shares the P-side definition of [auto] --
# a registered check reporting under the rule id -- because both documents are read by the same
# validator against the same artifact.
EXPERIENCE="$HIGHWAY_ROOT/governance/experience-standard.md"
if [[ -f "$EXPERIENCE" ]]; then
	experience_rule_count="$(con_rule_ids "$EXPERIENCE" | grep -c .)"
	if [[ "$experience_rule_count" -eq 0 ]]; then
		echo "FAIL: no rules were read from the Experience Standard; the reader matched nothing"
		fail=1
	fi

	x_unenforced=""
	while IFS= read -r rule_id; do
		[[ -n "$rule_id" ]] || continue
		if ! printf '%s\n' "$registered" | grep -qx "$rule_id"; then
			x_unenforced="$x_unenforced $rule_id"
		fi
	done < <(con_rule_ids_by_tier "$EXPERIENCE" auto)

	if [[ -n "$x_unenforced" ]]; then
		echo "FAIL: the Highway Experience Standard tags these rules [auto] but no check decides them:$x_unenforced"
		fail=1
	fi
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

	# harness_probe_pair is what D3.7 reduces to, and it cannot prove all of itself through the
	# probe channel. A probe leg reports a defect by exiting 0, and it is harness_probe_pair's own
	# seeded_exit branch that turns that exit 0 into a failure -- so removing that branch silences
	# the very report that would have announced its absence. Measured in Feature 042: with the
	# seeded_exit branch deleted the whole suite still exited 0. Each of the three reports is
	# therefore asserted here, in normal mode, on the same function the harness loop below calls.
	pair_target="$SCRIPT_DIR/generate-catalog.test.sh"
	pair_backup="$(mktemp)"
	cp "$pair_target" "$pair_backup"
	trap 'cp "$pair_backup" "$pair_target" 2>/dev/null; rm -f "$pair_backup"' EXIT
	# Perturbs a real mapped test's probe in place, requires harness_probe_pair to object *and to
	# say which of the three things went wrong*, and restores before returning. The message is
	# asserted, not just the return code: with the exit-2 branch deleted an undeclared class still
	# reaches the neutral_exit branch, so return code alone leaves that branch unproved -- measured
	# in Feature 042.
	pair_case() {
		local label="$1" injection="$2" class="$3" needle="$4" out=""
		if [[ -n "$injection" ]]; then
			sed "s/^probe_generated_artifact() {/probe_generated_artifact() { $injection/" \
				"$pair_backup" >"$pair_target"
		fi
		out="$(harness_probe_pair "D4.2" "generate-catalog.test.sh" "$class" 2>&1)" && out=""
		cp "$pair_backup" "$pair_target"
		if [[ "$out" != *"$needle"* ]]; then
			echo "FAIL: harness_probe_pair did not report $label"
			fail=1
		fi
	}
	pair_case "a probe that cannot fail on its own seeded defect" "return 0;" "generated-artifact" \
		"did not fail on a seeded defect"
	pair_case "a probe that fails with nothing seeded" "return 1;" "generated-artifact" \
		"fails without a seeded defect"
	pair_case "a class the test does not declare" "" "undeclared-probe-class-$$" \
		"probes a class it does not declare"
	if ! harness_probe_pair "D4.2" "generate-catalog.test.sh" "generated-artifact" >/dev/null 2>&1; then
		echo "FAIL: harness_probe_pair objected to an unperturbed probe"
		fail=1
	fi
	cp "$pair_backup" "$pair_target"
	rm -f "$pair_backup"
	trap - EXIT

	# Executes each mapped test's declared probe, per artifact class, and requires the seeded and
	# neutralised exits the probe-mode contract demands. This is D3.7 itself: a registered [auto]
	# check must be able to fail for every class of artifact in its declared scope.
	if ! harness_run "$dev_map"; then
		fail=1
	fi

	# The reader above must actually see rules. A parser that silently matches nothing would make
	# every assertion in this block pass regardless of the document's contents.
	if [[ "$(dev_auto_ids | grep -c .)" -eq 0 ]]; then
		echo "FAIL: no [auto] rules were parsed from the Highway Development Constitution; the reader matched nothing"
		fail=1
	fi
fi

# D3.8 and D3.7 require test instruments and declared artifact classes to be explicit. Keep this
# structural check here so a newly added test cannot silently escape the repository-wide inventory.
for test_file in "$SCRIPT_DIR"/*.test.sh; do
	if ! grep -q '^# Instrument class:' "$test_file"; then
		echo "FAIL: test does not declare an instrument class: $(basename "$test_file")"
		fail=1
	fi
	if ! grep -q '^# Artifact classes:' "$test_file"; then
		echo "FAIL: test does not declare artifact classes: $(basename "$test_file")"
		fail=1
	fi
done

exit $fail
