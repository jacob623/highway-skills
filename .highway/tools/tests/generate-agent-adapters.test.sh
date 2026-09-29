#!/usr/bin/env bash
# Tests .highway/tools/generate-agent-adapters.sh end-to-end using a temporary skill under skills/,
# then cleans up its own temporary fixture only; `.highway/skills/highway-help/` is a real,
# permanent skill (feature 006; renamed by feature 009) and is left untouched.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: generated-artifact
# Seeded failure probe: --probe <class> seeds a defect and observes detection; --probe <class>
# --neutralise runs the identical path unseeded and requires a clean pass. See the Feature 041
# probe-mode contract.

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" generated-artifact "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

# A hand-edited generated adapter must retain its hand-edited content (D4.1). Shared by normal
# mode, which exercises it end-to-end through the real generator, and probe mode, which exercises
# it directly against a seeded artifact.
hand_edit_preserved() {
	grep -q '^hand-edited line$' "$1" 2>/dev/null
}

# --- Probe mode: a dedicated CLI path for the D3.7 harness, separate from the end-to-end run below ---
if [[ -n "$probe_class" ]]; then
	probe_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/fixtures/agent-adapter-probe-$$.md"
	trap 'rm -f "$probe_file"' EXIT
	if [[ "$neutralise" -eq 0 ]]; then
		printf 'generated content\n' >"$probe_file"
	else
		printf 'generated content\nhand-edited line\n' >"$probe_file"
	fi
	if hand_edit_preserved "$probe_file"; then
		exit 0
	else
		exit 1
	fi
fi

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
CURSOR_TARGET="$REPO_ROOT/.cursor/skills/$TMP_ID/SKILL.md"
SPECKIT_SENTINEL="$REPO_ROOT/.github/skills/speckit-tasks/SKILL.md"
CURSOR_SPECKIT_SENTINEL="$REPO_ROOT/.cursor/skills/speckit-tasks/SKILL.md"
MANIFEST="$HIGHWAY_ROOT/tools/.adapter-manifest"

fail=0

cleanup() {
	rm -rf "$SKILL_SRC_DIR" \
		"$REPO_ROOT/.github/skills/$TMP_ID" \
		"$REPO_ROOT/.claude/skills/$TMP_ID" \
		"$REPO_ROOT/.cursor/skills/$TMP_ID" \
		"$REPO_ROOT/.cursor/rules/$TMP_ID.mdc" \
		"$REPO_ROOT"/.cursor/rules/highway-leftover-*.mdc
	if [[ -f "$MANIFEST" ]]; then
		grep -vF "$TMP_ID" "$MANIFEST" >"$MANIFEST.tmp" || true
		mv "$MANIFEST.tmp" "$MANIFEST"
	fi
}
trap cleanup EXIT

# Residue from a run killed before its cleanup carries a different PID, so no later run removes it.
# Its manifest rows then fail the correspondence check as orphans naming a skill with no source.
rm -rf "$HIGHWAY_ROOT"/skills/test-adapter-fixture-* \
	"$REPO_ROOT"/.github/skills/test-adapter-fixture-* \
	"$REPO_ROOT"/.claude/skills/test-adapter-fixture-* \
	"$REPO_ROOT"/.cursor/skills/test-adapter-fixture-* \
	"$REPO_ROOT"/.cursor/rules/test-adapter-fixture-*.mdc
if [[ -f "$MANIFEST" ]] && grep -q 'test-adapter-fixture-' "$MANIFEST"; then
	grep -v 'test-adapter-fixture-' "$MANIFEST" >"$MANIFEST.tmp" || true
	mv "$MANIFEST.tmp" "$MANIFEST"
fi

mkdir -p "$SKILL_SRC_DIR"
cp "$FIXTURES/valid-skill/SKILL.md" "$SKILL_SRC_DIR/SKILL.md"
# The fixture's frontmatter name is authored to match the fixture's own directory id
# (`valid-skill`); rewrite it to this temp skill's id so it still satisfies sv_validate_name.
sed -i.bak "s/^name: .*/name: $TMP_ID/" "$SKILL_SRC_DIR/SKILL.md" && rm -f "$SKILL_SRC_DIR/SKILL.md.bak"

