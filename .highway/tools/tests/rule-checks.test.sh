#!/usr/bin/env bash
# Seeds one deliberate violation per enforced rule and asserts each is detected and reported by
# its own rule id (SC-002), and that the reported line format matches the output contract.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-skill.sh"
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
description: "Conforming baseline that each case mutates to seed exactly one violation."
usage: "Not invoked directly; used only as a seed fixture for rule-checks.test.sh."
compatibility: all
metadata:
  version: 1.0.0
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
.highway/tools/validate-skill.sh <this-dir>
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
sed -i.bak 's/^  version: 1\.0\.0$/  license: none/' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P7.2 missing version" "P7.2" "$d"

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

# --- P5.2: an Error Handling item naming no permitted next action -------------------------------------------

d="$tmp_root/p52"; write_base_skill "$d"
sed -i.bak 's/^- If no rule id is reported, abort and report the missed detection\.$/- If no rule id is reported, do something sensible./' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P5.2 no next action" "P5.2" "$d"

# --- P5.3: a retry with no attempt count -------------------------------------------------------------------

d="$tmp_root/p53"; write_base_skill "$d"
sed -i.bak 's/^- If no rule id is reported, abort and report the missed detection\.$/- If no rule id is reported, retry the validation step./' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P5.3 retry without count" "P5.3" "$d"

# --- P8.1: an ordered list that is not sequentially numbered ---------------------------------------------------

d="$tmp_root/p81"; write_base_skill "$d"
printf '\n## Steps\n1. first step\n3. second step\n' >>"$d/SKILL.md"
assert_reports "P8.1 non-sequential steps" "P8.1" "$d"

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

# A command example naming a path is not a link and must not be flagged.
d="$tmp_root/p87-ok"; write_base_skill "$d"
printf '\nRun `.highway/tools/validate-skill.sh <dir>` and read [the site](https://example.org).\n' >>"$d/SKILL.md"
if ! "$VALIDATE" "$d" >/dev/null 2>&1; then
	echo "FAIL[P8.7 false positive]: a command example or absolute URL was reported as a relative link"
	fail=1
fi

# --- P6.4: a decision criterion that depends on when it is read, on chance, or on taste ---------

d="$tmp_root/p64"; write_base_skill "$d"
sed -i.bak 's|^- Use when seeding a violation of one rule\.$|- Use when the catalog is currently stale.|' "$d/SKILL.md" && rm -f "$d/SKILL.md.bak"
assert_reports "P6.4 nondeterministic decision criterion" "P6.4" "$d"

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
		if [[ ! "$entry" =~ ^P[0-9]+\.[0-9]+=N[0-9]+$ ]]; then
			echo "FAIL[na]: not-applicable entry '$entry' does not name a permitted condition"
			fail=1
		fi
	done
fi

# --- Every enforced rule has a seeded case above ------------------------------------------------------------------------------

# shellcheck source=tools/lib/rule-checks.sh
source "$HIGHWAY_ROOT/tools/lib/rule-checks.sh"
for rule in $(rc_registered_ids); do
	if ! grep -q "\"$rule\"" "${BASH_SOURCE[0]}"; then
		echo "FAIL: rule $rule is registered as enforced but has no seeded violation case in this test"
		fail=1
	fi
done

exit $fail
