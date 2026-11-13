#!/usr/bin/env bash
# Harness scenario files follow the scenario format: known keys, required keys once, unique ids that
# match their file names, known skills, fixtures, and steps, replies keyed by a question, expected
# files inside the scenario's writes: patterns, exactly one smoke scenario per skill, and chain
# positions 1 to 6 each used exactly once.
set -u
# Instrument class: static-document-contract
# Artifact classes: harness-scenario
# Seeded failure probe: a scenario whose `expect: exists` path matches none of its `writes:` patterns, or a second smoke scenario for one skill, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
HARNESS="$HW_HARNESS"
SKILLS="$HW_SKILLS"
FIXTURES="$HARNESS/fixtures"
STAGES="setup request discovery architecture implementation"
KEYS=" id skill through fixture chain smoke web open ask ask-pattern say writes expect covers reaches shows "
SINGLE=" id skill fixture chain smoke web open "
KINDS=" accept edit question unknown decline select "
ASSERTIONS=" exists absent heading field row contains contains-any template "
TAB="$(printf '\t')"
# shellcheck source=../../../harness/bin/lib/scenario.sh
. "$HARNESS/bin/lib/scenario.sh"
fail=0

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

files="$(scenario_list "$HARNESS")"
if [[ -z "$files" ]]; then
	echo "FAIL: no scenario files under harness/scenarios/"
	exit 1
fi

bash "$HARNESS/bin/inventory.sh" | awk -F "$TAB" '$2 == "step" { print $1 "\t" $3 }' >"$WORK/steps"

# fixture_files <fixture>: the files a fixture starts with, one relative path per line.
fixture_files() {
	local stage overlay
	case " $STAGES " in
	*" $1 "*)
		(cd "$FIXTURES/stages/$1" 2>/dev/null && find . -type f | sed 's|^\./||')
		return 0
		;;
	esac
	overlay="$FIXTURES/overlays/$1"
	[[ -f "$overlay/overlay.txt" ]] || return 0
	stage="$(awk '/^stage:/ { sub(/^stage:[ \t]*/, ""); print; exit }' "$overlay/overlay.txt")"
	{
		(cd "$FIXTURES/stages/$stage" 2>/dev/null && find . -type f | sed 's|^\./||')
		(cd "$overlay" && find . -type f -not -name overlay.txt -not -name .delete | sed 's|^\./||')
	} | LC_ALL=C sort -u
}

