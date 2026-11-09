#!/usr/bin/env bash
# Every skill reaches the repository only through the storage contract, and codify numbers a feature from the product's Features table.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: a temporary skill naming `git commit` must fail P2.6, and removing a storage.md operation row fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-skill.sh"
STORAGE="$HIGHWAY_ROOT/governance/storage.md"
CONSTITUTION="$HIGHWAY_ROOT/governance/constitution.md"
CODIFY="$HIGHWAY_ROOT/skills/highway-codify/SKILL.md"
HELP="$HIGHWAY_ROOT/skills/highway-help/SKILL.md"
METADATA="$HIGHWAY_ROOT/library/templates/output/codify-metadata.md"
CONTEXT="$HIGHWAY_ROOT/instructions/highway-agent-context.md"
fail=0

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

require() {
	local file="$1" text="$2"
	[[ -f "$file" ]] && grep -Fq -- "$text" "$file" || {
		echo "FAIL: ${file#$REPO_ROOT/} omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if [[ -f "$file" ]] && grep -Fq -- "$text" "$file"; then
		echo "FAIL: ${file#$REPO_ROOT/} still contains: $text"
		fail=1
	fi
}

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require_in() {
	local file="$1" heading="$2" text="$3"
	section "$file" "$heading" | grep -Fq -- "$text" || {
		echo "FAIL: ${file#$REPO_ROOT/} $heading omits: $text"
		fail=1
	}
}

# --- The storage contract ---------------------------------------------------------------------

if [[ ! -f "$STORAGE" ]]; then
	echo "FAIL: .highway/governance/storage.md is missing"
	fail=1
fi
require "$STORAGE" '| Operation | Local | Remote (Option A) | Chat (Option B) |'
ops='^\| (Read a file|Check a file exists|List a folder|Write a group of files together) \|'
op_rows="$(grep -cE "$ops" "$STORAGE" 2>/dev/null)"
if [[ "${op_rows:-0}" -ne 4 ]]; then
	echo "FAIL: storage.md has ${op_rows:-0} operation rows, expected 4"
	fail=1
fi
unsupported_rows="$(grep -E "$ops" "$STORAGE" 2>/dev/null | grep -cF '| not supported yet | not supported yet |')"
if [[ "${unsupported_rows:-0}" -ne 4 ]]; then
	echo "FAIL: storage.md has ${unsupported_rows:-0} rows with Remote and Chat not supported yet, expected 4"
	fail=1
fi
for text in \
	'Every path is relative to the repository root.' \
	'Only Local is supported.' \
	'Nothing is committed.' \
	'The person handles any git step.' \
	'A failed write names the files already written and the file that failed.' \
	'Content a skill writes into a file'; do
	require "$STORAGE" "$text"
done

# shellcheck source=tools/lib/distribution.sh
source "$HIGHWAY_ROOT/tools/lib/distribution.sh"
if [[ "$(dist_classify .highway/governance/storage.md)" != "include" ]]; then
	echo "FAIL: .highway/governance/storage.md does not ship"
	fail=1
fi

# --- The rule and its registered check ---------------------------------------------------------

require "$CONSTITUTION" '| P2.6 | A skill MUST reach the repository only through the operations `.highway/governance/storage.md` declares. |'
if ! grep -qE '^\| P2\.6 \|.*\| \[auto\] \|$' "$CONSTITUTION"; then
	echo "FAIL: P2.6 is missing or is not [auto]"
	fail=1
fi
require "$CONSTITUTION" '**Version**: 10.0.0 | **Ratified**: 2026-09-06 | **Last Amended**: 2026-11-09'
require "$CONSTITUTION" 'Version change: 9.1.0 → 10.0.0 (MAJOR), 2026-11-09'

# shellcheck source=tools/lib/body-scan.sh
source "$HIGHWAY_ROOT/tools/lib/body-scan.sh"
# shellcheck source=tools/lib/constitution.sh
source "$HIGHWAY_ROOT/tools/lib/constitution.sh"
# shellcheck source=tools/lib/rule-checks.sh
source "$HIGHWAY_ROOT/tools/lib/rule-checks.sh"
if ! rc_registry | awk -F'\t' '$1 == "P2.6" && $2 == "rc_check_P2_6" && $3 == "-" { f = 1 } END { exit !f }'; then
	echo "FAIL: P2.6 is not registered to rc_check_P2_6"
	fail=1
fi
if ! rc_library_exempt_ids | grep -qx 'P2.6'; then
	echo "FAIL: P2.6 is not library-exempt"
	fail=1
fi

# Writes a conforming skill whose Inputs section holds the seeded text.
write_seeded_skill() {
	local dir="$1" seed="$2" id
	id="$(basename "$dir")"
	mkdir -p "$dir"
	SEED="$seed" ID="$id" awk '{ if ($0 == "@SEED@") print ENVIRON["SEED"]; else { gsub(/@ID@/, ENVIRON["ID"]); print } }' >"$dir/SKILL.md" <<'EOF'
---
name: @ID@
description: "Conforming baseline that each case mutates to seed exactly one violation."
usage: "Not invoked directly; used only as a seed fixture for rule-checks.test.sh."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose
Provide a conforming baseline that each test case mutates.

## When to use
- Use when seeding a violation of one rule.
- Use when confirming the reported rule id.

## When not to use
Never use for real work.

## Inputs
@SEED@

## Outputs
A confirmation message.

## Verification
Confirm the output names the violated rule id.

## Error Handling
- If no rule id is reported, abort and report the missed detection.

## Example
`/@ID@`
EOF
}

case_n=0
expect_fail() {
	local name="$1" seed="$2" dir out
	case_n=$((case_n + 1))
	dir="$tmp_root/storage-fail-$case_n"
	write_seeded_skill "$dir" "$seed"
	out="$("$VALIDATE" --no-cache "$dir" 2>&1)"
	if [[ "$out" != *"ERROR: [P2.6]"* ]]; then
		echo "FAIL[$name]: expected a P2.6 finding. Got:"
		printf '%s\n' "$out" | grep -E '^(ERROR|FAILED|OK)' | sed 's/^/    /'
		fail=1
	fi
}

expect_pass() {
	local name="$1" seed="$2" dir out
	case_n=$((case_n + 1))
	dir="$tmp_root/storage-pass-$case_n"
	write_seeded_skill "$dir" "$seed"
	out="$("$VALIDATE" --no-cache "$dir" 2>&1)"
	if [[ "$out" == *"[P2.6]"* || "$out" != *"OK: skill"* ]]; then
		echo "FAIL[$name]: expected the skill to pass. Got:"
		printf '%s\n' "$out" | grep -E '^(ERROR|FAILED|OK)' | sed 's/^/    /'
		fail=1
	fi
}

expect_fail 'tools script' 'Run `.highway/tools/generate-catalog.sh` before reading the catalog.'
expect_fail 'script file' 'Run `bash scripts/build.sh` first.'
expect_fail 'git command' 'Commit the records with `git commit`.'
expect_fail 'absolute path' 'Read `/Users/someone/project/notes.md` first.'
expect_fail 'home path' 'Read `~/notes/plan.md` first.'
expect_fail 'file time' "Pick the record with the newest modified time."

expect_pass 'slash command' 'Invoke `/highway-help highway-help` for details.'
expect_pass 'url' 'Read https://example.com/docs/path for the vendor guide.'
expect_pass 'gitignore' 'The task writes `.gitignore` for the product.'
expect_pass 'GitHub' 'The proposal names GitHub Actions as the pipeline.'
expect_pass 'no timestamp' 'Emit no timestamp, random value, or environment value.'
expect_pass 'fenced content' "$(printf '%s\n' 'The pipeline file reads:' '' '```yaml' 'steps:' '  - run: git push' '  - run: ./build.sh' '```')"

# Every shipped skill passes the check.
for skill in "$HIGHWAY_ROOT"/skills/*/SKILL.md; do
	if ! type rc_check_P2_6 >/dev/null 2>&1; then
		echo "FAIL: rc_check_P2_6 is not defined"
		fail=1
		break
	fi
	out="$(rc_check_P2_6 "$skill")"
	if [[ $? -eq 1 ]]; then
		echo "FAIL: ${skill#$REPO_ROOT/} fails P2.6:"
		printf '%s\n' "$out" | sed 's/^/    /'
		fail=1
	fi
done

# --- highway-help ---------------------------------------------------------------------------------

require "$HELP" '- `.highway/catalog/index.json` — read for'
require "$HELP" "\`ERROR: the skill catalog '.highway/catalog/index.json' is missing or unreadable\`"
reject "$HELP" '.highway/tools/'
require "$HELP" 'version: 3.1.0'

# --- highway-codify numbers from the Features table ------------------------------------------------

require_in "$CODIFY" '## Inputs' "- The product's \`code/<folder>/.highway/metadata.md\` when a proposal joins an existing product."
require_in "$CODIFY" '## Outputs' '- One product folder `code/<folder>/`, with `.highway/metadata.md` written when the product is new. Each accepted feature adds one row to its Features table.'
require_in "$CODIFY" '### write' 'For a joined product, it is the next integer after the last ID in the Features table of `code/<folder>/.highway/metadata.md`. Do not list `code/<folder>/.highway/features/`.'
require_in "$CODIFY" '### write' "Append this feature's row to its Features table."
require_in "$CODIFY" '## Verification' '- Each accepted action is the next numbered feature directory in its product, numbered from the last row of the Features table in `.highway/metadata.md`. No features folder is listed. Earlier directories stay.'
require_in "$CODIFY" '## Verification' '- Each accepted feature adds one Features row with its number, folder, title, and Summary. A row is never removed.'
require_in "$CODIFY" '## Verification' "- Acceptance writes \`codify.md\`, the product's \`metadata.md\` with the new Features row, the catalog row, and any new integrations row together, then \`plan.md\`."
reject "$CODIFY" 'the highest directory in'
reject "$CODIFY" 'written once'
require "$CODIFY" 'version: 14.1.0'
write_words="$(section "$CODIFY" '### write' | wc -w | tr -d ' ')"
if [[ "$write_words" -gt 250 ]]; then
	echo "FAIL: highway-codify write has $write_words words; the limit is 250"
	fail=1
fi

require "$METADATA" '## Features'
require "$METADATA" '| ID | Folder | Title | Summary |'
require "$METADATA" 'A row is appended and never removed or changed, so an ID is never reused.'
require "$METADATA" 'The next feature number is the next integer after the last ID.'
require "$METADATA" 'Features has no status column.'
require "$METADATA" 'Title and Summary are copied when the feature is accepted.'
reject "$METADATA" 'written once'
require "$METADATA" 'version: 2.0.0'

# --- The agent context points to the contract -------------------------------------------------------

require "$CONTEXT" '- Read and write the repository only through the operations in'
for generated in AGENTS.md .claude/CLAUDE.md .github/copilot-instructions.md .cursor/rules/highway-agent-context.mdc; do
	require "$REPO_ROOT/$generated" '`.highway/governance/storage.md`.'
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: every skill reaches the repository only through the storage contract'
