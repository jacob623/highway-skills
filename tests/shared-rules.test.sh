#!/usr/bin/env bash
# A rule more than one skill states lives once in framework/shared-rules/, and each skill it names
# holds that rule as a whole line.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a skill copy with one word of a shared rule changed fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
fail=0

# Prints the value of the one `<key>: ` line in a source, or nothing when there is not exactly one.
source_value() {
	local file="$1" key="$2"
	if [[ "$(grep -c "^$key: " "$file")" -ne 1 ]]; then
		return 1
	fi
	sed -n "s/^$key: //p" "$file"
}

# Prints a failure when the skill file does not hold the rule as a whole line.
check_holds() {
	local rule_name="$1" skill="$2" file="$3" rule="$4"
	if ! grep -Fxq -- "$rule" "$file"; then
		echo "$skill does not hold the $rule_name rule exactly as framework/shared-rules/$rule_name.txt states it"
	fi
}

shopt -s nullglob
sources=("$HW_SHARED_RULES"/*.txt)
shopt -u nullglob
if [[ "${#sources[@]}" -eq 0 ]]; then
	echo "FAIL: no shared rule under framework/shared-rules/"
	exit 1
fi

for src in "${sources[@]}"; do
	name="$(basename "$src" .txt)"
	if ! skills="$(source_value "$src" skills)" || [[ -z "$skills" ]]; then
		echo "FAIL: $name: needs exactly one non-empty skills: line"
		fail=1
		continue
	fi
	if ! rule="$(source_value "$src" rule)" || [[ -z "$rule" ]]; then
		echo "FAIL: $name: needs exactly one non-empty rule: line"
		fail=1
		continue
	fi
	for skill in $skills; do
		file="$HW_SKILLS/$skill/SKILL.md"
		if [[ ! -f "$file" ]]; then
			echo "FAIL: $name: names $skill, which has no SKILL.md"
			fail=1
			continue
		fi
		out="$(check_holds "$name" "$skill" "$file" "$rule")"
		if [[ -n "$out" ]]; then
			echo "FAIL: $out"
			fail=1
		fi
	done
done

# highway-codify-config titles no capability, so it neither states the rule nor names a capability template.
CONFIG="$HW_SKILLS/highway-codify-config/SKILL.md"
if grep -Fq 'Capability title rule' "$CONFIG" || grep -Fq 'capability-catalog.md' "$CONFIG"; then
	echo "FAIL: highway-codify-config states the capability title rule or names a capability template"
	fail=1
fi

# The check can fail: one changed word in a held rule is caught.
probe="$(mktemp)"
trap 'rm -f "$probe"' EXIT
src="$HW_SHARED_RULES/capability-title.txt"
rule="$(source_value "$src" rule)"
sed 's/one noun phrase of five words or fewer/one noun phrase of six words or fewer/' \
	"$HW_SKILLS/highway-architecture/SKILL.md" >"$probe"
if [[ -z "$(check_holds capability-title probe "$probe" "$rule")" ]]; then
	echo "FAIL: probe: a skill copy with one changed word of the capability title rule was not caught"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: shared rules held exactly by every skill that states them'