speckit_before="$(sha256sum "$SPECKIT_SENTINEL" 2>/dev/null || shasum -a 256 "$SPECKIT_SENTINEL")"
cursor_speckit_before="$(sha256sum "$CURSOR_SPECKIT_SENTINEL" 2>/dev/null || shasum -a 256 "$CURSOR_SPECKIT_SENTINEL")"
instruction_claude="$REPO_ROOT/.claude/CLAUDE.md"
instruction_copilot="$REPO_ROOT/.github/copilot-instructions.md"
instruction_manifest_path="$HIGHWAY_ROOT/tools/.instruction-manifest"
instruction_hash() {
	if [[ ! -f "$1" ]]; then
		printf 'absent\n'
	elif command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$1" | awk '{print $1}'
	else
		shasum -a 256 "$1" | awk '{print $1}'
	fi
}
instruction_claude_before="$(instruction_hash "$instruction_claude")"
instruction_copilot_before="$(instruction_hash "$instruction_copilot")"
instruction_manifest_before="$(instruction_hash "$instruction_manifest_path")"

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

# Cursor receives a skill, not a rule (feature 097). The four assertions this block replaces
# (alwaysApply, globs omitted, description-only frontmatter, body re-emitted below rule
# frontmatter) described the removed mdc-transform conversion, which no longer exists; the
# Cursor deliverable is now an identity copy, so byte-identity supersedes all four.
if [[ ! -f "$CURSOR_TARGET" ]]; then
	echo "FAIL: $CURSOR_TARGET was not generated"
	fail=1
else
	if ! diff -q "$SKILL_SRC_DIR/SKILL.md" "$CURSOR_TARGET" >/dev/null 2>&1; then
		echo "FAIL: $CURSOR_TARGET is not byte-identical to source"
		fail=1
	fi
	if [[ -f "$CLAUDE_TARGET" ]] && ! diff -q "$CLAUDE_TARGET" "$CURSOR_TARGET" >/dev/null 2>&1; then
		echo "FAIL: $CURSOR_TARGET is not byte-identical to the Claude Code deliverable"
		fail=1
	fi
	for key in name description usage compatibility metadata; do
		if grep -q "^$key:" "$SKILL_SRC_DIR/SKILL.md" && ! grep -q "^$key:" "$CURSOR_TARGET"; then
			echo "FAIL: $CURSOR_TARGET is missing source frontmatter key '$key'"
			fail=1
		fi
	done
	if grep -q '^alwaysApply:' "$CURSOR_TARGET"; then
		echo "FAIL: $CURSOR_TARGET carries rule frontmatter ('alwaysApply')"
		fail=1
	fi
fi

if [[ -e "$REPO_ROOT/.cursor/rules/$TMP_ID.mdc" ]]; then
	echo "FAIL: a Cursor rule file was generated for $TMP_ID; Cursor receives skills, not rules"
	fail=1
fi

# Regression guard (feature 097, narrowed by feature 098). The loop previously failed on every
# highway-*.mdc because no instruction outputs existed (D3.5). A file is a leftover skill rule
# only when the instruction manifest has no row for that path. The adapter manifest still must
# not name .cursor/rules/.
instruction_manifest="$HIGHWAY_ROOT/tools/.instruction-manifest"
for stale_rule in "$REPO_ROOT"/.cursor/rules/highway-*.mdc; do
	if [[ -e "$stale_rule" ]]; then
		rel_rule="${stale_rule#"$REPO_ROOT"/}"
		if [[ ! -f "$instruction_manifest" ]] || ! grep -qF "$(printf '%s\t' "$rel_rule")" "$instruction_manifest"; then
			echo "FAIL: superseded Cursor rule file still present: $rel_rule"
			fail=1
		fi
	fi
done
# The same predicate, executed against a file that has no instruction-manifest row.
leftover_rule="$REPO_ROOT/.cursor/rules/highway-leftover-$$.mdc"
mkdir -p "$(dirname "$leftover_rule")"
printf 'leftover\n' >"$leftover_rule"
leftover_rel="${leftover_rule#"$REPO_ROOT"/}"
leftover_reported=0
if [[ -e "$leftover_rule" ]]; then
	if [[ ! -f "$instruction_manifest" ]] || ! grep -qF "$(printf '%s\t' "$leftover_rel")" "$instruction_manifest"; then
		leftover_reported=1
	fi
