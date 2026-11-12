#!/usr/bin/env bash
# Builds highway-help's assets/index.json from skills/*/SKILL.md: one entry per skill with every
# value highway-help prints, so highway-help reads nothing outside its own folder. The output
# depends only on the skill sources, so unchanged sources produce a byte-identical index (D4.2).
#
# Usage: framework/generate-catalog.sh
# Exit 0: index written.
# Exit 1: at least one skill under skills/ is invalid; the index is NOT written (no partial
#         index), and the failing skill's id is named in the error output. A name that differs
#         from its folder is such a failure, through validate-skill.sh.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/paths.sh
source "$SCRIPT_DIR/lib/paths.sh"
# shellcheck source=lib/frontmatter.sh
source "$HW_LIB/frontmatter.sh"

SKILLS_DIR="$HW_SKILLS"
CATALOG_JSON="$HW_HELP_INDEX"

json_escape() {
	sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

# Prints the JSON array of a skill's metadata.dependencies as "<path>@<version>" strings.
dependencies_json() {
	local out="" path version
	while IFS='|' read -r path version; do
		[[ -z "$path" ]] && continue
		[[ -n "$out" ]] && out="$out, "
		out="$out\"$(printf '%s@%s' "$path" "$version" | json_escape)\""
	done <<< "$(fm_get_dependencies "$1")"
	printf '[%s]' "$out"
}

# Prints the first line under "## Example" that is one inline code span, without its backticks.
example_of() {
	awk '
		/^## / { inside = ($0 ~ /^## Example[[:space:]]*$/); next }
		inside && /^`[^`]+`[[:space:]]*$/ { sub(/[[:space:]]*$/, ""); print substr($0, 2, length($0) - 2); exit }
	' "$1"
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
	version="$(fm_get_nested "$skill_file" metadata version || true)"
	dependencies="$(dependencies_json "$skill_file")"
	example="$(example_of "$skill_file")"

	entry=$(cat <<-ENTRY
		    {
		      "id": "$(printf '%s' "$id" | json_escape)",
		      "name": "$(printf '%s' "$name" | json_escape)",
		      "description": "$(printf '%s' "$description" | json_escape)",
		      "usage": "$(printf '%s' "$usage" | json_escape)",
		      "version": "$(printf '%s' "$version" | json_escape)",
		      "dependencies": $dependencies,
		      "example": "$(printf '%s' "$example" | json_escape)"
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

mkdir -p "$(dirname "$CATALOG_JSON")"

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
