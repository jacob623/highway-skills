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
# shellcheck source=tools/lib/distribution.sh
source "$HIGHWAY_ROOT/tools/lib/distribution.sh"
SELF="shipped-tree-independence.test.sh"
fail=0

# The distributed path set comes from .distribution-manifest, which declares it once (D1.6).
# Classification is per file rather than per directory because the two differ: the packaging
# tooling lives under an included directory but is itself excluded, and it necessarily contains
# the very tokens this check searches for.
#
# The test directory is then added back deliberately. The manifest excludes it, because its
# fixtures are non-conformant on purpose and must not reach a user, but feature 010 chose to scan
# fixtures here with no exemption, and narrowing that would weaken the check (D3.5). The scanned
# set is the distribution plus the tests, not the distribution alone.
scan_targets() {
	local rel
	while IFS= read -r rel; do
		[[ "$(dist_classify "$rel")" == "include" ]] && echo "$REPO_ROOT/$rel"
	done < <(find "$REPO_ROOT" -type f -not -path "$REPO_ROOT/.git/*" 2>/dev/null \
		| sed "s|^$REPO_ROOT/||")
	find "$HIGHWAY_ROOT/tools/tests" -type f 2>/dev/null
}

# Reports "<file>:<line>: <text>". The skip is applied to the file path so this check does not
# match the very tokens it searches for in its own source.
find_violations() {
	local skip="${1:-}"
	scan_targets | while IFS= read -r f; do
		[[ -n "$skip" && "$f" == *"$skip"* ]] && continue
		grep -nF -e '.specify/' -e 'specs/' "$f" 2>/dev/null | sed "s|^|$f:|"
	done
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

# A fixture is not part of the distribution but must still be scanned. Seeding one proves the
# deliberate addition of the test directory above has not been silently dropped.
fixture_probe="$HIGHWAY_ROOT/tools/tests/fixtures/shipped-tree-fixture-probe-$$.tmp"
printf 'see .specify/memory/constitution.md for details\n' >"$fixture_probe"
fixture_hits="$(find_violations "$SELF" | grep -c "shipped-tree-fixture-probe-$$" | tr -d ' ')"
rm -f "$fixture_probe"

if [[ "$fixture_hits" -eq 0 ]]; then
	echo "FAIL: the shipped-tree check no longer scans fixtures; its scope has been narrowed"
	fail=1
fi

exit $fail
