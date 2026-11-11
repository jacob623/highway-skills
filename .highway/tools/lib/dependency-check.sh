#!/usr/bin/env bash
# Checks a skill's metadata.dependencies entries against the shared content files they name.
# Requires frontmatter.sh to be sourced first.
#
# Two failure outcomes, both printed with no rule-id prefix (validate-skill.sh tags them
# [DEPENDENCY]): a path that does not exist, or a pinned version that no longer matches the
# target's current metadata.version. See
# feature 004 (shared content library).

[[ -n "${HW_ROOT:-}" ]] || source "$(dirname "${BASH_SOURCE[0]}")/paths.sh"

# Usage: dc_validate_dependencies <skill_file> <root>
# Prints zero or more finding messages (one per line). Returns 1 if any were printed, else 0.
dc_validate_dependencies() {
	local skill_file="$1" root="$2" found=0
	local path version target_file target_version
	while IFS='|' read -r path version; do
		[[ -z "$path" ]] && continue
		target_file="$(hw_at "$root" "$HW_FRAMEWORK")/$path"
		if [[ ! -f "$target_file" ]]; then
			echo "dependency '$path' does not exist"
			found=1
			continue
		fi
		target_version="$(fm_get_nested "$target_file" metadata version || true)"
		if [[ "$target_version" != "$version" ]]; then
			echo "dependency '$path' pinned at version $version, current version is $target_version"
			found=1
		fi
	done <<< "$(fm_get_dependencies "$skill_file")"
	return $found
}
