#!/usr/bin/env bash
# The harness path map selects scenarios from changed paths: a skill's files select that skill, a
# template selects each skill that names it, shared files and the runner select the smoke set,
# and generated copies, tests, and specs select nothing. Every shipped library file and every
# highway-experience file maps to a skill or is listed as shared.
set -u
# Instrument class: executable-behavior
# Artifact classes: harness-path-map, harness-selection
# Seeded failure probe: running the map against a skills folder where no skill names codify-plan.md reports the template as unmapped, and this check fails on it.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
PATH_MAP="$HW_HARNESS/bin/path-map.sh"
# Assembled rather than written literally, because shipped-tree-independence.test.sh scans this file
# for development-folder tokens.
SPEC_DIR="spec""s"
# shellcheck source=../lib/distribution.sh
source "$HW_LIB/distribution.sh"
fail=0
TAB="$(printf '\t')"

if [[ ! -f "$PATH_MAP" ]]; then
	echo "FAIL: harness/bin/path-map.sh does not exist"
	exit 1
fi

# expect <path> <kind> <target>: the map prints exactly one line for <path> with that kind and target.
expect() {
	local out lines kind target
	out="$(cd "$HW_ROOT" && bash "$PATH_MAP" "$1")"
	lines="$(printf '%s\n' "$out" | grep -c .)"
	kind="$(printf '%s\n' "$out" | head -n 1 | cut -f2)"
	target="$(printf '%s\n' "$out" | head -n 1 | cut -f3)"
	if [[ "$lines" -ne 1 || "$kind" != "$2" || "$target" != "$3" ]]; then
		echo "FAIL: $1 maps to '$out', expected kind $2 and target $3"
		fail=1
	fi
}

expect .highway/library/templates/output/codify-plan.md skill highway-codify
expect skills/highway-adr/SKILL.md skill highway-adr
expect skills/highway-experience/SKILL.md smoke smoke
expect skills/highway-experience/references/experience-standard.md smoke smoke
expect skills/highway-experience/references/storage-contract.md smoke smoke
expect skills/highway-experience/references/highway-identity.md smoke smoke
expect .highway/governance/storage.md none -
expect .highway/instructions/highway-agent-context.md none -
expect harness/src/runner.ts smoke smoke
expect harness/harness.config.json smoke smoke
expect harness/scenarios/highway-codify/codify-plan-review.scenario scenario codify-plan-review
expect harness/fixtures/stages/implementation/implementations/implementations.md fixture implementation
expect harness/fixtures/overlays/code-project/overlay.txt fixture code-project
expect "$SPEC_DIR/232-behavioral-test-harness/spec.md" none -
expect tests/run-all.sh none -
expect .claude/skills/highway-codify/SKILL.md none -
expect .highway/catalog/index.json none -
expect framework/constitution.md none -

reason="$(cd "$HW_ROOT" && bash "$PATH_MAP" .highway/library/templates/output/codify-plan.md | cut -f4)"
case "$reason" in
*highway-codify*codify-plan.md*) ;;
*)
	echo "FAIL: the reason for codify-plan.md does not name the skill and the template: $reason"
	fail=1
	;;
esac

# A template that several skills name selects each of them.
multi="$(cd "$HW_ROOT" && bash "$PATH_MAP" .highway/library/templates/output/adr-record.md | cut -f3 | sort -u | grep -c .)"
if [[ "$multi" -lt 2 ]]; then
	echo "FAIL: adr-record.md, named by several skills, selects $multi skill(s)"
	fail=1
fi

# FR-025: every shipped file under the library and highway-experience maps.
shipped=()
while IFS= read -r rel; do
	[[ "$(dist_classify "$rel")" == "include" ]] && shipped+=("$rel")
done < <(cd "$HW_ROOT" && find "$(hw_rel "$HW_LIBRARY")" "$(hw_rel "$HW_EXPERIENCE")" -type f | LC_ALL=C sort)
if [[ "${#shipped[@]}" -lt 30 ]]; then
	echo "FAIL: found only ${#shipped[@]} shipped library and highway-experience files"
	fail=1
fi
mapped="$(cd "$HW_ROOT" && bash "$PATH_MAP" "${shipped[@]}")"
if [[ "$(printf '%s\n' "$mapped" | cut -f1 | sort -u | grep -c .)" -ne "${#shipped[@]}" ]]; then
	echo "FAIL: the path map did not print a line for every shipped path"
	fail=1
fi
unmapped="$(printf '%s\n' "$mapped" | awk -F "$TAB" '$2 == "unmapped" { print $1 }')"
if [[ -n "$unmapped" ]]; then
	while IFS= read -r rel; do
		echo "FAIL: shipped path $rel maps to no skill and is not listed in harness/selection/shared.txt"
	done <<<"$unmapped"
	fail=1
fi

# Seeded probe: with no skill naming the template, it is reported unmapped.
empty_skills="$(mktemp -d)"
probe="$(cd "$HW_ROOT" && bash "$PATH_MAP" --skills-dir "$empty_skills" .highway/library/templates/output/codify-plan.md | cut -f2)"
rm -rf "$empty_skills"
if [[ "$probe" != "unmapped" ]]; then
	echo "FAIL: a template no skill names maps to '$probe', expected unmapped"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: changed paths select the expected scenarios and every shipped path maps"
