#!/usr/bin/env bash
# Tests .highway/tools/generate-instructions.sh with a temporary instruction, then removes only
# that fixture. Permanent instructions under .highway/instructions/ are left as they were.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../lib/frontmatter.sh
source "$HW_LIB/frontmatter.sh"

GENERATE="$HW_TOOLS/generate-instructions.sh"
MANIFEST="$HW_TOOLS/.instruction-manifest"
TMP_ID="test-instruction-$$"
SRC="$HW_INSTRUCTIONS/$TMP_ID.md"
CURSOR="$HW_CURSOR_RULES/$TMP_ID.mdc"
CLAUDE="$HW_CLAUDE_MD"
COPILOT="$HW_COPILOT_MD"
AGENTS="$HW_AGENTS_MD"
SPECKIT_CURSOR="$HW_AGENT_CURSOR/speckit-tasks/SKILL.md"
SPECKIT_GITHUB="$HW_AGENT_COPILOT/speckit-tasks/SKILL.md"
ADAPTER_MANIFEST="$HW_TOOLS/.adapter-manifest"

fail=0
WORK="$(mktemp -d)"

file_hash() {
	if [[ ! -f "$1" ]]; then
		printf 'absent\n'
		return 0
	fi
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$1" | awk '{print $1}'
	else
		shasum -a 256 "$1" | awk '{print $1}'
	fi
}

save_optional() {
	local src="$1" dest="$2"
	if [[ -f "$src" ]]; then
		cp "$src" "$dest"
		printf 'present\n' >"$dest.flag"
	else
		printf 'absent\n' >"$dest.flag"
	fi
}

restore_optional() {
	local src="$1" dest="$2"
	if [[ "$(cat "$dest.flag")" == "present" ]]; then
		mkdir -p "$(dirname "$src")"
		cp "$dest" "$src"
	else
		rm -f "$src"
	fi
}

cleanup() {
	rm -f "$SRC" "$CURSOR"
	restore_optional "$CLAUDE" "$WORK/claude"
	restore_optional "$COPILOT" "$WORK/copilot"
	restore_optional "$AGENTS" "$WORK/agents"
	restore_optional "$MANIFEST" "$WORK/manifest"
	rm -rf "$WORK"
}
trap cleanup EXIT

save_optional "$CLAUDE" "$WORK/claude"
save_optional "$COPILOT" "$WORK/copilot"
save_optional "$AGENTS" "$WORK/agents"
save_optional "$MANIFEST" "$WORK/manifest"

if [[ ! -f "$GENERATE" ]]; then
	echo "FAIL: $GENERATE is absent"
	exit 1
fi

mkdir -p "$HW_INSTRUCTIONS"
cat >"$SRC" <<EOF
---
name: $TMP_ID
description: Temporary instruction for the generator test.
---
# Temporary Instruction

A body line for the generator test.
EOF

speckit_cursor_before="$(file_hash "$SPECKIT_CURSOR")"
speckit_github_before="$(file_hash "$SPECKIT_GITHUB")"
adapter_before="$(file_hash "$ADAPTER_MANIFEST")"

if ! "$GENERATE" >"$WORK/gen.log" 2>&1; then
	echo "FAIL: generate-instructions.sh exited non-zero for a valid temporary instruction"
	sed 's/^/    /' "$WORK/gen.log"
	exit 1
fi

if [[ "$speckit_cursor_before" != "$(file_hash "$SPECKIT_CURSOR")" ]]; then
	echo "FAIL: $SPECKIT_CURSOR changed"
	fail=1
fi
if [[ "$speckit_github_before" != "$(file_hash "$SPECKIT_GITHUB")" ]]; then
	echo "FAIL: $SPECKIT_GITHUB changed"
	fail=1
fi
if [[ "$adapter_before" != "$(file_hash "$ADAPTER_MANIFEST")" ]]; then
	echo "FAIL: .highway/tools/.adapter-manifest changed"
	fail=1
fi

if [[ ! -f "$CURSOR" ]]; then
	echo "FAIL: $CURSOR was not written"
	fail=1
else
	if ! grep -qx 'alwaysApply: true' "$CURSOR"; then
		echo "FAIL: $CURSOR is missing alwaysApply: true"
		fail=1
	fi
	if grep -q '^globs:' "$CURSOR"; then
		echo "FAIL: $CURSOR contains globs"
		fail=1
	fi
	fm_body "$SRC" >"$WORK/body"
	awk '
		/^---[[:space:]]*$/ { delim++; next }
		delim >= 2 { print }
	' "$CURSOR" >"$WORK/cursor-body"
	if ! cmp -s "$WORK/body" "$WORK/cursor-body"; then
		echo "FAIL: Cursor body differs from the source body"
		fail=1
	fi
fi

if [[ ! -f "$CLAUDE" || ! -f "$COPILOT" || ! -f "$AGENTS" ]]; then
	echo "FAIL: a merged repository file was not written"
	fail=1
