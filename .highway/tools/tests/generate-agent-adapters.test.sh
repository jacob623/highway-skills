#!/usr/bin/env bash
# Tests .highway/tools/generate-agent-adapters.sh end-to-end using a temporary skill under skills/,
# then cleans up so skills/ is left empty (FR-011).
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# HIGHWAY_ROOT (.highway/) holds the generator + skill sources; REPO_ROOT (one level up) is
# where agent adapters are actually written -- see specs/002-highway-folder-consolidation/research.md.
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
GENERATE="$HIGHWAY_ROOT/tools/generate-agent-adapters.sh"
FIXTURES="$SCRIPT_DIR/fixtures"

TMP_ID="test-adapter-fixture-$$"
SKILL_SRC_DIR="$HIGHWAY_ROOT/skills/$TMP_ID"
GH_TARGET="$REPO_ROOT/.github/skills/$TMP_ID/SKILL.md"
CLAUDE_TARGET="$REPO_ROOT/.claude/skills/$TMP_ID/SKILL.md"
CURSOR_TARGET="$REPO_ROOT/.cursor/rules/$TMP_ID.mdc"
SPECKIT_SENTINEL="$REPO_ROOT/.github/skills/speckit-tasks/SKILL.md"

fail=0

cleanup() {
	rm -rf "$SKILL_SRC_DIR" \
		"$REPO_ROOT/.github/skills/$TMP_ID" \
		"$REPO_ROOT/.claude/skills/$TMP_ID" \
		"$CURSOR_TARGET"
	local manifest="$HIGHWAY_ROOT/tools/.adapter-manifest"
	if [[ -f "$manifest" ]]; then
		grep -vF "$TMP_ID" "$manifest" >"$manifest.tmp" || true
		mv "$manifest.tmp" "$manifest"
	fi
}
trap cleanup EXIT

mkdir -p "$SKILL_SRC_DIR"
cp "$FIXTURES/valid-skill/SKILL.md" "$SKILL_SRC_DIR/SKILL.md"

speckit_before="$(sha256sum "$SPECKIT_SENTINEL" 2>/dev/null || shasum -a 256 "$SPECKIT_SENTINEL")"

if ! "$GENERATE" >/tmp/generate-agent-adapters.$$.log 2>&1; then
	echo "FAIL: .highway/tools/generate-agent-adapters.sh exited non-zero"
	cat /tmp/generate-agent-adapters.$$.log
	fail=1
fi
rm -f /tmp/generate-agent-adapters.$$.log

if [[ ! -f "$GH_TARGET" ]] || ! diff -q "$SKILL_SRC_DIR/SKILL.md" "$GH_TARGET" >/dev/null 2>&1; then
	echo "FAIL: $GH_TARGET is not byte-identical to source"
	fail=1
fi

if [[ ! -f "$CLAUDE_TARGET" ]] || ! diff -q "$SKILL_SRC_DIR/SKILL.md" "$CLAUDE_TARGET" >/dev/null 2>&1; then
	echo "FAIL: $CLAUDE_TARGET is not byte-identical to source"
	fail=1
fi

if [[ ! -f "$CURSOR_TARGET" ]]; then
	echo "FAIL: $CURSOR_TARGET was not generated"
	fail=1
else
	if ! grep -q '^alwaysApply: false$' "$CURSOR_TARGET"; then
		echo "FAIL: $CURSOR_TARGET missing 'alwaysApply: false'"
		fail=1
	fi
	if grep -q '^globs:' "$CURSOR_TARGET"; then
		echo "FAIL: $CURSOR_TARGET must omit 'globs'"
		fail=1
	fi
	expected_desc="$(grep -E '^description:' "$SKILL_SRC_DIR/SKILL.md" | head -n1)"
	if ! grep -qF "$expected_desc" "$CURSOR_TARGET"; then
		echo "FAIL: $CURSOR_TARGET description does not match source verbatim"
		fail=1
	fi
	if ! grep -q '^## When to use$' "$CURSOR_TARGET"; then
		echo "FAIL: $CURSOR_TARGET body was not copied verbatim below frontmatter"
		fail=1
	fi
fi

speckit_after="$(sha256sum "$SPECKIT_SENTINEL" 2>/dev/null || shasum -a 256 "$SPECKIT_SENTINEL")"
if [[ "$speckit_before" != "$speckit_after" ]]; then
	echo "FAIL: existing speckit-* file $SPECKIT_SENTINEL was modified"
	fail=1
fi

exit $fail
