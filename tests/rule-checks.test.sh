#!/usr/bin/env bash
# Seeds one deliberate violation per enforced rule and asserts each is detected and reported by
# its own rule id (SC-002), and that the reported line format matches the output contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
VALIDATE="$HW_FRAMEWORK/validate-skill.sh"
fail=0

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

# Writes a conforming skill to $1/SKILL.md. Callers then mutate one section to seed a violation.
# `name` is set to $1's own basename so it satisfies sv_validate_name regardless of which temp
# directory a given case uses.
write_base_skill() {
	local dir="$1" id
	id="$(basename "$dir")"
	mkdir -p "$dir"
	cat >"$dir/SKILL.md" <<'EOF'
---
name: Seed Skill
description: "Conforming baseline that each case mutates to seed exactly one violation. Use when a test seeds one violation."
license: Apache-2.0
metadata:
  version: 1.0.0
  usage: "Not invoked directly; used only as a seed fixture for rule-checks.test.sh."
---

## Purpose
Provide a conforming baseline that each test case mutates.

## When to use
- Use when seeding a violation of one rule.
- Use when confirming the reported rule id.

## When not to use
Never use for real work.

## Inputs
None.

## Outputs
A confirmation message.

## Verification
Confirm the output names the violated rule id.

## Error Handling
- If no rule id is reported, abort and report the missed detection.

## Example
```text
framework/validate-skill.sh <this-dir>
```
EOF
	sed -i.bak "s/^name: .*/name: $id/" "$dir/SKILL.md" && rm -f "$dir/SKILL.md.bak"
}

# assert_reports <case-name> <expected-rule-id> <skill-dir>
assert_reports() {
	local name="$1" rule="$2" dir="$3" out rc
	out="$("$VALIDATE" "$dir" 2>&1)"
	rc=$?
	if [[ $rc -eq 0 ]]; then
		echo "FAIL[$name]: expected non-zero exit for a seeded $rule violation"
		fail=1
		return
	fi
	if [[ "$out" != *"ERROR: [$rule]"* ]]; then
		echo "FAIL[$name]: expected a finding tagged [$rule]. Got:"
		printf '%s\n' "$out" | grep '^ERROR:' | sed 's/^/    /'
		fail=1
		return
	fi
	if [[ "$out" != *"FAILED:"*"$rule"* ]]; then
		echo "FAIL[$name]: rule $rule was not listed in the FAILED coverage group"
		fail=1
	fi
}

# --- P7.1: Purpose section absent -------------------------------------------------------------

d="$tmp_root/p71-missing"; write_base_skill "$d"
sed -i.bak '/^## Purpose$/,/^$/d' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P7.1 missing section" "P7.1" "$d"

# --- P7.1: Purpose section holds more than one sentence ----------------------------------------

d="$tmp_root/p71-two-sentences"; write_base_skill "$d"
sed -i.bak 's/^Provide a conforming baseline that each test case mutates\.$/First sentence. Second sentence./' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P7.1 two sentences" "P7.1" "$d"

# --- P1.1: a normative line carrying two keywords ------------------------------------------------

d="$tmp_root/p11"; write_base_skill "$d"
printf '\n## Rules\nThe agent MUST retry twice and SHOULD escalate after 3 attempts.\n' >>"$d/SKILL.md"
assert_reports "P1.1 two keywords" "P1.1" "$d"

# --- P1.3: a normative line longer than 25 words ---------------------------------------------------

d="$tmp_root/p13"; write_base_skill "$d"
printf '\n## Rules\nThe agent MUST do this thing and that thing and the other thing and one more thing and still another thing and yet one final additional thing here.\n' >>"$d/SKILL.md"
assert_reports "P1.3 over 25 words" "P1.3" "$d"

# --- P7.2: version missing ---------------------------------------------------------------------------

d="$tmp_root/p72"; write_base_skill "$d"
sed -i.bak '/^  version: 1\.0\.0$/d' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P7.2 missing version" "P7.2" "$d"

# --- P5.15: description without a "Use when" sentence ---------------------------------------------

d="$tmp_root/p515"; write_base_skill "$d"
sed -i.bak 's/ Use when a test seeds one violation\."$/"/' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P5.15 no Use when" "P5.15" "$d"

