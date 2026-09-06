#!/usr/bin/env bash
# Tests that adding a 4th agent requires only a new row in generate-agent-adapters.sh's
# declarative config table, with zero edits to skills/ (FR-004, SC-002).
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# HIGHWAY_ROOT (.highway/) holds the generator + skill sources; REPO_ROOT (one level up) is
# where agent adapters are actually written -- see specs/002-highway-folder-consolidation/research.md.
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
GENERATOR="$HIGHWAY_ROOT/tools/generate-agent-adapters.sh"
FIXTURES="$SCRIPT_DIR/fixtures"

TMP_ID="test-newagent-fixture-$$"
SKILL_SRC_DIR="$HIGHWAY_ROOT/skills/$TMP_ID"
MOCK_TARGET="$REPO_ROOT/.mock-agent-4/skills/$TMP_ID/SKILL.md"
BACKUP="$(mktemp)"

fail=0

skills_snapshot() {
	# Order-independent content snapshot of every file under skills/ (excluding the temp fixture
	# this test itself adds), so we can prove the generator never edits existing skill content.
	find "$HIGHWAY_ROOT/skills" -type f ! -path "$SKILL_SRC_DIR/*" -print0 \
		| xargs -0 shasum -a 256 2>/dev/null | sort
}

cleanup() {
	cp "$BACKUP" "$GENERATOR"
	rm -f "$BACKUP"
	rm -rf "$SKILL_SRC_DIR" \
		"$REPO_ROOT/.github/skills/$TMP_ID" \
		"$REPO_ROOT/.claude/skills/$TMP_ID" \
		"$REPO_ROOT/.cursor/rules/$TMP_ID.mdc" \
		"$REPO_ROOT/.mock-agent-4"
	local manifest="$HIGHWAY_ROOT/tools/.adapter-manifest"
	if [[ -f "$manifest" ]]; then
		grep -vF "$TMP_ID" "$manifest" >"$manifest.tmp" || true
		mv "$manifest.tmp" "$manifest"
	fi
}
trap cleanup EXIT

cp "$GENERATOR" "$BACKUP"

mkdir -p "$SKILL_SRC_DIR"
cp "$FIXTURES/valid-skill/SKILL.md" "$SKILL_SRC_DIR/SKILL.md"

skills_before="$(skills_snapshot)"

# Add one row for a temporary 4th mock agent -- the only edit required to support a new agent.
sed -i.sedbak \
	-e 's/^AGENT_IDS=(\(.*\))$/AGENT_IDS=(\1 mock-agent-4)/' \
	-e 's/^AGENT_TARGET_TEMPLATES=(\(.*\))$/AGENT_TARGET_TEMPLATES=(\1 ".mock-agent-4\/skills\/%s\/SKILL.md")/' \
	-e 's/^AGENT_TRANSFORMS=(\(.*\))$/AGENT_TRANSFORMS=(\1 identity-copy)/' \
	"$GENERATOR"
rm -f "$GENERATOR.sedbak"

if ! "$GENERATOR" >/tmp/new-agent-test.$$.log 2>&1; then
	echo "FAIL: generator exited non-zero after adding a 4th agent row"
	cat /tmp/new-agent-test.$$.log
	fail=1
fi
rm -f /tmp/new-agent-test.$$.log

if [[ ! -f "$MOCK_TARGET" ]] || ! diff -q "$SKILL_SRC_DIR/SKILL.md" "$MOCK_TARGET" >/dev/null 2>&1; then
	echo "FAIL: 4th-agent adapter was not produced correctly at $MOCK_TARGET"
	fail=1
fi

skills_after="$(skills_snapshot)"
if [[ "$skills_before" != "$skills_after" ]]; then
	echo "FAIL: existing content under skills/ changed as a result of adding a new agent"
	fail=1
fi

exit $fail
