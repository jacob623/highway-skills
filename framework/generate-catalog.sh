#!/usr/bin/env bash
# Builds catalog/index.json from skills/*/SKILL.md frontmatter, per feature 006 (help skill),
# which supersedes feature 001 (multi-agent skill suite) by adding "usage". The output depends
# only on the skill sources, so unchanged sources produce a byte-identical catalog (D4.2).
#
# Usage: framework/generate-catalog.sh
# Exit 0: catalog written.
# Exit 1: at least one skill under skills/ is invalid; the catalog is NOT written (no partial
#         catalog), and the failing skill's id is named in the error output.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/paths.sh
source "$SCRIPT_DIR/lib/paths.sh"
# shellcheck source=lib/frontmatter.sh
source "$HW_LIB/frontmatter.sh"

SKILLS_DIR="$HW_SKILLS"
CATALOG_DIR="$HW_CATALOG"
CATALOG_JSON="$CATALOG_DIR/index.json"

json_escape() {
	sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

shopt -s nullglob
skill_dirs=("$SKILLS_DIR"/*/)
shopt -u nullglob
skill_count=${#skill_dirs[@]}

# Validate every skill first; no partial catalog on any failure (contract requirement).
invalid_found=0
for ((i = 0; i < skill_count; i++)); do
	dir="${skill_dirs[$i]%/}"
	if ! "$HW_FRAMEWORK/validate-skill.sh" "$dir" >/dev/null 2>/tmp/validate-skill-err.$$; then
		id="$(basename "$dir")"
		echo "ERROR: skill '$id' failed validation; catalog NOT regenerated:" >&2
		cat /tmp/validate-skill-err.$$ >&2
		invalid_found=1
	fi
	rm -f /tmp/validate-skill-err.$$
done
if [[ $invalid_found -ne 0 ]]; then
	exit 1
fi

entries_json=""
first=1
for ((i = 0; i < skill_count; i++)); do
	dir="${skill_dirs[$i]%/}"
	id="$(basename "$dir")"
	skill_file="$dir/SKILL.md"
	name="$(fm_get "$skill_file" name || true)"
	description="$(fm_get "$skill_file" description || true)"
	usage="$(fm_get "$skill_file" usage || true)"
	compatibility="$(fm_get "$skill_file" compatibility || true)"
	[[ -z "$compatibility" ]] && compatibility="all"
	version="$(fm_get_nested "$skill_file" metadata version || true)"
	source_path="skills/$id/SKILL.md"

	entry=$(cat <<-ENTRY
		    {
		      "id": "$(printf '%s' "$id" | json_escape)",
		      "name": "$(printf '%s' "$name" | json_escape)",
		      "description": "$(printf '%s' "$description" | json_escape)",
		      "usage": "$(printf '%s' "$usage" | json_escape)",
		      "compatibility": "$(printf '%s' "$compatibility" | json_escape)",
		      "version": "$(printf '%s' "$version" | json_escape)",
		      "source_path": "$(printf '%s' "$source_path" | json_escape)"
		    }
	ENTRY
	)
	if [[ $first -eq 1 ]]; then
		entries_json="$entry"
		first=0
	else
		entries_json="${entries_json},"$'\n'"$entry"
	fi
done

mkdir -p "$CATALOG_DIR"

{
	echo "{"
	if [[ -z "$entries_json" ]]; then
		echo "  \"entries\": []"
	else
		echo "  \"entries\": ["
		echo "$entries_json"
		echo "  ]"
	fi
	echo "}"
} >"$CATALOG_JSON"

echo "OK: wrote $CATALOG_JSON (${skill_count} skill(s))"
exit 0
