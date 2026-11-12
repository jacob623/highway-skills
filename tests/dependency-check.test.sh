#!/usr/bin/env bash
# Tests lib/dependency-check.sh via validate-skill.sh. A dependency path is relative to the skill's
# own folder, so each temporary skill holds its own target in references/, and a path leaving the
# folder is a finding. Per feature 004 (shared content library), as amended by Phase 11.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
VALIDATE="$HW_FRAMEWORK/validate-skill.sh"
FIXTURES="$HW_FIXTURES"

TARGET_REL="references/dep-check-target.md"
TMP_SKILLS_DIR="$(mktemp -d)"

fail=0

cleanup() {
	rm -rf "$TMP_SKILLS_DIR"
}
trap cleanup EXIT

# write_target <skill dir>: the dependency target, inside that skill's own folder.
write_target() {
	mkdir -p "$1/references"
	cat >"$1/$TARGET_REL" <<-'EOF'
		---
		name: Dependency Target Fixture
		description: "A minimal, conformant fixture used only as a dependency target by validate-skill.sh's tests."
		metadata:
		  version: 1.0.0
		---

		## Purpose
		Provide a stable file for skill fixtures to declare a `dependencies` entry against.
	EOF
}

skill_with_dependency() {
	local id="$1" dep_path="$2" dep_version="$3"
	awk -v path="$dep_path" -v dv="$dep_version" '
		/^metadata:/ { print; getline; print; print "  dependencies:"; print "    - path: " path; print "      version: " dv; next }
		{ print }
	' "$FIXTURES/valid-skill/SKILL.md" | sed "s/^name: .*/name: $id/"
}

mkdir -p "$TMP_SKILLS_DIR/valid-with-dep"
skill_with_dependency "valid-with-dep" "$TARGET_REL" "1.0.0" >"$TMP_SKILLS_DIR/valid-with-dep/SKILL.md"
write_target "$TMP_SKILLS_DIR/valid-with-dep"

mkdir -p "$TMP_SKILLS_DIR/missing-dep"
skill_with_dependency "missing-dep" "references/does-not-exist.md" "1.0.0" >"$TMP_SKILLS_DIR/missing-dep/SKILL.md"

mkdir -p "$TMP_SKILLS_DIR/stale-dep"
skill_with_dependency "stale-dep" "$TARGET_REL" "0.9.0" >"$TMP_SKILLS_DIR/stale-dep/SKILL.md"
write_target "$TMP_SKILLS_DIR/stale-dep"

# The target exists beside this skill, in valid-with-dep, but not inside it.
mkdir -p "$TMP_SKILLS_DIR/outside-dep"
skill_with_dependency "outside-dep" "../valid-with-dep/$TARGET_REL" "1.0.0" >"$TMP_SKILLS_DIR/outside-dep/SKILL.md"

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
if [[ "$out" != *"[DEPENDENCY] dependency 'references/does-not-exist.md' does not exist"* ]]; then
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

# A path leaving the skill's folder fails, even though its target exists.
out="$("$VALIDATE" "$TMP_SKILLS_DIR/outside-dep" 2>&1)"
rc=$?
if [[ $rc -eq 0 ]]; then
	echo "FAIL: expected non-zero exit for a dependency outside the skill's folder, got 0"
	fail=1
fi
if [[ "$out" != *"[DEPENDENCY] dependency '../valid-with-dep/$TARGET_REL' leaves the skill's folder"* ]]; then
	echo "FAIL: expected a [DEPENDENCY] finding for a path leaving the skill's folder. Got:"
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
