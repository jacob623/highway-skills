#!/usr/bin/env bash
# Fails unless every instruction source has its Cursor rule, a body in both merged files, an
# instruction-manifest row, and an include classification. An output that names an instruction
# with no source fails the same check.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
# shellcheck source=tools/lib/frontmatter.sh
source "$HIGHWAY_ROOT/tools/lib/frontmatter.sh"

MANIFEST="$HIGHWAY_ROOT/tools/.instruction-manifest"
DIST="$HIGHWAY_ROOT/tools/.distribution-manifest"
CLAUDE="$REPO_ROOT/.claude/CLAUDE.md"
COPILOT="$REPO_ROOT/.github/copilot-instructions.md"
fail=0

shopt -s nullglob
sources=( "$HIGHWAY_ROOT"/instructions/*.md )
shopt -u nullglob

if [[ ${#sources[@]} -eq 0 ]]; then
	echo "FAIL: no instructions were found under .highway/instructions/"
	exit 1
fi

if [[ ! -f "$MANIFEST" ]]; then
	echo "FAIL: .highway/tools/.instruction-manifest is absent"
	exit 1
fi

ids=""
sorted_list="$(mktemp)"
printf '%s\n' "${sources[@]}" | LC_ALL=C sort >"$sorted_list"
while IFS= read -r src; do
	id="$(basename "$src" .md)"
	if [[ -z "$ids" ]]; then
		ids="$id"
	else
		ids="$ids,$id"
	fi
done <"$sorted_list"

include_row() {
	local path="$1"
	awk -F '\t' -v path="$path" 'NF && $1 == "include" && $2 == path { found = 1 } END { exit !found }' "$DIST"
}

while IFS= read -r src; do
	id="$(basename "$src" .md)"
	mdc="$REPO_ROOT/.cursor/rules/$id.mdc"
	if [[ ! -f "$mdc" ]]; then
		echo "FAIL: instruction '$id' has no Cursor rule at .cursor/rules/$id.mdc"
		fail=1
		continue
	fi
	fm_body "$src" >"$sorted_list.body"
	awk '
		/^---[[:space:]]*$/ { delim++; next }
		delim >= 2 { print }
	' "$mdc" >"$sorted_list.cursor"
	if ! cmp -s "$sorted_list.body" "$sorted_list.cursor"; then
		echo "FAIL: instruction '$id' Cursor body differs from the source body"
		fail=1
	fi
	if ! grep -qx 'alwaysApply: true' "$mdc"; then
		echo "FAIL: instruction '$id' Cursor rule is missing alwaysApply: true"
		fail=1
	fi
	while IFS= read -r line || [[ -n "$line" ]]; do
		[[ -n "$line" ]] || continue
		if ! grep -qxF -- "$line" "$CLAUDE" || ! grep -qxF -- "$line" "$COPILOT"; then
			echo "FAIL: instruction '$id' body is missing from a merged file"
			fail=1
			break
		fi
	done <"$sorted_list.body"
	if ! awk -F '\t' -v path=".cursor/rules/$id.mdc" -v id="$id" \
		'NF && $1 == path && $2 == id { found = 1 } END { exit !found }' "$MANIFEST"; then
		echo "FAIL: instruction '$id' has no instruction-manifest row for .cursor/rules/$id.mdc"
		fail=1
	fi
	if ! include_row ".cursor/rules/$id.mdc"; then
		echo "FAIL: instruction '$id' Cursor rule is not an include in the distribution manifest"
		fail=1
	fi
done <"$sorted_list"

if ! awk -F '\t' -v path=".claude/CLAUDE.md" -v ids="$ids" \
	'NF && $1 == path && $2 == ids { found = 1 } END { exit !found }' "$MANIFEST"; then
	echo "FAIL: .claude/CLAUDE.md manifest id is not '$ids'"
	fail=1
fi
if ! awk -F '\t' -v path=".github/copilot-instructions.md" -v ids="$ids" \
	'NF && $1 == path && $2 == ids { found = 1 } END { exit !found }' "$MANIFEST"; then
	echo "FAIL: .github/copilot-instructions.md manifest id is not '$ids'"
	fail=1
fi
if ! include_row ".claude/CLAUDE.md"; then
	echo "FAIL: .claude/CLAUDE.md is not an include in the distribution manifest"
	fail=1
fi
if ! include_row ".github/copilot-instructions.md"; then
	echo "FAIL: .github/copilot-instructions.md is not an include in the distribution manifest"
	fail=1
fi

while IFS= read -r row_id; do
	[[ -n "$row_id" && "$row_id" != "-" ]] || continue
	# A merged-file id is a comma-joined list. Split it and require each source.
	rest="$row_id"
	while [[ -n "$rest" ]]; do
		one="${rest%%,*}"
		if [[ "$rest" == *","* ]]; then
			rest="${rest#*,}"
		else
			rest=""
		fi
		if [[ ! -f "$HIGHWAY_ROOT/instructions/$one.md" ]]; then
			echo "FAIL: instruction-manifest id '$one' has no source under .highway/instructions/"
			fail=1
		fi
	done
done < <(awk -F '\t' 'NF { print $2 }' "$MANIFEST")

while IFS= read -r path; do
	[[ -n "$path" ]] || continue
	base="$(basename "$path" .mdc)"
	if [[ ! -f "$HIGHWAY_ROOT/instructions/$base.md" ]]; then
		echo "FAIL: distribution include $path names an instruction with no source"
		fail=1
	fi
done < <(awk -F '\t' 'NF && $1 == "include" && $2 ~ /^\.cursor\/rules\/.*\.mdc$/ { print $2 }' "$DIST")

rm -f "$sorted_list" "$sorted_list.body" "$sorted_list.cursor"

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: instruction-coverage.test.sh"
exit 0