: >"$WORK/ids"
: >"$WORK/smoke"
: >"$WORK/chain"
while IFS= read -r file; do
	rel="${file#"$HW_ROOT"/}"
	entries="$(scenario_entries "$file")"
	bad() {
		echo "FAIL: $rel:$1: $2"
		fail=1
	}

	pending=""
	while IFS="$TAB" read -r line key value; do
		[[ -n "$line" ]] || continue
		if [[ "$key" == "!malformed" ]]; then
			bad "$line" "not a 'key: value' line"
			continue
		fi
		case "$KEYS" in *" $key "*) ;; *) bad "$line" "unknown key '$key'" ;; esac
		case "$key" in
		ask | ask-pattern)
			[[ -n "$pending" ]] && bad "$line" "'$key' follows a key with no 'say'"
			pending="$line"
			;;
		say)
			if [[ -z "$pending" ]]; then
				bad "$line" "'say' has no 'ask' or 'ask-pattern' before it"
			fi
			pending=""
			case "$value" in
			\[*\]*)
				kind="${value#\[}"
				kind="${kind%%\]*}"
				case "$KINDS" in *" $kind "*) ;; *) bad "$line" "unknown reply kind '[$kind]'" ;; esac
				;;
			esac
			;;
		covers)
			if ! printf '%s\n' "$value" | grep -Eq '^[0-9a-f]{12} .+'; then
				bad "$line" "'covers' needs a 12-hex hash and the bullet text"
			fi
			;;
		esac
	done <<<"$entries"
	[[ -n "$pending" ]] && bad "$pending" "key has no 'say' after it"

	for key in $SINGLE; do
		n="$(printf '%s\n' "$entries" | awk -F "$TAB" -v k="$key" '$2 == k' | grep -c .)"
		if [[ "$n" -gt 1 ]]; then
			bad 1 "'$key' appears $n times"
		fi
	done
	for key in id skill fixture open; do
		if [[ -z "$(scenario_value "$file" "$key")" ]]; then
			bad 1 "missing '$key'"
		fi
	done

	id="$(scenario_value "$file" id)"
	skill="$(scenario_value "$file" skill)"
	fixture="$(scenario_value "$file" fixture)"
	printf '%s\n' "$id" >>"$WORK/ids"
	[[ "$id" == "$(scenario_id_from_path "$file")" ]] || bad 1 "id '$id' does not match the file name"
	[[ "$(basename "$(dirname "$file")")" == "$skill" ]] || bad 1 "the file is not in harness/scenarios/$skill/"
	for s in $skill $(scenario_values "$file" through); do
		[[ -f "$SKILLS/$s/SKILL.md" ]] || bad 1 "unknown skill '$s'"
	done
	for flag in smoke web; do
		v="$(scenario_value "$file" "$flag")"
		[[ -z "$v" || "$v" == "yes" || "$v" == "no" ]] || bad 1 "'$flag' must be yes or no"
	done
	[[ "$(scenario_value "$file" smoke)" == "yes" ]] && printf '%s\t%s\n' "$skill" "$id" >>"$WORK/smoke"
	chain="$(scenario_value "$file" chain)"
	if [[ -n "$chain" ]]; then
		case "$chain" in
		[1-6]) printf '%s\t%s\n' "$chain" "$id" >>"$WORK/chain" ;;
		*) bad 1 "'chain' must be 1 to 6" ;;
		esac
	fi

	case "$fixture" in
	empty) ;;
	*)
		case " $STAGES " in
		*" $fixture "*) [[ -d "$FIXTURES/stages/$fixture" ]] || bad 1 "stage fixture '$fixture' is missing" ;;
		*) [[ -f "$FIXTURES/overlays/$fixture/overlay.txt" ]] || bad 1 "unknown fixture '$fixture'" ;;
		esac
		;;
	esac

	while IFS= read -r step; do
		[[ -n "$step" ]] || continue
		if ! grep -qxF "$skill$TAB$step" "$WORK/steps"; then
			bad 1 "'reaches: $step' is not a step of $skill"
		fi
	done < <(scenario_values "$file" reaches)

	writes="$(scenario_values "$file" writes)"
	starts="$(fixture_files "$fixture")"
	while IFS="$TAB" read -r line key value; do
		[[ "$key" == "expect" ]] || continue
		head="${value%% :: *}"
		arg=""
		[[ "$head" != "$value" ]] && arg="${value#* :: }"
		read -r assertion path extra <<<"$head"
		case "$ASSERTIONS" in *" $assertion "*) ;; *)
			bad "$line" "unknown assertion '$assertion'"
			continue
			;;
		esac
		if [[ -z "$path" || -n "$extra" ]]; then
			bad "$line" "'expect' needs '<assertion> <path>[ :: <argument>]'"
			continue
		fi
		case "$assertion" in
		exists | absent) [[ -z "$arg" ]] || bad "$line" "'$assertion' takes no argument" ;;
		*) [[ -n "$arg" ]] || bad "$line" "'$assertion' needs an argument after ' :: '" ;;
		esac
		[[ "$assertion" == "absent" ]] && continue
		inside=0
		while IFS= read -r glob; do
			[[ -n "$glob" ]] || continue
			if printf '%s\n' "$path" | grep -Eq "$(scenario_glob_regex "$glob")"; then
				inside=1
				break
			fi
		done <<<"$writes"
		if [[ "$inside" -eq 0 ]] && ! printf '%s\n' "$starts" | grep -Eq "$(scenario_glob_regex "$path")"; then
			bad "$line" "expected file $path matches none of the writes: patterns and is not in fixture $fixture"
		fi
	done <<<"$entries"
done <<<"$files"

dupes="$(LC_ALL=C sort "$WORK/ids" | uniq -d)"
for id in $dupes; do
	echo "FAIL: scenario id '$id' is used more than once"
	fail=1
done

for d in "$SKILLS"/*/; do
	skill="$(basename "$d")"
	[[ -f "$d/SKILL.md" ]] || continue
	n="$(awk -F "$TAB" -v s="$skill" '$1 == s' "$WORK/smoke" | grep -c .)"
	if [[ "$n" -ne 1 ]]; then
		echo "FAIL: $skill has $n smoke scenarios; exactly one is required"
		fail=1
	fi
done

for position in 1 2 3 4 5 6; do
	n="$(awk -F "$TAB" -v p="$position" '$1 == p' "$WORK/chain" | grep -c .)"
	if [[ "$n" -ne 1 ]]; then
		echo "FAIL: chain position $position is used by $n scenarios; exactly one is required"
		fail=1
	fi
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: every harness scenario follows the scenario format, with one smoke scenario per skill and a complete chain"
