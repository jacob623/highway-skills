#!/usr/bin/env bash
# Every Verification and Error Handling bullet of a gated skill is covered by a harness scenario, an
# invariant, or a waiver with a written reason. A tag whose bullet was reworded is reported as
# unknown beside the uncovered bullet, old and new text together. Other skills are reported only.
set -u
# Instrument class: static-document-contract
# Artifact classes: harness-scenario, harness-coverage-treatment, skill-verification
# Seeded failure probe: removing a highway-codify `covers:` line whose bullet has no treatment fails this check, naming the bullet.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
HARNESS="$HW_HARNESS"
TREATMENTS="$HARNESS/coverage/treatments.txt"
GATED="highway-codify"
TAB="$(printf '\t')"
# shellcheck source=../../../harness/bin/lib/scenario.sh
. "$HARNESS/bin/lib/scenario.sh"
fail=0

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if ! bash "$HARNESS/bin/inventory.sh" >"$WORK/inventory"; then
	echo "FAIL: harness/bin/inventory.sh failed"
	exit 1
fi

# Scenario tags: `<skill>\t<hash>\t<text>` for the primary skill and each pass-through skill.
: >"$WORK/tags"
: >"$WORK/no-writes"
while IFS= read -r file; do
	skills="$(scenario_values "$file" skill; scenario_values "$file" through)"
	if [[ -z "$(scenario_values "$file" writes)" ]]; then
		scenario_value "$file" skill >>"$WORK/no-writes"
	fi
	while IFS= read -r cover; do
		[[ -n "$cover" ]] || continue
		hash="${cover%% *}"
		text="${cover#* }"
		while IFS= read -r skill; do
			[[ -n "$skill" ]] && printf '%s\t%s\t%s\n' "$skill" "$hash" "$text" >>"$WORK/tags"
		done <<<"$skills"
	done < <(scenario_values "$file" covers)
done < <(scenario_list "$HARNESS")

# Treatments: `<skill>\t<hash>\t<type>\t<detail>\t<text>`.
: >"$WORK/treatments"
if [[ -f "$TREATMENTS" ]]; then
	line_no=0
	while IFS= read -r line; do
		line_no=$((line_no + 1))
		case "$line" in '' | '#'*) continue ;; esac
		head="${line%% :: *}"
		text="${line#* :: }"
		if [[ "$head" == "$line" ]]; then
			echo "FAIL: treatments.txt line $line_no has no ' :: <bullet text>'"
			fail=1
			continue
		fi
		read -r type skill hash detail <<<"$head"
		case "$type" in
		invariant:)
			case "$detail" in
			storage | no-shell | writes-nothing) ;;
			*)
				echo "FAIL: treatments.txt line $line_no names unknown invariant '$detail'"
				fail=1
				continue
				;;
			esac
			if [[ "$detail" == "writes-nothing" ]] && ! grep -qxF "$skill" "$WORK/no-writes"; then
				echo "FAIL: treatments.txt line $line_no uses writes-nothing, but no $skill scenario declares no writes:"
				fail=1
			fi
			;;
		waiver:)
			if [[ -z "$detail" ]]; then
				echo "FAIL: treatments.txt line $line_no waives a bullet with no reason"
				fail=1
				continue
			fi
			;;
		*)
			echo "FAIL: treatments.txt line $line_no starts with '$type', expected invariant: or waiver:"
			fail=1
			continue
			;;
		esac
		printf '%s\t%s\t%s\t%s\t%s\n' "$skill" "$hash" "${type%:}" "$detail" "$text" >>"$WORK/treatments"
	done <"$TREATMENTS"
fi

# Unknown tags and treatments: hashes absent from their skill's inventory.
awk -F "$TAB" '$2 != "step" { print $1 "\t" $3 }' "$WORK/inventory" | LC_ALL=C sort -u >"$WORK/known"
{
	cut -f1-3 "$WORK/tags"
	awk -F "$TAB" '{ print $1 "\t" $2 "\t" $5 }' "$WORK/treatments"
} | awk -F "$TAB" 'NR == FNR { k[$1 "\t" $2] = 1; next } !(($1 "\t" $2) in k)' "$WORK/known" - | LC_ALL=C sort -u >"$WORK/unknown"

for skill in $(cut -f1 "$WORK/inventory" | LC_ALL=C sort -u); do
	total=0
	covered=0
	uncovered=""
	while IFS="$TAB" read -r s kind hash text; do
		[[ "$s" == "$skill" && "$kind" != "step" ]] || continue
		total=$((total + 1))
		if awk -F "$TAB" -v s="$skill" -v h="$hash" '$1 == s && $2 == h { f = 1 } END { exit f ? 0 : 1 }' "$WORK/tags" "$WORK/treatments"; then
			covered=$((covered + 1))
		else
			uncovered="$uncovered$hash$TAB$text"$'\n'
		fi
	done <"$WORK/inventory"

	case " $GATED " in
	*" $skill "*)
		if [[ -n "$uncovered" ]]; then
			while IFS="$TAB" read -r hash text; do
				[[ -n "$hash" ]] || continue
				echo "FAIL: $skill bullet $hash is not covered by a scenario, an invariant, or a waiver"
				echo "      new: $text"
			done <<<"$uncovered"
			while IFS="$TAB" read -r s hash text; do
				[[ "$s" == "$skill" ]] && echo "      old (unknown tag $hash): $text"
			done <"$WORK/unknown"
			fail=1
		fi
		;;
	*)
		echo "INFO: $skill coverage $covered/$total (reported, not gated)"
		;;
	esac
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: every gated skill bullet is covered by a scenario, an invariant, or a waiver"
