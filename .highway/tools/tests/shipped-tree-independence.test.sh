#!/usr/bin/env bash
# Fails when a distributed file references a development-only location.
#
# Highway is developed with a spec-driven workflow whose directories are stripped from the
# user-facing package. A reference from a distributed file into one of those directories is
# unresolvable for every user, and is invisible here because the development tree always contains
# them. This check is what makes that boundary self-enforcing.
#
# Scope is textual, not semantic: document links, source comments, prose, and string literals all
# count. A check that has to decide whether a match "really counts" is a check that gets argued
# with. Fixtures are scanned with no exemption, per feature 010 (constitution relocation).
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SELF="shipped-tree-independence.test.sh"
fail=0

# The distributed path set, declared once. Adding a distributed location is one new loop here.
# The list names what ships rather than what does not: a newly added directory is out of scope
# until deliberately included, which fails in the safer direction.
shopt -s nullglob
TARGETS=("$HIGHWAY_ROOT")
for d in "$REPO_ROOT"/.github/skills/highway-*; do TARGETS+=("$d"); done
for d in "$REPO_ROOT"/.claude/skills/highway-*; do TARGETS+=("$d"); done
for f in "$REPO_ROOT"/.cursor/rules/highway-*; do TARGETS+=("$f"); done
shopt -u nullglob

# Reports "<file>:<line>: <text>". The skip is applied to the file path so this check does not
# match the very tokens it searches for in its own source.
find_violations() {
	local skip="${1:-}"
	grep -rnF -e '.specify/' -e 'specs/' "${TARGETS[@]}" 2>/dev/null \
		| awk -F: -v skip="$skip" '
			{
				file = $1; line = $2
				text = $0
				sub("^" file ":" line ":", "", text)
				if (skip != "" && index(file, skip) > 0) next
				print file ":" line ": " text
			}
		'
}

violations="$(find_violations "$SELF")"
if [[ -n "$violations" ]]; then
	echo "FAIL: distributed files reference a development-only location:"
	printf '%s\n' "$violations" | sed "s|$REPO_ROOT/||" | sed 's/^/    /'
	fail=1
fi

# The check must be capable of failing: seed a violation and confirm it is detected.
probe="$HIGHWAY_ROOT/tools/shipped-tree-probe-$$.tmp"
printf 'see specs/001-multi-agent-skill-suite/spec.md for details\n' >"$probe"
probe_hits="$(find_violations "$SELF" | grep -c "shipped-tree-probe-$$" | tr -d ' ')"
rm -f "$probe"

if [[ "$probe_hits" -eq 0 ]]; then
	echo "FAIL: the shipped-tree check did not detect a deliberately seeded violation"
	fail=1
fi

exit $fail
