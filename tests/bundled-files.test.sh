#!/usr/bin/env bash
# Tests framework/validate-skill.sh against files a skill bundles: each fixture in
# tests/fixtures/bundled-files/ is placed in a temporary skill's assets/ or references/, and the
# skill's verdict must follow the fixture's. Supersedes validate-library.test.sh.
set -u
# Instrument class: executed-behavior
# Artifact classes: disposable-fixture
# Seeded failure probe: each invalid fixture is a seeded defect; the skill holding it must fail
# with exactly one finding, tagged with the rule and naming the bundled file.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
VALIDATE="$HW_FRAMEWORK/validate-skill.sh"
FIXTURES="$HW_FIXTURES/bundled-files"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

fail=0

# make_skill <folder> <fixture>: a valid skill holding only <fixture>, at <folder>/<fixture>. Prints its path.
make_skill() {
	local folder="$1" fixture="$2" id dir
	id="bundled-${fixture%.md}"
	dir="$WORK/$id"
	mkdir -p "$dir/$folder"
	sed "s/^name: .*/name: $id/" "$HW_FIXTURES/valid-skill/SKILL.md" >"$dir/SKILL.md"
	cp "$FIXTURES/$folder/$fixture" "$dir/$folder/$fixture"
	printf '%s\n' "$dir"
}

assert_pass() {
	local folder="$1" fixture="$2" dir out
	dir="$(make_skill "$folder" "$fixture")"
	if ! out="$("$VALIDATE" --no-cache "$dir" 2>&1)"; then
		echo "FAIL: a skill bundling $folder/$fixture failed. Output:"
		printf '%s\n' "$out" | sed 's/^/    /'
		fail=1
	fi
}

assert_single_failure() {
	local folder="$1" fixture="$2" tag="$3" dir out findings count
	dir="$(make_skill "$folder" "$fixture")"
	if out="$("$VALIDATE" --no-cache "$dir" 2>&1)"; then
		echo "FAIL: a skill bundling $folder/$fixture passed; expected [$tag]"
		fail=1
		return
	fi
	findings="$(printf '%s\n' "$out" | grep '^ERROR: ' || true)"
	count="$(printf '%s\n' "$findings" | grep -c '^ERROR: ' | tr -d ' ')"
	if [[ "$count" -ne 1 ]]; then
		echo "FAIL: expected exactly 1 finding for $folder/$fixture, got $count:"
		printf '%s\n' "$findings" | sed 's/^/    /'
		fail=1
		return
	fi
	if [[ "$findings" != "ERROR: [$tag] $folder/$fixture: "* ]]; then
		echo "FAIL: the finding for $folder/$fixture is not tagged [$tag] and named by its path: $findings"
		fail=1
	fi
	if ! printf '%s\n' "$out" | grep -Eq "^FAILED: +.*\b${tag//./\\.}\b"; then
		echo "FAIL: [$tag] from $folder/$fixture is not on the skill's FAILED line"
		fail=1
	fi
}

# Complete templates: the four placeholder-sensitive rules are exempt, so a placeholder MUST passes.
assert_pass assets valid-template.md
assert_single_failure assets invalid-missing-version.md P7.2

# References: citation and body rules apply; frontmatter and rule-shape checks do not, so a
# reference without frontmatter, holding a normative rule, passes.
assert_pass references valid-reference.md
assert_pass references valid-policy.md
assert_single_failure references invalid-bad-citation.md P3.5

# Flow files: a file the flows table names is judged as SKILL.md's instructions are, exempt only
# from P7.1, P7.2, and P8.7. The flow-skill fixture passes with no Purpose or version in its flow
# files; a script named in a flow file fails P2.6, and the same line in a reference the table does
# not name passes.
flow_copy() {
	local dir="$WORK/$1/flow-skill"
	mkdir -p "$WORK/$1"
	cp -R "$HW_FIXTURES/flow-skill" "$dir"
	printf '%s\n' "$dir"
}
SEED='Run `framework/check.sh` before writing.'
dir="$(flow_copy flow-clean)"
if ! out="$("$VALIDATE" --no-cache "$dir" 2>&1)"; then
	echo "FAIL: the flow-skill fixture failed. Output:"
	printf '%s\n' "$out" | sed 's/^/    /'
	fail=1
fi
dir="$(flow_copy flow-seeded)"
printf '\n%s\n' "$SEED" >>"$dir/references/proposal.md"
if out="$("$VALIDATE" --no-cache "$dir" 2>&1)"; then
	echo "FAIL: a script named in a flow file passed; expected [P2.6]"
	fail=1
elif ! printf '%s\n' "$out" | grep -q '^ERROR: \[P2\.6\] references/proposal\.md: '; then
	echo "FAIL: the finding for a script in a flow file is not [P2.6] on references/proposal.md:"
	printf '%s\n' "$out" | grep '^ERROR: ' | sed 's/^/    /'
	fail=1
fi
dir="$(flow_copy flow-reference)"
printf '# Notes\n\n%s\n' "$SEED" >"$dir/references/notes.md"
if ! out="$("$VALIDATE" --no-cache "$dir" 2>&1)"; then
	echo "FAIL: a script named in a reference the flows table does not name failed. Output:"
	printf '%s\n' "$out" | grep '^ERROR: ' | sed 's/^/    /'
	fail=1
fi

# Every shipped skill's bundled files pass.
for skill_dir in "$HW_SKILLS"/*/; do
	if ! out="$("$VALIDATE" --no-cache "$skill_dir" 2>&1)"; then
		echo "FAIL: ${skill_dir#"$HW_ROOT"/} fails validation:"
		printf '%s\n' "$out" | grep '^ERROR: ' | sed 's/^/    /'
		fail=1
	fi
done

# The library validator is gone; the skill validator is the only one.
if [[ -e "$HW_FRAMEWORK/validate-library.sh" ]]; then
	echo "FAIL: framework/validate-library.sh still exists"
	fail=1
fi

[[ $fail -eq 0 ]] && echo "PASS: bundled templates and references are checked by validate-skill.sh"
exit $fail
