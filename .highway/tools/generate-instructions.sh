#!/usr/bin/env bash
# Publishes .highway/instructions/<id>.md to the always-on instruction files for Cursor,
# Claude Code, and GitHub Copilot.
#
#   .cursor/rules/<id>.mdc          one always-applied rule per instruction
#   .claude/CLAUDE.md               every body, in filename order
#   .github/copilot-instructions.md the same bytes as .claude/CLAUDE.md
#
# The body is copied unchanged. This generator does not read or write skill sources, skill
# adapters, or speckit-* files, and it never deletes a file.
#
# Usage: .highway/tools/generate-instructions.sh
# Exit 0: every output written or already current.
# Exit 1: a source is invalid, a target is unsafe to overwrite, or the manifest is unreadable.
#         A non-zero exit writes nothing.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
# shellcheck source=tools/lib/frontmatter.sh
source "$SCRIPT_DIR/lib/frontmatter.sh"

INSTRUCTIONS_DIR="$HIGHWAY_ROOT/instructions"
MANIFEST="$HIGHWAY_ROOT/tools/.instruction-manifest"
CLAUDE_REL=".claude/CLAUDE.md"
COPILOT_REL=".github/copilot-instructions.md"
AGENTS_REL="AGENTS.md"

sha256_of() {
	local file="$1"
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$file" | awk '{print $1}'
	else
		shasum -a 256 "$file" | awk '{print $1}'
	fi
}

manifest_get() {
	local rel_path="$1" line
	[[ -f "$MANIFEST" ]] || return 1
	line="$(grep -F "$(printf '%s\t' "$rel_path")" "$MANIFEST" | tail -n1 || true)"
	[[ -n "$line" ]] || return 1
	printf '%s\n' "$line"
}

# Returns 0 when the target may be written. A missing file is safe to create.
check_no_drift() {
	local rel_path="$1" abs_target entry current_hash recorded_hash
	abs_target="$REPO_ROOT/$rel_path"
	[[ -f "$abs_target" ]] || return 0
	if ! entry="$(manifest_get "$rel_path")"; then
		echo "ERROR: '$rel_path' already exists and is not tracked by .highway/tools/.instruction-manifest -- refusing to overwrite a file that may have been hand-authored." >&2
		return 1
	fi
	recorded_hash="$(printf '%s' "$entry" | awk -F '\t' '{print $3}')"
	current_hash="$(sha256_of "$abs_target")"
	if [[ "$current_hash" != "$recorded_hash" ]]; then
		echo "ERROR: '$rel_path' was modified outside .highway/tools/generate-instructions.sh -- refusing to overwrite." >&2
		return 1
	fi
	return 0
}

if [[ -e "$MANIFEST" && ! -r "$MANIFEST" ]]; then
	echo "ERROR: '.highway/tools/.instruction-manifest' is unreadable" >&2
	exit 1
fi

