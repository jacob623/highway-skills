#!/usr/bin/env bash
# Tests lib/dependency-check.sh via validate-skill.sh. Dependency paths are resolved anchored
# at the real $HIGHWAY_ROOT (FR-007), not fixture-relative, so this test generates its target
# file and skill fixtures at run time under temp locations rather than using static
# tools/tests/fixtures/ files -- mirroring generate-catalog.test.sh's temp-real-artifact
# pattern. See specs/004-shared-content-library/contracts/dependency-validation-output.md.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-skill.sh"
FIXTURES="$SCRIPT_DIR/fixtures"

TARGET_REL="library/knowledge/dep-check-target-$$.md"
TARGET_FILE="$HIGHWAY_ROOT/$TARGET_REL"
TMP_SKILLS_DIR="$(mktemp -d)"

fail=0

cleanup() {
	rm -f "$TARGET_FILE"
	rm -rf "$TMP_SKILLS_DIR"
}
trap cleanup EXIT

mkdir -p "$(dirname "$TARGET_FILE")"
cat >"$TARGET_FILE" <<-'EOF'
	---
	name: Dependency Target Fixture
	description: "A minimal, conformant shared content fixture used only as a dependency target by validate-skill.sh's tests."
	metadata:
	  version: 1.0.0
	---

	## Purpose
	Provide a stable file for skill fixtures to declare a `dependencies` entry against.
EOF

skill_with_dependency() {
	local dep_path="$1" dep_version="$2"
	awk -v path="$dep_path" -v dv="$dep_version" '
		/^metadata:/ { print; getline; print; print "  dependencies:"; print "    - path: " path; print "      version: " dv; next }
		{ print }
	' "$FIXTURES/valid-skill/SKILL.md"
}

mkdir -p "$TMP_SKILLS_DIR/valid-with-dep"
skill_with_dependency "$TARGET_REL" "1.0.0" >"$TMP_SKILLS_DIR/valid-with-dep/SKILL.md"

mkdir -p "$TMP_SKILLS_DIR/missing-dep"
skill_with_dependency "content/knowledge/does-not-exist-$$.md" "1.0.0" >"$TMP_SKILLS_DIR/missing-dep/SKILL.md"

mkdir -p "$TMP_SKILLS_DIR/stale-dep"
skill_with_dependency "$TARGET_REL" "0.9.0" >"$TMP_SKILLS_DIR/stale-dep/SKILL.md"

# A resolvable dependency at the pinned version produces zero [DEPENDENCY] findings.
out="$("$VALIDATE" "$TMP_SKILLS_DIR/valid-with-dep" 2>&1)"
rc=$?
if [[ $rc -ne 0 ]]; then
	echo "FAIL: expected exit 0 for a skill with a resolvable dependency, got $rc. Output:"
	echo "$out"
	fail=1
fi
if printf '%s\n' "$out" | grep -q '\[DEPENDENCY\]'; then
	echo "FAIL: a resolvable dependency produced a [DEPENDENCY] finding. Output:"
	echo "$out"
	fail=1
fi

# A missing dependency path fails, naming the path.
out="$("$VALIDATE" "$TMP_SKILLS_DIR/missing-dep" 2>&1)"
rc=$?
if [[ $rc -eq 0 ]]; then
	echo "FAIL: expected non-zero exit for a missing dependency path, got 0"
	fail=1
fi
if [[ "$out" != *"[DEPENDENCY] dependency 'content/knowledge/does-not-exist-$$.md' does not exist"* ]]; then
	echo "FAIL: expected missing-path [DEPENDENCY] finding naming the path. Got:"
	echo "$out"
	fail=1
fi

# A stale pinned version fails, naming both the pinned and current version.
out="$("$VALIDATE" "$TMP_SKILLS_DIR/stale-dep" 2>&1)"
rc=$?
if [[ $rc -eq 0 ]]; then
	echo "FAIL: expected non-zero exit for a stale pinned dependency version, got 0"
	fail=1
fi
if [[ "$out" != *"[DEPENDENCY] dependency '$TARGET_REL' pinned at version 0.9.0, current version is 1.0.0"* ]]; then
	echo "FAIL: expected version-mismatch [DEPENDENCY] finding naming both versions. Got:"
	echo "$out"
	fail=1
fi

# A skill with no dependencies field at all (the existing valid-skill fixture) produces zero
# [DEPENDENCY] findings -- dependencies are optional, absence is not penalized.
out="$("$VALIDATE" "$FIXTURES/valid-skill" 2>&1)"
if printf '%s\n' "$out" | grep -q '\[DEPENDENCY\]'; then
	echo "FAIL: valid-skill (no dependencies field) produced a [DEPENDENCY] finding. Output:"
	echo "$out"
	fail=1
fi

exit $fail
