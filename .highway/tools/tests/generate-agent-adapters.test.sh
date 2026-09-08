#!/usr/bin/env bash
# Tests .highway/tools/generate-agent-adapters.sh end-to-end using a temporary skill under skills/,
# then cleans up its own temporary fixture only; `.highway/skills/highway-help/` is a real,
# permanent skill (feature 006; renamed by feature 009) and is left untouched.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# HIGHWAY_ROOT (.highway/) holds the generator + skill sources; REPO_ROOT (one level up) is
# where agent adapters are actually written -- per feature 002 (highway folder consolidation).
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
MANIFEST="$HIGHWAY_ROOT/tools/.adapter-manifest"

fail=0

cleanup() {
	rm -rf "$SKILL_SRC_DIR" \
		"$REPO_ROOT/.github/skills/$TMP_ID" \
		"$REPO_ROOT/.claude/skills/$TMP_ID" \
		"$CURSOR_TARGET"
	if [[ -f "$MANIFEST" ]]; then
		grep -vF "$TMP_ID" "$MANIFEST" >"$MANIFEST.tmp" || true
		mv "$MANIFEST.tmp" "$MANIFEST"
	fi
}
trap cleanup EXIT

mkdir -p "$SKILL_SRC_DIR"
cp "$FIXTURES/valid-skill/SKILL.md" "$SKILL_SRC_DIR/SKILL.md"
# The fixture's frontmatter name is authored to match the fixture's own directory id
# (`valid-skill`); rewrite it to this temp skill's id so it still satisfies sv_validate_name.
sed -i.bak "s/^name: .*/name: $TMP_ID/" "$SKILL_SRC_DIR/SKILL.md" && rm -f "$SKILL_SRC_DIR/SKILL.md.bak"

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

# A generated artifact that was hand-edited must not be silently overwritten: the edit would
# vanish with no indication it ever existed. Enforces D4.1, which the Enforcement Map in the
# development constitution names this test for.
if [[ -f "$GH_TARGET" ]]; then
	printf '\nhand-edited line\n' >>"$GH_TARGET"
	if "$GENERATE" >/dev/null 2>&1; then
		echo "FAIL: the generator overwrote a hand-edited adapter instead of refusing"
		fail=1
	fi
	if ! grep -q '^hand-edited line$' "$GH_TARGET"; then
		echo "FAIL: a hand-edited adapter was overwritten; the edit was lost"
		fail=1
	fi
fi

exit $fail
