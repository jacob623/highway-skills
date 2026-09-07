#!/usr/bin/env bash
# Regenerates the per-agent adapters for every valid skill under skills/ into
# .github/skills/<id>/SKILL.md, .claude/skills/<id>/SKILL.md, and .cursor/rules/<id>.mdc, per
# specs/009-skill-id-namespace-alignment/contracts/agent-adapter-contract.md. <id> is already
# the full agent-facing identifier (e.g. highway-help) -- this generator injects no namespace
# prefix of its own; the prefix lives once, at the source directory name.
#
# Usage: .highway/tools/generate-agent-adapters.sh
# Exit 0: all adapters (re)generated / confirmed up to date.
# Exit 1: a skill fails validation (no partial adapter set written), or a target file was
#         hand-edited outside this generator (refuses to overwrite, names the file).
#
# Declarative per-agent config (FR-004/FR-008: adding an agent = one new row here, never an
# edit to skills/).
AGENT_IDS=(github-copilot claude-code cursor)
AGENT_TARGET_TEMPLATES=(".github/skills/%s/SKILL.md" ".claude/skills/%s/SKILL.md" ".cursor/rules/%s.mdc")
AGENT_TRANSFORMS=(identity-copy identity-copy mdc-transform)

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# HIGHWAY_ROOT is the .highway/ framework root (holds skill sources + the manifest); REPO_ROOT
# is the true repository root, one level further up, used only for agent adapter target paths.
# The two differ since the .highway/ consolidation (specs/002-highway-folder-consolidation/research.md
# Decision 1) -- do not conflate them.
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
# shellcheck source=tools/lib/frontmatter.sh
source "$SCRIPT_DIR/lib/frontmatter.sh"

SKILLS_DIR="$HIGHWAY_ROOT/skills"
MANIFEST="$HIGHWAY_ROOT/tools/.adapter-manifest"

target_path_for() {
	local template="$1" id="$2"
	printf "$template" "$id"
}

sha256_of() {
	local file="$1"
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$file" | awk '{print $1}'
	else
		shasum -a 256 "$file" | awk '{print $1}'
	fi
}

manifest_get() {
	local rel_path="$1"
	[[ -f "$MANIFEST" ]] || return 1
	grep -F "$(printf '%s\t' "$rel_path")" "$MANIFEST" | tail -n1
}

manifest_set() {
	local rel_path="$1" skill_id="$2" skill_version="$3" hash="$4"
	local tmp
	tmp="$(mktemp)"
	[[ -f "$MANIFEST" ]] && grep -vF "$(printf '%s\t' "$rel_path")" "$MANIFEST" >"$tmp"
	printf '%s\t%s\t%s\t%s\n' "$rel_path" "$skill_id" "$skill_version" "$hash" >>"$tmp"
	mv "$tmp" "$MANIFEST"
}

# Refuses to overwrite a target that drifted from what this generator last produced.
# Returns 0 if safe to write, 1 if it must refuse.
check_no_drift() {
	local abs_target="$1" rel_path="$2"
	[[ -f "$abs_target" ]] || return 0
	local entry current_hash recorded_hash
	entry="$(manifest_get "$rel_path")"
	if [[ -z "$entry" ]]; then
		echo "ERROR: '$rel_path' already exists and is not tracked by .highway/tools/.adapter-manifest -- refusing to overwrite a file that may have been hand-authored. Remove it manually if it is safe to regenerate." >&2
		return 1
	fi
	recorded_hash="$(printf '%s' "$entry" | awk -F'\t' '{print $4}')"
	current_hash="$(sha256_of "$abs_target")"
	if [[ "$current_hash" != "$recorded_hash" ]]; then
		echo "ERROR: '$rel_path' was modified outside .highway/tools/generate-agent-adapters.sh -- refusing to overwrite. Restore it from the generator's output or remove it manually." >&2
		return 1
	fi
	return 0
}

