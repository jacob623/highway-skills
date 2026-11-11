#!/usr/bin/env bash
# Tests that adding a 4th agent requires only a new row in generate-agent-adapters.sh's
# declarative config table, with zero edits to skills/ (FR-004, SC-002).
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
GENERATOR="$HW_FRAMEWORK/generate-agent-adapters.sh"
FIXTURES="$HW_FIXTURES"

TMP_ID="test-newagent-fixture-$$"
SKILL_SRC_DIR="$HW_SKILLS/$TMP_ID"
MOCK_TARGET="$HW_ROOT/.mock-agent-4/skills/$TMP_ID/SKILL.md"
BACKUP="$(mktemp)"

fail=0

skills_snapshot() {
	# Order-independent content snapshot of every file under skills/ (excluding the temp fixture
	# this test itself adds), so we can prove the generator never edits existing skill content.
	find "$HW_SKILLS" -type f ! -path "$SKILL_SRC_DIR/*" -print0 \
		| xargs -0 shasum -a 256 2>/dev/null | sort
}

cleanup() {
	cp "$BACKUP" "$GENERATOR"
	rm -f "$BACKUP"
	rm -rf "$SKILL_SRC_DIR" \
		"$HW_AGENT_COPILOT/$TMP_ID" \
		"$HW_AGENT_CLAUDE/$TMP_ID" \
		"$HW_AGENT_CURSOR/$TMP_ID" \
		"$HW_AGENT_CODEX/$TMP_ID" \
		"$HW_ROOT/.mock-agent-4"
	local manifest="$HW_FRAMEWORK/.adapter-manifest"
	if [[ -f "$manifest" ]]; then
		# The mock agent receives a row for every skill, not only the temporary one.
		grep -vF -e "$TMP_ID" -e ".mock-agent-4/" "$manifest" >"$manifest.tmp" || true
		mv "$manifest.tmp" "$manifest"
	fi
}
trap cleanup EXIT

cp "$GENERATOR" "$BACKUP"

mkdir -p "$SKILL_SRC_DIR"
cp "$FIXTURES/valid-skill/SKILL.md" "$SKILL_SRC_DIR/SKILL.md"
# The fixture's frontmatter name is authored to match the fixture's own directory id
# (`valid-skill`); rewrite it to this temp skill's id so it still satisfies sv_validate_name.
sed -i.bak "s/^name: .*/name: $TMP_ID/" "$SKILL_SRC_DIR/SKILL.md" && rm -f "$SKILL_SRC_DIR/SKILL.md.bak"

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
