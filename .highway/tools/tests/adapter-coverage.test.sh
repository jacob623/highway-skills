#!/usr/bin/env bash
# Fails when a skill's agent adapters would not reach a user.
#
# The distribution manifest classifies adapters by exact path: the agent directories are excluded
# by default and each skill's adapters are included by a more specific row. A skill added without
# those rows still ships its source, and its adapters are silently dropped -- the paths are
# classified, so the unclassified-path check passes and packaging reports success. The recipient
# receives a skill their agent cannot see.
#
# This check exists because that is invisible in the development tree, where every adapter is
# present regardless of what the manifest says.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# shellcheck source=tools/lib/distribution.sh
source "$HIGHWAY_ROOT/tools/lib/distribution.sh"
fail=0

# Every adapter path a skill is expected to have, derived from the skill id.
adapter_paths() {
	local id="$1"
	printf '%s\n' \
		".github/skills/$id" \
		".claude/skills/$id" \
		".cursor/rules/$id.mdc"
}

skill_count=0
for skill_dir in "$HIGHWAY_ROOT"/skills/*/; do
	[[ -f "$skill_dir/SKILL.md" ]] || continue
	skill_id="$(basename "$skill_dir")"
	skill_count=$((skill_count + 1))
	while IFS= read -r adapter; do
		if [[ "$(dist_classify "$adapter")" != "include" ]]; then
			echo "FAIL: skill '$skill_id' would not reach users; $adapter is not included by the distribution manifest"
			fail=1
		fi
	done < <(adapter_paths "$skill_id")
done

# A loop that iterates nothing passes silently, which is the failure this whole check is about.
if [[ "$skill_count" -eq 0 ]]; then
	echo "FAIL: no skills were found under .highway/skills/; the check matched nothing"
	fail=1
fi

exit $fail