# Writes a target by copying a source file byte-for-byte (no command-substitution round trip,
# which would strip trailing newlines and break the byte-identical guarantee).
write_target_from_file() {
	local abs_target="$1" rel_path="$2" skill_id="$3" skill_version="$4" src_file="$5"
	mkdir -p "$(dirname "$abs_target")"
	cp "$src_file" "$abs_target"
	manifest_set "$rel_path" "$skill_id" "$skill_version" "$(sha256_of "$abs_target")"
}

# Writes a target from an in-memory content string (used for transforms, e.g. mdc-transform).
write_target_from_content() {
	local abs_target="$1" rel_path="$2" skill_id="$3" skill_version="$4" content="$5"
	mkdir -p "$(dirname "$abs_target")"
	printf '%s\n' "$content" >"$abs_target"
	manifest_set "$rel_path" "$skill_id" "$skill_version" "$(sha256_of "$abs_target")"
}

transform_mdc() {
	local skill_file="$1" description body
	description="$(grep -E '^description:' "$skill_file" | head -n1)"
	body="$(fm_body "$skill_file")"
	printf -- '---\n%s\nalwaysApply: false\n---\n%s' "$description" "$body"
}

shopt -s nullglob
skill_dirs=("$SKILLS_DIR"/*/)
shopt -u nullglob
skill_count=${#skill_dirs[@]}

# Validate every skill first; no partial adapter set on any failure (contract requirement).
invalid_found=0
for ((i = 0; i < skill_count; i++)); do
	dir="${skill_dirs[$i]%/}"
	if ! "$SCRIPT_DIR/validate-skill.sh" "$dir" >/dev/null 2>/tmp/validate-skill-err.$$; then
		id="$(basename "$dir")"
		echo "ERROR: skill '$id' failed validation; aborting adapter generation for all skills:" >&2
		cat /tmp/validate-skill-err.$$ >&2
		invalid_found=1
	fi
	rm -f /tmp/validate-skill-err.$$
done
if [[ $invalid_found -ne 0 ]]; then
	exit 1
fi

drift_found=0
for ((i = 0; i < skill_count; i++)); do
	dir="${skill_dirs[$i]%/}"
	id="$(basename "$dir")"
	skill_file="$dir/SKILL.md"
	version="$(fm_get_nested "$skill_file" metadata version || true)"

	for j in "${!AGENT_IDS[@]}"; do
		rel_path="$(target_path_for "${AGENT_TARGET_TEMPLATES[$j]}" "$id")"
		abs_target="$REPO_ROOT/$rel_path"
		if ! check_no_drift "$abs_target" "$rel_path"; then
			drift_found=1
			continue
		fi
	done
done
if [[ $drift_found -ne 0 ]]; then
	exit 1
fi

for ((i = 0; i < skill_count; i++)); do
	dir="${skill_dirs[$i]%/}"
	id="$(basename "$dir")"
	skill_file="$dir/SKILL.md"
	version="$(fm_get_nested "$skill_file" metadata version || true)"

	for j in "${!AGENT_IDS[@]}"; do
		transform="${AGENT_TRANSFORMS[$j]}"
		rel_path="$(target_path_for "${AGENT_TARGET_TEMPLATES[$j]}" "$id")"
		abs_target="$REPO_ROOT/$rel_path"
		case "$transform" in
			identity-copy)
				write_target_from_file "$abs_target" "$rel_path" "$id" "$version" "$skill_file"
				;;
			mdc-transform)
				content="$(transform_mdc "$skill_file")"
				write_target_from_content "$abs_target" "$rel_path" "$id" "$version" "$content"
				;;
			*)
				echo "ERROR: unknown transform '$transform' for agent '${AGENT_IDS[$j]}'" >&2
				exit 1
				;;
		esac
		echo "Generated $rel_path (${AGENT_IDS[$j]}, $transform)"
	done
done

exit 0