# --- P7.4: more than 12 MUST-level rules ---------------------------------------------------------------

d="$tmp_root/p74"; write_base_skill "$d"
{
	printf '\n## Rules\n'
	i=1
	while [[ $i -le 13 ]]; do
		printf 'The agent MUST perform check number %d.\n' "$i"
		i=$((i + 1))
	done
} >>"$d/SKILL.md"
assert_reports "P7.4 too many MUST rules" "P7.4" "$d"

# --- P4.2: an unmeasurable quality claim in Verification -------------------------------------------------

d="$tmp_root/p42"; write_base_skill "$d"
sed -i.bak 's/^Confirm the output names the violated rule id\.$/Confirm the result is secure./' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P4.2 quality claim" "P4.2" "$d"

# Superseded behavior: seeded "P5.2", "P5.3", and "P8.1" violations were expected to exit
# non-zero. Those rules were retired as current rows, so the same fixtures are not violations.

d="$tmp_root/p52"; write_base_skill "$d"
sed -i.bak 's/^- If no rule id is reported, abort and report the missed detection\.$/- If no rule id is reported, do something sensible./' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
if "$VALIDATE" "$d" 2>&1 | grep -q '\[P5.2\]'; then
	echo "FAIL: retired P5.2 is still reported"
	fail=1
fi

d="$tmp_root/p53"; write_base_skill "$d"
sed -i.bak 's/^- If no rule id is reported, abort and report the missed detection\.$/- If no rule id is reported, retry the validation step./' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
if "$VALIDATE" "$d" 2>&1 | grep -q '\[P5.3\]'; then
	echo "FAIL: retired P5.3 is still reported"
	fail=1
fi

d="$tmp_root/p81"; write_base_skill "$d"
printf '\n## Steps\n1. first step\n3. second step\n' >>"$d/SKILL.md"
if "$VALIDATE" "$d" 2>&1 | grep -q '\[P8.1\]'; then
	echo "FAIL: retired P8.1 is still reported"
	fail=1
fi

# --- P3.5: a citation outside the approved range -----------------------------------------------------------------

d="$tmp_root/p35"; write_base_skill "$d"
printf '\n## Rules\nThe agent MUST validate input [AS-9: made up source].\n' >>"$d/SKILL.md"
assert_reports "P3.5 unapproved citation" "P3.5" "$d"

# --- P8.3: Verification section absent ------------------------------------------------------------------------------

d="$tmp_root/p83"; write_base_skill "$d"
sed -i.bak '/^## Verification$/,/^$/d' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P8.3 missing verification" "P8.3" "$d"

# --- P7.5: a normative section longer than 400 words --------------------------------------------------------------------

d="$tmp_root/p75"; write_base_skill "$d"
{
	printf '\n## Rules\nThe agent MUST perform the documented check.\n'
	i=1
	while [[ $i -le 420 ]]; do
		printf 'word '
		i=$((i + 1))
	done
	printf '\n'
} >>"$d/SKILL.md"
assert_reports "P7.5 oversized section" "P7.5" "$d"

# --- P8.7: a Markdown link target that is a relative path ------------------------------------

d="$tmp_root/p87"; write_base_skill "$d"
printf '\nSee [the standard](../governance/constitution.md) for detail.\n' >>"$d/SKILL.md"
assert_reports "P8.7 relative link target" "P8.7" "$d"

# A path in inline code is not a link and must not be flagged.
d="$tmp_root/p87-ok"; write_base_skill "$d"
printf '\nRead `references/storage-contract.md` and [the site](https://example.org).\n' >>"$d/SKILL.md"
if ! "$VALIDATE" "$d" >/dev/null 2>&1; then
	echo "FAIL[P8.7 false positive]: a command example or absolute URL was reported as a relative link"
	fail=1
fi

# --- P6.4: a decision criterion that depends on when it is read, on chance, or on taste ---------

d="$tmp_root/p64"; write_base_skill "$d"
sed -i.bak 's|^- Use when seeding a violation of one rule\.$|- Use when the catalog is currently stale.|' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P6.4 nondeterministic decision criterion" "P6.4" "$d"

# --- P9.1: a file output without a shared complete template ---------------------------------

d="$tmp_root/p91"; write_base_skill "$d"
sed -i.bak 's/^A confirmation message\.$/A file at library\/governance\/example.md./' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P9.1 uncited file output" "P9.1" "$d"

