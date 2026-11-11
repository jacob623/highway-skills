#!/usr/bin/env bash
# Path map: what a changed path selects.
#
# Usage: path-map.sh [--skills-dir <dir>] <path>...
#        path-map.sh --location <skills|framework>
#   Paths are repository-relative. --skills-dir reads SKILL.md files from another tree, such as the
#   target branch's skills for a deleted path.
#   --location prints the repository-relative skills or framework location and exits.
#
# Prints `<path>\t<kind>\t<target>\t<reason>` for each selection a path makes:
#   skill <id>       every scenario of that skill, including scenarios passing through it
#   smoke smoke      the smoke set
#   scenario <id>    that scenario
#   fixture <name>   every scenario starting from that fixture (a stage includes its overlays)
#   none -           nothing; the reason says why
#   unmapped -       a shipped library file no skill names and harness/selection/shared.txt does
#                    not list (harness-path-map.test.sh fails on it)
#
# Bash 3.2 and the Declared Toolchain only. This is the single implementation; the runner calls it.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/paths.sh
. "$HERE/lib/paths.sh"
SKILLS_DIR="$HW_SKILLS"
SHARED="$HW_HARNESS/selection/shared.txt"
# shellcheck source=lib/scenario.sh
. "$HW_HARNESS/bin/lib/scenario.sh"

REL_SKILLS="$(hw_rel "$HW_SKILLS")"
REL_HARNESS="$(hw_rel "$HW_HARNESS")"
REL_LIBRARY="$(hw_rel "$HW_LIBRARY")"
REL_CATALOG="$(hw_rel "$HW_CATALOG")"
REL_FRAMEWORK="$(hw_rel "$HW_FRAMEWORK")"
REL_TESTS="$(hw_rel "$HW_TESTS")"
REL_COPILOT="$(hw_rel "$HW_AGENT_COPILOT")"
REL_CLAUDE="$(hw_rel "$HW_AGENT_CLAUDE")"
REL_CURSOR="$(hw_rel "$HW_AGENT_CURSOR")"
REL_CODEX="$(hw_rel "$HW_AGENT_CODEX")"

if [ "${1:-}" = "--location" ]; then
	case "${2:-}" in
	skills) printf '%s\n' "$REL_SKILLS" ;;
	framework) printf '%s\n' "$REL_FRAMEWORK" ;;
	*)
		printf 'path-map: unknown location: %s\n' "${2:-}" >&2
		exit 2
		;;
	esac
	exit 0
fi

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
	"$REL_HARNESS"/scenarios/*/*.scenario)
		emit "$path" scenario "$(scenario_id_from_path "$path")" "the scenario file changed"
		continue
		;;
	"$REL_HARNESS"/fixtures/stages/*/*)
		rest="${path#"$REL_HARNESS"/fixtures/stages/}"
		emit "$path" fixture "${rest%%/*}" "stage fixture ${rest%%/*} changed"
		continue
		;;
	"$REL_HARNESS"/fixtures/overlays/*/*)
		rest="${path#"$REL_HARNESS"/fixtures/overlays/}"
		emit "$path" fixture "${rest%%/*}" "overlay fixture ${rest%%/*} changed"
		continue
		;;
	"$REL_HARNESS"/src/* | "$REL_HARNESS"/package.json | "$REL_HARNESS"/package-lock.json | "$REL_HARNESS"/harness.config.json)
		emit "$path" smoke smoke "the harness runner or driver changed ($path)"
		continue
		;;
	"$REL_HARNESS"/*)
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
	"$REL_SKILLS"/*/*)
		rest="${path#"$REL_SKILLS"/}"
		emit "$path" skill "${rest%%/*}" "$path is part of ${rest%%/*}"
		;;
	"$REL_LIBRARY"/*)
		found=0
		for skill in $(skills_naming "$path"); do
			emit "$path" skill "$skill" "$skill names $path"
			found=1
		done
		if [ "$found" -eq 0 ]; then
			emit "$path" unmapped - "no skill names $path and harness/selection/shared.txt does not list it"
		fi
		;;
	"${REL_CLAUDE%%/*}"/* | "${REL_CURSOR%%/*}"/* | "${REL_COPILOT%%/*}"/* | "${REL_CODEX%%/*}"/*)
		emit "$path" none - "generated agent copy; its source selects scenarios"
		;;
	"$REL_CATALOG"/*)
		emit "$path" none - "generated catalog"
		;;
	"$REL_FRAMEWORK"/*)
		emit "$path" none - "framework scripts and documents; the bash suite covers them"
		;;
	"$REL_TESTS"/*)
		emit "$path" none - "the bash suite; it covers itself"
		;;
	*)
		emit "$path" none - "not a shipped skill input"
		;;
	esac
done
