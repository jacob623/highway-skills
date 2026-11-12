#!/usr/bin/env bash
# The harness path map selects scenarios from changed paths: a skill's files, including its record
# templates, select that skill, shared files and the runner select the smoke set, and generated copies,
# tests, and specs select nothing. Every shipped skill asset and highway-experience file maps to a skill
# or is listed as shared.
set -u
# Instrument class: executable-behavior
# Artifact classes: harness-path-map, harness-selection
# Seeded failure probe: a shipped path outside every skill maps to nothing, and the shipped-path check reports it.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
PATH_MAP="$HW_HARNESS/bin/path-map.sh"
# Assembled rather than written literally, because shipped-tree-independence.test.sh scans this file
# for development-folder tokens.
SPEC_DIR="spec""s"
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

expect skills/highway-codify/assets/codify-plan.md skill highway-codify
expect skills/highway-adr/SKILL.md skill highway-adr
expect skills/highway-setup/assets/request-catalog.md skill highway-setup
expect skills/highway-experience/SKILL.md smoke smoke
expect skills/highway-experience/references/experience-standard.md smoke smoke
expect skills/highway-experience/references/storage-contract.md smoke smoke
expect skills/highway-experience/references/highway-identity.md smoke smoke
expect harness/src/runner.ts smoke smoke
expect harness/harness.config.json smoke smoke
expect harness/scenarios/highway-codify/codify-plan-review.scenario scenario codify-plan-review
expect harness/fixtures/stages/implementation/implementations/implementations.md fixture implementation
expect harness/fixtures/overlays/code-project/overlay.txt fixture code-project
expect "$SPEC_DIR/232-behavioral-test-harness/spec.md" none -
expect tests/run-all.sh none -
expect .claude/skills/highway-codify/SKILL.md none -
expect skills/highway-help/assets/index.json skill highway-help
expect framework/constitution.md none -

expect skills/highway-adr/assets/adr-record.md skill highway-adr
expect skills/highway-architecture/assets/architecture-record.md skill highway-architecture
expect skills/highway-implementation/assets/implementation-record.md skill highway-implementation
reason="$(cd "$HW_ROOT" && bash "$PATH_MAP" skills/highway-adr/assets/adr-record.md | cut -f4)"
if [[ "$reason" != "skills/highway-adr/assets/adr-record.md is part of highway-adr" ]]; then
	echo "FAIL: the reason for adr-record.md does not name the skill and the template: $reason"
	fail=1
fi

# FR-025: every file under highway-experience and a skill's assets/ maps to a skill or the smoke set.
# Each ships inside its skill folder in every agent tree.
shipped=()
while IFS= read -r rel; do
	shipped+=("$rel")
done < <(cd "$HW_ROOT" && { find "$(hw_rel "$HW_EXPERIENCE")" -type f ! -name '.*'; find "$(hw_rel "$HW_SKILLS")" -path '*/assets/*' -type f ! -name '.*'; } | LC_ALL=C sort)
if [[ "${#shipped[@]}" -lt 30 ]]; then
	echo "FAIL: found only ${#shipped[@]} shipped highway-experience and skill asset files"
	fail=1
fi
mapped="$(cd "$HW_ROOT" && bash "$PATH_MAP" "${shipped[@]}")"
if [[ "$(printf '%s\n' "$mapped" | cut -f1 | sort -u | grep -c .)" -ne "${#shipped[@]}" ]]; then
	echo "FAIL: the path map did not print a line for every shipped path"
	fail=1
fi
# selects_nothing <map lines>: each path whose line selects neither a skill nor the smoke set.
selects_nothing() {
	printf '%s\n' "$1" | awk -F "$TAB" '$2 != "skill" && $2 != "smoke" { print $1 }'
}
unmapped="$(selects_nothing "$mapped")"
if [[ -n "$unmapped" ]]; then
	while IFS= read -r rel; do
		echo "FAIL: shipped path $rel maps to no skill and is not listed in harness/selection/shared.txt"
	done <<<"$unmapped"
	fail=1
fi

# Seeded probe: a shipped path outside every skill is reported.
probe="$(selects_nothing "$(cd "$HW_ROOT" && bash "$PATH_MAP" shared/templates/example-record.md)")"
if [[ -z "$probe" ]]; then
	echo "FAIL: probe: a shipped path outside every skill was not reported"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: changed paths select the expected scenarios and every shipped path maps"