# A template outside the skill's own assets/ does not satisfy the rule.
d="$tmp_root/p91-shared"; write_base_skill "$d"
sed -i.bak 's/^A confirmation message\.$/A file at library\/governance\/example.md following `shared\/templates\/example-record.md`./' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P9.1 shared-folder citation" "P9.1" "$d"

# The rule governs decision criteria, not prose. The same token outside the sections that state
# when a skill applies must not be flagged, or every skill describing its own output fails.
d="$tmp_root/p64-ok"; write_base_skill "$d"
sed -i.bak 's|^Provide a conforming baseline that each test case mutates\.$|Provide a baseline that reports the latest catalog entry and prefers compact output.|' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
if ! "$VALIDATE" "$d" >/dev/null 2>&1; then
	echo "FAIL[P6.4 false positive]: a prohibited token outside a decision-criteria section was reported"
	fail=1
fi

# --- Finding line format matches the contract -----------------------------------------------------------------------------

d="$tmp_root/format"; write_base_skill "$d"
printf '\n## Rules\nThe agent MUST do this thing and that thing and the other thing and one more thing and still another thing and yet one final additional thing here.\n' >>"$d/SKILL.md"
line="$("$VALIDATE" "$d" 2>&1 | grep '^ERROR: \[P1.3\]' | head -1)"
if [[ ! "$line" =~ ^ERROR:\ \[P1\.3\]\ .*\(.*\)$ ]]; then
	echo "FAIL[format]: finding line does not match 'ERROR: [RULE-ID] message (observable)'. Got: $line"
	fail=1
fi
if [[ "$line" != *" 25"* ]]; then
	echo "FAIL[format]: threshold finding does not report the limit. Got: $line"
	fail=1
fi

# --- A not-applicable outcome names its condition and does not fail the run ------------------------------------------------

d="$tmp_root/na"; write_base_skill "$d"
out="$("$VALIDATE" "$d" 2>/dev/null)"
if ! "$VALIDATE" "$d" >/dev/null 2>&1; then
	echo "FAIL[na]: a skill with not-applicable rules exited non-zero"
	fail=1
fi
na_line="$(printf '%s\n' "$out" | grep '^N/A:' | sed 's/^N\/A: *//')"
if [[ -z "$na_line" ]]; then
	echo "FAIL[na]: expected at least one not-applicable rule for a skill with no citations"
	fail=1
else
	for entry in $na_line; do
		if [[ ! "$entry" =~ ^[PX][0-9]+\.[0-9]+=N[0-9]+$ ]]; then
			echo "FAIL[na]: not-applicable entry '$entry' does not name a permitted condition"
			fail=1
		fi
	done
fi

# Superseded behavior: the specimen check reported under "X1.4".
d="$tmp_root/p95"; write_base_skill "$d"
printf '\n## Example\nVersion: 9.9.9\n' >>"$d/SKILL.md"
assert_reports "P9.5 specimen disagrees" "P9.5" "$d"

d="$tmp_root/p26"; write_base_skill "$d"
printf '\n## Notes\nCommit the result with `git commit`.\n' >>"$d/SKILL.md"
assert_reports "P2.6 git command" "P2.6" "$d"

# --- Principle XIV: the flow pattern ----------------------------------------------------------------
# Each of the twelve Phase 13 boundaries is seeded into a fresh copy of the flow-skill fixture, which
# has flow files, and must fail exactly the rule that holds it. Each rule is also seeded into the base
# skill, which has no references/. These run with the cache off: they prove the rules, and
# validation-cache.test.sh proves the cache.

FLOW_FIXTURE="$HW_FIXTURES/flow-skill"

# assert_p14 <case-name> <rule> <skill-dir> <exact|includes>
# exact: the FAILED coverage group is that rule alone. includes: it is among those failed.
assert_p14() {
	local name="$1" rule="$2" dir="$3" mode="$4" out rc failed
	out="$("$VALIDATE" --no-cache "$dir" 2>&1)"
	rc=$?
	failed="$(printf '%s\n' "$out" | sed -n 's/^FAILED:    //p')"
	if [[ $rc -eq 0 || "$out" != *"ERROR: [$rule]"* ]]; then
		echo "FAIL[$name]: expected a finding tagged [$rule]. Got:"
		printf '%s\n' "$out" | grep '^ERROR:' | sed 's/^/    /'
		fail=1
		return
	fi
	if [[ "$mode" == "exact" && "$failed" != "$rule" ]]; then
		echo "FAIL[$name]: expected only $rule to fail; FAILED lists: $failed"
		fail=1
	elif [[ " $failed " != *" $rule "* ]]; then
		echo "FAIL[$name]: rule $rule was not listed in the FAILED coverage group"
		fail=1
	fi
}