fi
rm -f "$leftover_rule"
if [[ "$leftover_reported" -ne 1 ]]; then
	echo "FAIL: a highway-*.mdc with no instruction-manifest row was not treated as a leftover skill rule"
	fail=1
fi
if [[ -f "$MANIFEST" ]] && grep -q '^\.cursor/rules/' "$MANIFEST"; then
	echo "FAIL: the adapter manifest still holds $(grep -c '^\.cursor/rules/' "$MANIFEST") row(s) naming .cursor/rules/"
	fail=1
fi

speckit_after="$(sha256sum "$SPECKIT_SENTINEL" 2>/dev/null || shasum -a 256 "$SPECKIT_SENTINEL")"
if [[ "$speckit_before" != "$speckit_after" ]]; then
	echo "FAIL: existing speckit-* file $SPECKIT_SENTINEL was modified"
	fail=1
fi

cursor_speckit_after="$(sha256sum "$CURSOR_SPECKIT_SENTINEL" 2>/dev/null || shasum -a 256 "$CURSOR_SPECKIT_SENTINEL")"
if [[ "$cursor_speckit_before" != "$cursor_speckit_after" ]]; then
	echo "FAIL: existing speckit-* file $CURSOR_SPECKIT_SENTINEL was modified"
	fail=1
fi

# Untracked collision (feature 097): a file already sitting at the Cursor skill path that the
# generator did not produce must be refused and named, left byte-for-byte as found, and must not
# cause a partial adapter set. The GitHub and Claude targets and every manifest row for this
# skill are removed first, so a run that ignored the collision would visibly recreate them.
{
	rm -f "$GH_TARGET" "$CLAUDE_TARGET"
	mkdir -p "$(dirname "$CURSOR_TARGET")"
	grep -vF "$TMP_ID" "$MANIFEST" >"$MANIFEST.tmp" || true
	mv "$MANIFEST.tmp" "$MANIFEST"
	printf 'collision content\n' >"$CURSOR_TARGET"
	collision_out="$("$GENERATE" 2>&1)"
	collision_rc=$?
	if [[ $collision_rc -eq 0 ]]; then
		echo "FAIL: the generator exited 0 despite an untracked file at $CURSOR_TARGET"
		fail=1
	fi
	if ! printf '%s' "$collision_out" | grep -qF ".cursor/skills/$TMP_ID/SKILL.md"; then
		echo "FAIL: the generator did not name the colliding file .cursor/skills/$TMP_ID/SKILL.md"
		fail=1
	fi
	if [[ "$(cat "$CURSOR_TARGET")" != "collision content" ]]; then
		echo "FAIL: the generator overwrote an untracked file at $CURSOR_TARGET"
		fail=1
	fi
	if [[ -e "$GH_TARGET" || -e "$CLAUDE_TARGET" ]]; then
		echo "FAIL: a partial adapter set was written despite the Cursor collision"
		fail=1
	fi
	# Recover so the remaining checks start from a fully generated tree.
	rm -f "$CURSOR_TARGET"
	if ! "$GENERATE" >/dev/null 2>&1; then
		echo "FAIL: the generator did not recover once the colliding file was removed"
		fail=1
	fi
}

# A generated artifact that was hand-edited must not be silently overwritten: the edit would
# vanish with no indication it ever existed. Enforces D4.1, which the Enforcement Map in the
# development constitution names this test for.
if [[ -f "$GH_TARGET" ]]; then
	printf '\nhand-edited line\n' >>"$GH_TARGET"
	if "$GENERATE" >/dev/null 2>&1; then
		echo "FAIL: the generator overwrote a hand-edited adapter instead of refusing"
		fail=1
	fi
	if ! hand_edit_preserved "$GH_TARGET"; then
		echo "FAIL: a hand-edited adapter was overwritten; the edit was lost"
		fail=1
	fi
fi

if [[ "$instruction_claude_before" != "$(instruction_hash "$instruction_claude")" \
	|| "$instruction_copilot_before" != "$(instruction_hash "$instruction_copilot")" \
	|| "$instruction_manifest_before" != "$(instruction_hash "$instruction_manifest_path")" ]]; then
	echo "FAIL: generate-agent-adapters.sh changed an instruction output or .instruction-manifest"
	fail=1
fi

exit $fail