shopt -s nullglob
instr_files=( "$INSTRUCTIONS_DIR"/*.md )
shopt -u nullglob

sorted="$(mktemp)"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"; rm -f "$sorted"' EXIT

invalid=0
if [[ ${#instr_files[@]} -gt 0 ]]; then
	printf '%s\n' "${instr_files[@]}" | LC_ALL=C sort >"$sorted"
	while IFS= read -r src; do
		id="$(basename "$src" .md)"
		rel_src=".highway/instructions/$id.md"
		if [[ ! "$id" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
			echo "ERROR: '$rel_src' id does not match the instruction id pattern" >&2
			invalid=1
			continue
		fi
		key_count="$(fm_list_keys "$src" | wc -l | tr -d ' ')"
		unexpected="$(fm_list_keys "$src" | grep -vxE 'name|description' || true)"
		if [[ "$key_count" -ne 2 || -n "$unexpected" ]]; then
			if [[ -n "$unexpected" ]]; then
				while IFS= read -r extra; do
					[[ -n "$extra" ]] || continue
					echo "ERROR: '$rel_src' has unknown frontmatter key '$extra'" >&2
				done <<<"$unexpected"
			else
				echo "ERROR: '$rel_src' frontmatter must contain only name and description" >&2
			fi
			invalid=1
			continue
		fi
		name="$(fm_get "$src" name || true)"
		if [[ "$name" != "$id" ]]; then
			echo "ERROR: '$rel_src' name '$name' does not equal id '$id'" >&2
			invalid=1
			continue
		fi
		description="$(fm_get "$src" description || true)"
		if [[ -z "$description" ]]; then
			echo "ERROR: '$rel_src' description is missing or empty" >&2
			invalid=1
			continue
		fi
		if [[ "$description" == *\"* ]]; then
			echo "ERROR: '$rel_src' description contains a double quote" >&2
			invalid=1
			continue
		fi
		if ! fm_body "$src" | grep -q '[^[:space:]]'; then
			echo "ERROR: '$rel_src' has an empty body" >&2
			invalid=1
			continue
		fi
	done <"$sorted"
fi
if [[ "$invalid" -ne 0 ]]; then
	exit 1
fi

# Targets, after every source has been accepted.
: >"$stage/targets"
if [[ -s "$sorted" ]]; then
	while IFS= read -r src; do
		id="$(basename "$src" .md)"
		printf '%s\n' ".cursor/rules/$id.mdc" >>"$stage/targets"
	done <"$sorted"
fi
printf '%s\n' "$CLAUDE_REL" "$COPILOT_REL" "$AGENTS_REL" >>"$stage/targets"

drift=0
while IFS= read -r rel_path; do
	[[ -n "$rel_path" ]] || continue
	if ! check_no_drift "$rel_path"; then
		drift=1
	fi
done <"$stage/targets"
if [[ "$drift" -ne 0 ]]; then
	exit 1
fi

# Build every output in the stage directory, then move them into place.
if [[ -s "$sorted" ]]; then
	while IFS= read -r src; do
		id="$(basename "$src" .md)"
		description="$(fm_get "$src" description)"
		cursor_tmp="$stage/cursor-$id.mdc"
		{
			printf '%s\n' '---'
			printf 'description: "%s"\n' "$description"
			printf '%s\n' 'alwaysApply: true' '---'
			fm_body "$src"
		} >"$cursor_tmp"
	done <"$sorted"

	merged_tmp="$stage/merged"
	first=1
	while IFS= read -r src; do
		if [[ "$first" -eq 0 ]]; then
			printf '\n' >>"$merged_tmp"
		fi
		first=0
		fm_body "$src" >>"$merged_tmp"
	done <"$sorted"
	joined_ids=""
	while IFS= read -r src; do
		id="$(basename "$src" .md)"
		if [[ -z "$joined_ids" ]]; then
			joined_ids="$id"
		else
			joined_ids="$joined_ids,$id"
		fi
	done <"$sorted"
else
	merged_tmp="$stage/merged"
	printf '\n' >"$merged_tmp"
	joined_ids="-"
fi

if [[ -s "$sorted" ]]; then
	while IFS= read -r src; do
		id="$(basename "$src" .md)"
		rel_path=".cursor/rules/$id.mdc"
		abs_target="$REPO_ROOT/$rel_path"
		mkdir -p "$(dirname "$abs_target")"
		cp "$stage/cursor-$id.mdc" "$abs_target"
	done <"$sorted"
fi
mkdir -p "$(dirname "$REPO_ROOT/$CLAUDE_REL")" "$(dirname "$REPO_ROOT/$COPILOT_REL")" "$(dirname "$REPO_ROOT/$AGENTS_REL")"
cp "$merged_tmp" "$REPO_ROOT/$CLAUDE_REL"
cp "$merged_tmp" "$REPO_ROOT/$COPILOT_REL"
cp "$merged_tmp" "$REPO_ROOT/$AGENTS_REL"

manifest_tmp="$stage/manifest"
: >"$manifest_tmp"
if [[ -s "$sorted" ]]; then
	while IFS= read -r src; do
		id="$(basename "$src" .md)"
		rel_path=".cursor/rules/$id.mdc"
		printf '%s\t%s\t%s\n' "$rel_path" "$id" "$(sha256_of "$REPO_ROOT/$rel_path")" >>"$manifest_tmp"
	done <"$sorted"
fi
printf '%s\t%s\t%s\n' "$CLAUDE_REL" "$joined_ids" "$(sha256_of "$REPO_ROOT/$CLAUDE_REL")" >>"$manifest_tmp"
printf '%s\t%s\t%s\n' "$COPILOT_REL" "$joined_ids" "$(sha256_of "$REPO_ROOT/$COPILOT_REL")" >>"$manifest_tmp"
printf '%s\t%s\t%s\n' "$AGENTS_REL" "$joined_ids" "$(sha256_of "$REPO_ROOT/$AGENTS_REL")" >>"$manifest_tmp"

# A removed source leaves its Cursor file and its manifest row. Copy those rows forward.
if [[ -f "$MANIFEST" ]]; then
	while IFS="$(printf '\t')" read -r path id hash; do
		[[ -n "$path" ]] || continue
		case "$path" in
			.cursor/rules/*.mdc) ;;
			*) continue ;;
		esac
		if grep -qF "$(printf '%s\t' "$path")" "$manifest_tmp"; then
			continue
		fi
		if [[ -f "$REPO_ROOT/$path" ]]; then
			printf '%s\t%s\t%s\n' "$path" "$id" "$hash" >>"$manifest_tmp"
		fi
	done <"$MANIFEST"
fi
mv "$manifest_tmp" "$MANIFEST"
exit 0