# assert_p14_pass <case-name> <skill-dir>: valid, with every Principle XIV rule checked.
assert_p14_pass() {
	local name="$1" dir="$2" out rule
	if ! out="$("$VALIDATE" --no-cache "$dir" 2>&1)"; then
		echo "FAIL[$name]: expected the unseeded copy to pass. Got:"
		printf '%s\n' "$out" | grep '^ERROR:' | sed 's/^/    /'
		fail=1
		return
	fi
	for rule in P14.1 P14.2 P14.3 P14.4; do
		if [[ " $(printf '%s\n' "$out" | sed -n 's/^CHECKED:   //p') " != *" $rule "* ]]; then
			echo "FAIL[$name]: $rule is not listed under CHECKED"
			fail=1
		fi
	done
}

# Copies the fixture and applies boundary seed <n>; prints the copy's folder. Seed 0 is unseeded.
p14_seed_copy() {
	local n="$1" copy="$tmp_root/p14-seed-$1/flow-skill"
	mkdir -p "$(dirname "$copy")"
	cp -R "$FLOW_FIXTURE" "$copy"
	case "$n" in
		1) awk 'NR == 2 { for (i = 0; i < 500; i++) print "Padding line." } { print }' "$copy/references/proposal.md" > "$copy/p" && mv "$copy/p" "$copy/references/proposal.md" ;;
		2) mkdir -p "$copy/references/sub" && mv "$copy/references/record.md" "$copy/references/sub/record.md" \
			&& sed 's#`references/record.md`#`references/sub/record.md`#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		3) grep -v '^$' "$copy/references/record.md" > "$copy/r" && mv "$copy/r" "$copy/references/record.md" ;;
		4) awk '/^## Verification/ { print "## Notes"; print ""; print "A note."; print "" } { print }' "$copy/references/record.md" > "$copy/r" && mv "$copy/r" "$copy/references/record.md" ;;
		5) awk '/^### close/ { print "### write"; print ""; print "Write again."; print "" } { print }' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		6) awk '/^### start/ { print "### Classify"; print ""; print "Classify again."; print "" } { print }' "$copy/references/proposal.md" > "$copy/p" && mv "$copy/p" "$copy/references/proposal.md" \
			&& awk '/^### Classify/ { skip = 1; next } skip && /^### / { skip = 0 } !skip' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" \
			&& sed 's#| `start`, `revise` |#| `Classify`, `start`, `revise` |#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" \
			&& sed 's#Go to `Classify`.#Go to `start`.#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		7) sed 's#| `start`, `revise` |#| `revise`, `start` |#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		8) sed 's#^Confirm the record and stop.#Confirm `references/record.md` and stop.#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		9) awk '/^## Verification/ { print "See `references/proposal.md`."; print "" } { print }' "$copy/references/record.md" > "$copy/r" && mv "$copy/r" "$copy/references/record.md" ;;
		10) sed 's#^Confirm the record and stop.#Confirm the record, then go to `nowhere`.#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		11) sed 's#^Confirm the record and stop.#Confirm the record, then follow `nowhere` in `highway-adr`.#' "$copy/SKILL.md" > "$copy/s" && mv "$copy/s" "$copy/SKILL.md" ;;
		12) sed 's#^3. Return to `close`.#3. Go to `revise`.#' "$copy/references/record.md" > "$copy/r" && mv "$copy/r" "$copy/references/record.md" ;;
	esac
	echo "$copy"
}

# Inserts the lines of $2 before `## Verification` in the base skill at $1. The text travels through
# the environment because awk -v rejects a value holding a newline.
p14_insert_before_verification() {
	P14_TEXT="$2" awk '/^## Verification$/ { print ENVIRON["P14_TEXT"]; print "" } { print }' "$1/SKILL.md" > "$1/s" \
		&& mv "$1/s" "$1/SKILL.md"
}

