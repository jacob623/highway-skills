#!/usr/bin/env bash
# Fails when a script builds a repository location itself instead of getting it from the paths
# helper (framework/lib/paths.sh). Decides D2.5.
#
# Scans every *.sh under the framework folder (scripts and shared libraries), the tests folder
# (tests and fixture scripts), and the harness bin folder. The helper is exempt; the two bootstrap shims are exempt from the
# script-folder rule only, because sourcing the helper is their whole job. Comment lines are
# skipped. Text a test greps for, path-map inputs, fixture content, and printed messages are
# literals with no variable in front of the folder name, so no rule matches them.
#
# Rules, reported as "<file>:<line>: rule <n> (<name>): <text>":
#   1 root variable     a self-built root variable name (the names the helper replaced)
#   2 declared segment  a variable joined to a folder the helper declares
#   3 script folder     the script's own folder used for anything but sourcing the helper, or a
#                       climb with .. from a variable or a dirname
#   4 named file        a named template or governance or knowledge document joined to its folder
#                       instead of looked up with hw_template or hw_doc
#
# The patterns use bracket expressions ([.], [$], [_]) so this file's own source does not match.
set -u
# Instrument class: executed-behavior
# Artifact classes: source-document
# Seeded failure probe: --probe <class> seeds a script that builds a skills path from a root
# variable and requires detection; --probe <class> --neutralise seeds the same script using the
# helper and requires a clean pass.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

HELPER="$HW_LIB/paths.sh"
TEST_SHIM="$HW_TESTS/paths.sh"
HARNESS_SHIM="$HW_HARNESS/bin/lib/paths.sh"

B='([/"[:space:]]|$)'
R1='(^|[^A-Za-z0-9_])(HIGHWAY[_]ROOT|REPO[_]ROOT|highway[_]root)([^A-Za-z0-9_]|$)'
R2="[\$][{]?[A-Za-z_][A-Za-z0-9_]*[}]?\"?/([.]highway|[.]github/|[.]claude/|[.]cursor/|[.]agents/|AGENTS[.]md|harness$B|skills$B|framework$B|tests$B)"
R2="$R2|[\$][{]?HW[_]HIGHWAY[}]?\"?/(skills|catalog|governance|instructions|library)$B"
R2="$R2|[\$][{]?HW[_]FRAMEWORK[}]?\"?/lib$B"
R2="$R2|[\$][{]?HW[_]TESTS[}]?\"?/fixtures$B"
R2="$R2|[\$][{]?HW[_]LIBRARY[}]?\"?/(knowledge|templates)$B"
R3_USE='(^|[^A-Za-z0-9_])(SCRIPT[_]DIR|H[E]RE)([^A-Za-z0-9_]|$)'
R3_ASSIGN='^[[:space:]]*(SCRIPT[_]DIR|H[E]RE)='
R3_SOURCE='(source|[.])[[:space:]].*paths[.]sh'
R3_CLIMB="(dirname[^)]*[)]|[\$][{]?[A-Za-z_][A-Za-z0-9_]*[}]?)\"?/[.][.]$B"
R4="[\$][{]?HW[_](OUTPUT[_]TEMPLATES|GOVERNANCE|KNOWLEDGE)[}]?\"?/[A-Za-z0-9_-]"
R4="$R4|[\$][{]?HW[_]FRAMEWORK[}]?\"?/(constitution|authoring-standard|frontmatter-lexicon)[.]"

# scan_file <file> <label> <shim 0|1>
scan_file() {
	awk -v label="$2" -v shim="$3" -v r1="$R1" -v r2="$R2" -v r3use="$R3_USE" \
		-v r3assign="$R3_ASSIGN" -v r3source="$R3_SOURCE" -v r3climb="$R3_CLIMB" -v r4="$R4" '
		/^[[:space:]]*#/ { next }
		{
			rule = ""
			if ($0 ~ r1) rule = "1 (root variable)"
			else if ($0 ~ r2) rule = "2 (declared segment)"
			else if (shim == 0 && ($0 ~ r3climb || ($0 ~ r3use && $0 !~ r3assign && $0 !~ r3source))) rule = "3 (script folder)"
			else if ($0 ~ r4) rule = "4 (named file)"
			if (rule != "") print label ":" NR ": rule " rule ": " $0
		}
	' "$1"
}

# find_violations <dir>...: every violation in the *.sh files under the given folders.
find_violations() {
	local f label shim
	find "$@" -type f -name '*.sh' 2>/dev/null | sort | while IFS= read -r f; do
		[[ "$f" == "$HELPER" ]] && continue
		shim=0
		[[ "$f" == "$TEST_SHIM" || "$f" == "$HARNESS_SHIM" ]] && shim=1
		label="${f#"$HW_ROOT"/}"
		scan_file "$f" "$label" "$shim"
	done
}

if [[ -n "$probe_class" ]]; then
	probe_dir="$(mktemp -d "${TMPDIR:-/tmp}/path-construction-probe.XXXXXX")"
	trap 'rm -rf "$probe_dir"' EXIT
	if [[ $neutralise -eq 1 ]]; then
		printf '%s\n' 'x="$HW_SKILLS/highway-help/SKILL.md"' >"$probe_dir/seed.sh"
	else
		printf '%s\n' "x=\"\$REPO""_ROOT/skills/highway-help/SKILL.md\"" >"$probe_dir/seed.sh"
	fi
	found="$(find_violations "$probe_dir")"
	if [[ -n "$found" ]]; then
		echo "FAIL: probe violation found: $found"
		exit 1
	fi
	echo "OK: probe clean"
	exit 0
fi

found="$(find_violations "$HW_FRAMEWORK" "$HW_TESTS" "$HW_HARNESS/bin")"
if [[ -n "$found" ]]; then
	echo "FAIL: paths built outside the paths helper ($(printf '%s\n' "$found" | wc -l | tr -d ' ') lines):"
	printf '%s\n' "$found" | sed 's/^/    /'
	exit 1
fi
echo 'OK: every script gets repository locations from the paths helper'
