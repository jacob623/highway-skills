#!/usr/bin/env bash
# Fixture check: every fixture file mapped in harness/fixtures/templates.map carries the required
# parts of its current template (FR-014).
#
# Usage: fixture-check.sh [fixture...]
#   A fixture is a stage name or an overlay name. With none named, every stage and overlay is checked.
#   An overlay is checked as its stage plus its files minus the paths in its `.delete`.
#
# Prints `<fixture>\t<path>\t<problem>` for each problem. Exit 0 when there is none, 1 otherwise.
# Bash 3.2 and the Declared Toolchain only. This is the single implementation; the runner and
# harness-fixtures.test.sh both call it.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/paths.sh
. "$HERE/lib/paths.sh"
FIXTURES="$HW_HARNESS/fixtures"
MAP="$FIXTURES/templates.map"
STAGES="setup request discovery architecture implementation"
TAB="$(printf '\t')"
# shellcheck source=lib/scenario.sh
. "$HW_HARNESS/bin/lib/scenario.sh"

if [ "$#" -eq 0 ]; then
	set -- $STAGES
	if [ -d "$FIXTURES/overlays" ]; then
		for d in "$FIXTURES/overlays"/*/; do
			[ -d "$d" ] || continue
			set -- "$@" "$(basename "$d")"
		done
	fi
fi

problems=0
problem() {
	printf '%s\t%s\t%s\n' "$1" "$2" "$3"
	problems=1
}

# template_for <relative path>: the first templates.map template whose glob matches, or nothing.
template_for() {
	while IFS="$TAB" read -r glob template; do
		case "$glob" in '' | '#'*) continue ;; esac
		if printf '%s\n' "$1" | grep -Eq "$(scenario_glob_regex "$glob")"; then
			printf '%s\n' "$template"
			return 0
		fi
	done <"$MAP"
}

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

for fixture in "$@"; do
	view="$WORK/$fixture"
	mkdir -p "$view"
	stage=""
	case " $STAGES " in
	*" $fixture "*)
		stage="$fixture"
		;;
	*)
		overlay="$FIXTURES/overlays/$fixture"
		if [ ! -f "$overlay/overlay.txt" ]; then
			problem "$fixture" - "not a stage, and no overlay.txt at harness/fixtures/overlays/$fixture"
			continue
		fi
		stage="$(awk '/^stage:/ { sub(/^stage:[ \t]*/, ""); sub(/[ \t]+$/, ""); print; exit }' "$overlay/overlay.txt")"
		case " $STAGES " in
		*" $stage "*) ;;
		*)
			problem "$fixture" overlay.txt "names no known stage: '$stage'"
			continue
			;;
		esac
		;;
	esac

	if [ ! -d "$FIXTURES/stages/$stage" ]; then
		problem "$fixture" - "stage fixture harness/fixtures/stages/$stage is missing"
		continue
	fi
	cp -R "$FIXTURES/stages/$stage/." "$view/"
	if [ "$stage" != "$fixture" ]; then
		cp -R "$FIXTURES/overlays/$fixture/." "$view/"
		rm -f "$view/overlay.txt"
		if [ -f "$view/.delete" ]; then
			while IFS= read -r rel; do
				case "$rel" in '' | '#'*) continue ;; esac
				case "$rel" in
				/* | *..*)
					problem "$fixture" .delete "path leaves the project: $rel"
					continue
					;;
				esac
				if [ ! -e "$view/$rel" ]; then
					problem "$fixture" .delete "deletes a path its stage does not have: $rel"
				fi
				rm -rf "${view:?}/$rel"
			done <"$view/.delete"
			rm -f "$view/.delete"
		fi
	fi

	if [ -d "$(hw_at "$view" "$HW_HIGHWAY")" ]; then
		problem "$fixture" .highway "fixtures hold project files only; the distribution supplies .highway/"
	fi
	while IFS= read -r rel; do
		template="$(template_for "$rel")"
		[ -n "$template" ] || continue
		if ! out="$(bash "$HW_HARNESS/bin/template-check.sh" "$template" "$view/$rel" 2>&1)"; then
			while IFS= read -r line; do
				[ -n "$line" ] && problem "$fixture" "$rel" "$line ($template)"
			done <<EOF
$out
EOF
		fi
	done <<EOF
$(cd "$view" && find . -type f | sed 's|^\./||' | LC_ALL=C sort)
EOF
done

exit "$problems"