assert_p14_pass "P14 unseeded skill with flow files" "$(p14_seed_copy 0)"
d="$tmp_root/p14-base"; write_base_skill "$d"
assert_p14_pass "P14 unseeded skill without references" "$d"

for n in 1 2 3 4 5 6 7 8 9 10 11 12; do
	case "$n" in
		1) rule="P14.1" ;;
		2 | 3 | 4) rule="P14.2" ;;
		5 | 6 | 7 | 8) rule="P14.3" ;;
		*) rule="P14.4" ;;
	esac
	assert_p14 "P14 boundary $n" "$rule" "$(p14_seed_copy "$n")" exact
done

d="$tmp_root/p14-1"; write_base_skill "$d"
awk '{ print } /^None\.$/ && !done { for (i = 0; i < 500; i++) print "Padding line."; done = 1 }' "$d/SKILL.md" > "$d/s" && mv "$d/s" "$d/SKILL.md"
assert_p14 "P14.1 without references" "P14.1" "$d" includes

d="$tmp_root/p14-2"; write_base_skill "$d"
p14_insert_before_verification "$d" "## Procedure

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| \`references/sub/flow.md\` | \`start\` |"
assert_p14 "P14.2 without references" "P14.2" "$d" includes

d="$tmp_root/p14-3"; write_base_skill "$d"
p14_insert_before_verification "$d" "## Procedure

| File | Steps |
| --- | --- |
| \`references/flow.md\` | \`start\` |"
assert_p14 "P14.3 without references" "P14.3" "$d" includes

d="$tmp_root/p14-4"; write_base_skill "$d"
p14_insert_before_verification "$d" "## Procedure

### Entry

Go to \`nowhere\`."
assert_p14 "P14.4 without references" "P14.4" "$d" includes

# --- Every enforced rule has a seeded case above ------------------------------------------------------------------------------

# shellcheck source=../lib/rule-checks.sh
source "$HW_LIB/rule-checks.sh"
for rule in $(rc_registered_ids); do
	if ! grep -q "\"$rule\"" "${BASH_SOURCE[0]}"; then
		echo "FAIL: rule $rule is registered as enforced but has no seeded violation case in this test"
		fail=1
	fi
done

# Experience rows intentionally carry no development/test tier column. Their parsed classification
# is the internal "runtime" category owned by constitution.sh.
EXPERIENCE="$(hw_doc experience-standard)"

for rule in X2.1 X2.3 X2.4 X2.5 X2.6; do
	if ! grep -qE "^\| $rule \|[^|]+\|[^|]+\|$" "$EXPERIENCE"; then
		echo "FAIL: $rule is missing or malformed"
		fail=1
	fi
done
if ! grep -qF '| X2.13 | An Interactive Workflow MUST reuse relevant accepted information and available evidence, and MUST contribute a grounded interpretation' "$EXPERIENCE"; then
	echo "FAIL: X2.13 does not reuse accepted information or contribute grounded reasoning before a question"
	fail=1
fi
if ! grep -qF 'Responses exclude identifiers, catalog mutations, generated versions, internal state, and owner mechanics unless needed.' "$EXPERIENCE"; then
	echo "FAIL: X2.3 observable sentence is missing"
	fail=1
fi
if ! grep -qF '| X2.4 | An Interactive Workflow MUST ask only for consequential, result-changing uncertainty that the person owns and that accepted evidence or responsible advisory reasoning cannot resolve.' "$EXPERIENCE"; then
	echo "FAIL: X2.4 does not limit the question to information still needed"
	fail=1
fi
if ! grep -qF '| X2.5 | Progress MUST appear only when remaining work is meaningful to the person.' "$EXPERIENCE" || \
	! grep -qF '| X2.6 | Progress MUST describe the activity rather than an internal stage, validation, route, or implementation step.' "$EXPERIENCE"; then
	echo "FAIL: X2.5/X2.6 do not describe meaningful activity"
	fail=1
fi
if grep -qF '| ID | Rule | Observable | Tier | Sample |' "$EXPERIENCE"; then
	echo "FAIL: superseded Sample column is still a current rule-table header"
	fail=1
fi

exit $fail
