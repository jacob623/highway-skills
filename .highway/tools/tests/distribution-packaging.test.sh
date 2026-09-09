#!/usr/bin/env bash
# Fails when the user-facing distribution cannot be produced, or can be produced while broken.
#
# The defect this guards against is invisible locally: the repository always contains everything,
# so every other check passes while the extracted subset is missing something it needs. Only a
# user would find out. Producing the distribution here, and deliberately breaking it, is what
# makes that failure visible before it ships.
#
# Every probe is removed with rm. Do not revert a probe with version control: during feature 010
# that discarded unrelated uncommitted work in the same file.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
GEN="$HIGHWAY_ROOT/tools/generate-distribution.sh"
fail=0

WORK="$(mktemp -d)"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

# --- The distribution can be produced and passes its own verification ---

dist="$WORK/dist"
if ! "$GEN" "$dist" >"$WORK/produce.log" 2>&1; then
	echo "FAIL: the distribution could not be produced"
	sed 's/^/    /' "$WORK/produce.log"
	fail=1
fi

# --- Two runs from the same repository state are byte-identical (FR-012) ---
# The production record is excluded: its content is a function of the files already compared.

second="$WORK/second"
if "$GEN" "$second" >/dev/null 2>&1; then
	if ! diff -r -x '.distribution-record' "$dist" "$second" >"$WORK/diff.log" 2>&1; then
		echo "FAIL: two packaging runs from the same repository state differ"
		sed 's/^/    /' "$WORK/diff.log"
		fail=1
	fi
fi

# --- Sweep residue from an interrupted earlier run ------------------------------------------------
#
# Every probe below is named with this run's PID, so a probe left behind by a run that was killed
# before its cleanup carries a different PID and is never removed by any later run. It then fails
# whichever test next builds a distribution -- reporting a dangling cross-reference rather than the
# abandoned probe -- which sends the reader looking in the wrong place. Observed twice.
rm -f "$REPO_ROOT"/distribution-probe-*.md \
	"$HIGHWAY_ROOT"/catalog/distribution-devref-probe-*.md \
	"$HIGHWAY_ROOT"/catalog/distribution-link-probe-*.md \
	"$HIGHWAY_ROOT"/catalog/distribution-reject-probe-*.md

# --- Probe: an undeclared repository path is reported, not silently classified ---

probe_path="$REPO_ROOT/distribution-probe-$$.md"
printf 'probe\n' >"$probe_path"
if "$GEN" "$WORK/p1" >"$WORK/p1.log" 2>&1; then
	echo "FAIL: an undeclared repository path did not stop packaging"
	fail=1
elif ! grep -q "distribution-probe-$$" "$WORK/p1.log"; then
	echo "FAIL: packaging rejected an undeclared path without naming it"
	fail=1
fi
rm -f "$probe_path"

# --- Probe: a development-only reference in a distributed file is caught ---
# The file is seeded under an included directory, so it is classified as shipping.
#
# The token is assembled at runtime rather than written literally. This file is scanned by
# shipped-tree-independence.test.sh, which searches for exactly this token, and a literal here
# would make that check fail on a file that is deliberately seeding a violation. Assembling it
# keeps the seeded probe real without exempting this file from a check that should cover it.
DEV_DIR="spec""s"

dev_probe="$HIGHWAY_ROOT/catalog/distribution-devref-probe-$$.md"
printf 'see the spec at %s/001-multi-agent-skill-suite/spec.md\n' "$DEV_DIR" >"$dev_probe"
if "$GEN" "$WORK/p2" >"$WORK/p2.log" 2>&1; then
	echo "FAIL: a development-only reference in a distributed file did not stop packaging"
	fail=1
elif ! grep -q "development-only location" "$WORK/p2.log"; then
	echo "FAIL: packaging rejected a development-only reference without naming the cause"
	fail=1
fi
rm -f "$dev_probe"

# --- Probe: an unresolvable cross-reference is caught ---

link_probe="$HIGHWAY_ROOT/catalog/distribution-link-probe-$$.md"
printf 'see [the missing file](no-such-file-%s.md)\n' "$$" >"$link_probe"
if "$GEN" "$WORK/p3" >"$WORK/p3.log" 2>&1; then
	echo "FAIL: an unresolvable cross-reference did not stop packaging"
	fail=1
elif ! grep -q "does not exist in the distribution" "$WORK/p3.log"; then
	echo "FAIL: packaging rejected an unresolvable reference without naming the target"
	fail=1
fi
rm -f "$link_probe"

# --- Probe: a rejected candidate is removed rather than left behind (FR-011) ---

reject_probe="$HIGHWAY_ROOT/catalog/distribution-reject-probe-$$.md"
printf 'see %s/001-multi-agent-skill-suite/spec.md\n' "$DEV_DIR" >"$reject_probe"
"$GEN" "$WORK/p4" >/dev/null 2>&1
rm -f "$reject_probe"
if [[ -d "$WORK/p4" ]]; then
	echo "FAIL: a rejected candidate distribution was left in place"
	fail=1
fi

# --- The self-validation check must be capable of failing ---
# A distribution missing its governing document must not validate. If this passes, the check is
# resolving something from outside the distribution and proves nothing about self-containment.

if [[ -d "$dist" ]]; then
	broken="$WORK/broken"
	cp -R "$dist" "$broken"
	rm -rf "$broken/.highway/governance"
	if env -u CONSTITUTION_FILE "$broken/.highway/tools/validate-skill.sh" \
		"$broken/.highway/skills/highway-help" >/dev/null 2>&1; then
		echo "FAIL: a distribution missing its governing document still validated"
		fail=1
	fi
fi

# --- The step refuses to overwrite a directory it did not produce (FR-013) ---

guard="$WORK/guard"
mkdir -p "$guard"
printf 'hand-authored\n' >"$guard/notes.md"
if "$GEN" "$guard" >/dev/null 2>&1; then
	echo "FAIL: packaging overwrote a directory it did not produce"
	fail=1
fi
if [[ "$(cat "$guard/notes.md" 2>/dev/null)" != "hand-authored" ]]; then
	echo "FAIL: packaging destroyed a file in a directory it did not produce"
	fail=1
fi

exit $fail
