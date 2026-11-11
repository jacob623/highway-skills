#!/usr/bin/env bash
# Path map: what a changed path selects.
#
# Usage: path-map.sh [--skills-dir <dir>] <path>...
#   Paths are repository-relative. --skills-dir reads SKILL.md files from another tree, such as the
#   target branch's skills for a deleted path.
#
# Prints `<path>\t<kind>\t<target>\t<reason>` for each selection a path makes:
#   skill <id>       every scenario of that skill, including scenarios passing through it
#   smoke smoke      the smoke set
#   scenario <id>    that scenario
#   fixture <name>   every scenario starting from that fixture (a stage includes its overlays)
#   none -           nothing; the reason says why
#   unmapped -       a shipped library, governance, or instruction file no skill names and
#                    harness/selection/shared.txt does not list (harness-path-map.test.sh fails on it)
#
# Bash 3.2 and the Declared Toolchain only. This is the single implementation; the runner calls it.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$HERE/../.." && pwd)"
SKILLS_DIR="$REPO_ROOT/.highway/skills"
SHARED="$REPO_ROOT/harness/selection/shared.txt"
# shellcheck source=lib/scenario.sh
. "$HERE/lib/scenario.sh"

if [ "${1:-}" = "--skills-dir" ]; then
	SKILLS_DIR="$2"
	shift 2
fi

emit() {
	printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4"
}

# shared_kind <path>: `smoke` or `none` from shared.txt, or nothing.
shared_kind() {
	[ -f "$SHARED" ] || return 0
	while IFS="$(printf '\t')" read -r kind glob; do
		case "$kind" in
		smoke | none) ;;
		*) continue ;;
		esac
		[ -n "$glob" ] || continue
		if printf '%s\n' "$1" | grep -Eq "$(scenario_glob_regex "$glob")"; then
			printf '%s\n' "$kind"
			return 0
		fi
	done <"$SHARED"
}

# skills_naming <repo-relative path>: each skill whose SKILL.md names the path.
skills_naming() {
	for f in "$SKILLS_DIR"/*/SKILL.md; do
		[ -f "$f" ] || continue
		if grep -qF -- "$1" "$f"; then
			basename "$(dirname "$f")"
		fi
	done
}

for path in "$@"; do
	path="${path#./}"
	case "$path" in
	harness/scenarios/*/*.scenario)
		emit "$path" scenario "$(scenario_id_from_path "$path")" "the scenario file changed"
		continue
		;;
	harness/fixtures/stages/*/*)
		rest="${path#harness/fixtures/stages/}"
		emit "$path" fixture "${rest%%/*}" "stage fixture ${rest%%/*} changed"
		continue
		;;
	harness/fixtures/overlays/*/*)
		rest="${path#harness/fixtures/overlays/}"
		emit "$path" fixture "${rest%%/*}" "overlay fixture ${rest%%/*} changed"
		continue
		;;
	harness/src/* | harness/package.json | harness/package-lock.json | harness/harness.config.json)
		emit "$path" smoke smoke "the harness runner or driver changed ($path)"
		continue
		;;
	harness/*)
		emit "$path" none - "harness documentation, coverage, or bash checks; the bash suite covers it"
		continue
		;;
	esac

	shared="$(shared_kind "$path")"
	if [ "$shared" = "smoke" ]; then
		emit "$path" smoke smoke "$path is shared by every skill"
		continue
	fi
	if [ "$shared" = "none" ]; then
		emit "$path" none - "$path is listed in harness/selection/shared.txt as selecting nothing"
		continue
	fi

	case "$path" in
	.highway/skills/*/*)
		rest="${path#.highway/skills/}"
		emit "$path" skill "${rest%%/*}" "$path is part of ${rest%%/*}"
		;;
	.highway/library/* | .highway/governance/* | .highway/instructions/*)
		found=0
		for skill in $(skills_naming "$path"); do
			emit "$path" skill "$skill" "$skill names $path"
			found=1
		done
		if [ "$found" -eq 0 ]; then
			emit "$path" unmapped - "no skill names $path and harness/selection/shared.txt does not list it"
		fi
		;;
	.claude/* | .cursor/* | .github/* | .agents/* | AGENTS.md)
		emit "$path" none - "generated agent copy; its source selects scenarios"
		;;
	.highway/catalog/*)
		emit "$path" none - "generated catalog"
		;;
	.highway/tools/*)
		emit "$path" none - "tools, generators, validators, and tests are covered by the bash suite"
		;;
	*)
		emit "$path" none - "not a shipped skill input"
		;;
	esac
done
