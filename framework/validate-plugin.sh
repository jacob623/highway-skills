#!/usr/bin/env bash
# Validates one plugin folder against Agent Plugins 1.0.0, then validates each of its skills against
# Agent Skills through framework/validate-skill.sh.
#
# Usage: framework/validate-plugin.sh <plugin-dir>
#
# Prints one line per finding, manifest first, then layout, then skills:
#   ERROR: [MANIFEST] <field or file>: <problem> (Agent Plugins §<clause>)
#   ERROR: [LAYOUT] <relative path>: <problem> (Agent Plugins §<clause>)
#   ERROR: [SKILL] skills/<name>: <first validator ERROR line>
# then "OK: <plugin-dir> (<n> skill(s))" or "FAIL: <plugin-dir> (<k> finding(s))".
#
# Exit 0: no finding. Exit 1: at least one finding. Exit 2: a usage error, or python3 is
# unavailable.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/paths.sh
source "$SCRIPT_DIR/lib/paths.sh"
# shellcheck source=lib/plugin-manifest.sh
source "$HW_LIB/plugin-manifest.sh"

if [[ $# -ne 1 || ! -d "${1:-}" ]]; then
	echo "Usage: framework/validate-plugin.sh <plugin-dir>" >&2
	exit 2
fi
plugin="${1%/}"
SKILLS_REL="${HW_PLUGIN_SKILLS#"$HW_PLUGIN"/}"
manifest="$plugin/plugin.json"
skills="$plugin/$SKILLS_REL"

findings=0
report() {
	echo "ERROR: $*"
	findings=$((findings + 1))
}

if [[ -L "$manifest" ]]; then
	: # reported as a symbolic link below
elif [[ ! -e "$manifest" ]]; then
	report "[MANIFEST] plugin.json: is missing from the plugin root (Agent Plugins §5.1)"
elif [[ ! -f "$manifest" ]]; then
	report "[MANIFEST] plugin.json: is not a regular file (Agent Plugins §5.1)"
else
	out="$(pm_check "$manifest")"
	status=$?
	if [[ $status -eq 2 ]]; then
		echo "ERROR: [MANIFEST] the JSON parser is unavailable: framework/validate-plugin.sh needs python3"
		exit 2
	fi
	while IFS= read -r line; do
		[[ -n "$line" ]] && report "${line#ERROR: }"
	done <<<"$out"
fi

while IFS= read -r link; do
	[[ -n "$link" ]] && report "[LAYOUT] ${link#"$plugin"/}: is a symbolic link, which may resolve outside the plugin root (Agent Plugins §4.1)"
done < <(find "$plugin" -type l | LC_ALL=C sort)

if [[ -e "$skills" && ! -L "$skills" && ! -d "$skills" ]]; then
	report "[LAYOUT] $SKILLS_REL: is not a folder (Agent Plugins §6.2)"
fi
if [[ -e "$plugin/mcp.json" && ! -L "$plugin/mcp.json" && ! -f "$plugin/mcp.json" ]]; then
	report "[LAYOUT] mcp.json: is not a regular file (Agent Plugins §6.2)"
fi

skill_dirs=()
if [[ -d "$skills" && ! -L "$skills" ]]; then
	while IFS= read -r child; do
		[[ -n "$child" ]] || continue
		rel="$SKILLS_REL/$(basename "$child")"
		if [[ -L "$child" ]]; then
			continue
		elif [[ ! -d "$child" ]]; then
			report "[LAYOUT] $rel: is not a skill folder (Agent Plugins §7.1)"
		elif [[ -L "$child/SKILL.md" || ! -f "$child/SKILL.md" ]]; then
			report "[LAYOUT] $rel: has no SKILL.md (Agent Plugins §7.1)"
		else
			skill_dirs+=("$child")
		fi
	done < <(find "$skills" -mindepth 1 -maxdepth 1 | LC_ALL=C sort)
fi

for child in ${skill_dirs[@]+"${skill_dirs[@]}"}; do
	if ! out="$(bash "$HW_FRAMEWORK/validate-skill.sh" "$child" 2>&1)"; then
		first="$(printf '%s\n' "$out" | grep -m 1 '^ERROR:')"
		report "[SKILL] $SKILLS_REL/$(basename "$child"): ${first#ERROR: }"
	fi
done

if [[ $findings -eq 0 ]]; then
	echo "OK: $plugin (${#skill_dirs[@]} skill(s))"
	exit 0
fi
echo "FAIL: $plugin ($findings finding(s))"
exit 1