elif ! cmp -s "$CLAUDE" "$COPILOT" || ! cmp -s "$CLAUDE" "$AGENTS"; then
	echo "FAIL: merged repository files differ"
	fail=1
elif ! cmp -s "$WORK/body" "$CLAUDE"; then
	# Equality to this body holds only when it is the only instruction. With a permanent
	# instruction present, the merged file is the join and must still contain this body.
	perm=0
	for existing in "$HW_INSTRUCTIONS"/*.md; do
		[[ "$(basename "$existing")" == "$TMP_ID.md" ]] && continue
		[[ -f "$existing" ]] || continue
		perm=1
	done
	if [[ "$perm" -eq 0 ]]; then
		echo "FAIL: the merged files are not the single instruction body"
		fail=1
	elif ! grep -qx '# Temporary Instruction' "$CLAUDE"; then
		echo "FAIL: merged file does not contain the temporary instruction body"
		fail=1
	fi
fi

hash_cursor="$(file_hash "$CURSOR")"
hash_claude="$(file_hash "$CLAUDE")"
hash_copilot="$(file_hash "$COPILOT")"
hash_agents="$(file_hash "$AGENTS")"
hash_manifest="$(file_hash "$MANIFEST")"
if ! "$GENERATE" >"$WORK/gen2.log" 2>&1; then
	echo "FAIL: the second generate-instructions.sh run exited non-zero"
	sed 's/^/    /' "$WORK/gen2.log"
	fail=1
elif [[ "$hash_cursor" != "$(file_hash "$CURSOR")" \
	|| "$hash_claude" != "$(file_hash "$CLAUDE")" \
	|| "$hash_copilot" != "$(file_hash "$COPILOT")" \
	|| "$hash_agents" != "$(file_hash "$AGENTS")" \
	|| "$hash_manifest" != "$(file_hash "$MANIFEST")" ]]; then
	echo "FAIL: a second run changed an output or the instruction manifest"
	fail=1
fi

# Hand-edited merged file is refused and left unchanged.
printf 'hand-edited line\n' >>"$CLAUDE"
cp "$CLAUDE" "$WORK/claude-edited"
cp "$COPILOT" "$WORK/copilot-before-refuse"
cp "$AGENTS" "$WORK/agents-before-refuse"
cp "$CURSOR" "$WORK/cursor-before-refuse"
if "$GENERATE" >"$WORK/refuse.log" 2>&1; then
	echo "FAIL: a hand-edited .claude/CLAUDE.md was overwritten"
	fail=1
elif ! grep -q '.claude/CLAUDE.md' "$WORK/refuse.log"; then
	echo "FAIL: the refusal did not name .claude/CLAUDE.md"
	sed 's/^/    /' "$WORK/refuse.log"
	fail=1
elif ! grep -qx 'hand-edited line' "$CLAUDE"; then
	echo "FAIL: the hand-edited line was not left in place"
	fail=1
elif ! cmp -s "$CLAUDE" "$WORK/claude-edited" \
	|| ! cmp -s "$COPILOT" "$WORK/copilot-before-refuse" \
	|| ! cmp -s "$AGENTS" "$WORK/agents-before-refuse" \
	|| ! cmp -s "$CURSOR" "$WORK/cursor-before-refuse"; then
	echo "FAIL: a refused run changed an output"
	fail=1
fi
# Put the merged file back so later cases and cleanup see generator output, not the edit.
# The pre-test snapshot is restored by the exit trap.
cp "$COPILOT" "$CLAUDE"

# Rejection and the empty set run in a copy so a bad source cannot touch this repository.
make_copy() {
	local dest="$1"
	mkdir -p "$(hw_at "$dest" "$HW_LIB")" "$(hw_at "$dest" "$HW_INSTRUCTIONS")" "$(dirname "$(hw_at "$dest" "$HW_CLAUDE_MD")")"
	cp "$GENERATE" "$(hw_at "$dest" "$HW_TOOLS")/generate-instructions.sh"
	cp "$HW_LIB/frontmatter.sh" "$HW_LIB/paths.sh" "$(hw_at "$dest" "$HW_LIB")/"
	printf 'sentinel\n' >"$(hw_at "$dest" "$HW_CLAUDE_MD")"
}

expect_reject() {
	local dest="$1" label="$2" named="$3"
	local before
	before="$(file_hash "$(hw_at "$dest" "$HW_CLAUDE_MD")")"
	if "$(hw_at "$dest" "$HW_TOOLS")/generate-instructions.sh" >"$dest/run.log" 2>&1; then
		echo "FAIL: $label was accepted"
		fail=1
		return
	fi
	if ! grep -q "$named" "$dest/run.log"; then
		echo "FAIL: $label rejection did not name $named"
		sed 's/^/    /' "$dest/run.log"
		fail=1
	fi
	if [[ "$before" != "$(file_hash "$(hw_at "$dest" "$HW_CLAUDE_MD")")" ]]; then
		echo "FAIL: $label wrote .claude/CLAUDE.md"
		fail=1
	fi
	if find "$(hw_at "$dest" "$HW_CURSOR_RULES")" -name '*.mdc' -type f 2>/dev/null | grep -q .; then
		echo "FAIL: $label wrote a Cursor rule"
		fail=1
	fi
}

bad_name="$WORK/bad-name"
make_copy "$bad_name"
cat >"$(hw_at "$bad_name" "$HW_INSTRUCTIONS")/sample-instruction.md" <<'EOF'
---
name: other-name
description: A description that does not match the filename.
---
# Sample

Body text.
EOF
expect_reject "$bad_name" "a mismatched name" "sample-instruction.md"

bad_key="$WORK/bad-key"
make_copy "$bad_key"
cat >"$(hw_at "$bad_key" "$HW_INSTRUCTIONS")/sample-instruction.md" <<'EOF'
---
name: sample-instruction
description: A description with an unknown key beside it.
alwaysApply: true
---
# Sample

Body text.
EOF
expect_reject "$bad_key" "an unknown frontmatter key" "sample-instruction.md"

empty_body="$WORK/empty-body"
make_copy "$empty_body"
cat >"$(hw_at "$empty_body" "$HW_INSTRUCTIONS")/sample-instruction.md" <<'EOF'
---
name: sample-instruction
description: A description with no body after it.
---
EOF
expect_reject "$empty_body" "an empty body" "sample-instruction.md"

empty_set="$WORK/empty-set"
make_copy "$empty_set"
rm -f "$(hw_at "$empty_set" "$HW_CLAUDE_MD")" "$(hw_at "$empty_set" "$HW_AGENTS_MD")"
if ! "$(hw_at "$empty_set" "$HW_TOOLS")/generate-instructions.sh" >"$empty_set/run.log" 2>&1; then
	echo "FAIL: zero instructions exited non-zero"
	sed 's/^/    /' "$empty_set/run.log"
	fail=1
else
	printf '\n' >"$WORK/one-newline"
	if ! cmp -s "$(hw_at "$empty_set" "$HW_CLAUDE_MD")" "$WORK/one-newline"; then
		echo "FAIL: zero instructions did not write .claude/CLAUDE.md as one newline"
		fail=1
	fi
	if ! cmp -s "$(hw_at "$empty_set" "$HW_COPILOT_MD")" "$WORK/one-newline"; then
		echo "FAIL: zero instructions did not write .github/copilot-instructions.md as one newline"
		fail=1
	fi
	if ! cmp -s "$(hw_at "$empty_set" "$HW_AGENTS_MD")" "$WORK/one-newline"; then
		echo "FAIL: zero instructions did not write AGENTS.md as one newline"
		fail=1
	fi
	if find "$empty_set/.cursor" -name '*.mdc' -type f 2>/dev/null | grep -q .; then
		echo "FAIL: zero instructions wrote a Cursor rule"
		fail=1
	fi
fi

# Two instructions in a copy: bodies join in filename order with one blank line between them.
ordered="$WORK/ordered"
make_copy "$ordered"
rm -f "$(hw_at "$ordered" "$HW_CLAUDE_MD")"
cat >"$(hw_at "$ordered" "$HW_INSTRUCTIONS")/b-instruction.md" <<'EOF'
---
name: b-instruction
description: Second in filename order.
---
# Second
EOF
cat >"$(hw_at "$ordered" "$HW_INSTRUCTIONS")/a-instruction.md" <<'EOF'
---
name: a-instruction
description: First in filename order.
---
# First
EOF
if ! "$(hw_at "$ordered" "$HW_TOOLS")/generate-instructions.sh" >"$ordered/run.log" 2>&1; then
	echo "FAIL: two valid instructions were rejected"
	sed 's/^/    /' "$ordered/run.log"
	fail=1
elif ! cmp -s "$(hw_at "$ordered" "$HW_CLAUDE_MD")" "$(hw_at "$ordered" "$HW_COPILOT_MD")" \
	|| ! cmp -s "$(hw_at "$ordered" "$HW_CLAUDE_MD")" "$(hw_at "$ordered" "$HW_AGENTS_MD")"; then
	echo "FAIL: two-instruction merged files differ"
	fail=1
else
	printf '%s\n' '# First' '' '# Second' >"$WORK/joined"
	if ! cmp -s "$(hw_at "$ordered" "$HW_CLAUDE_MD")" "$WORK/joined" \
		|| ! cmp -s "$(hw_at "$ordered" "$HW_AGENTS_MD")" "$WORK/joined"; then
		echo "FAIL: two instruction bodies were not joined in filename order"
		fail=1
	fi
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: generate-instructions.test.sh"
exit 0
