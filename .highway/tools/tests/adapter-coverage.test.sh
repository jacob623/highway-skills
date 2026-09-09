#!/usr/bin/env bash
# Fails when the generated artifacts stop agreeing with the skills actually present.
#
# Three obligations, in three directions (D4.5, D4.6, D4.7):
#
#   D4.5  every skill has its artifacts      -- a missing one makes the skill invisible
#   D4.6  no artifact names an absent skill  -- an orphan ships a skill nobody can maintain
#   D4.7  artifacts match current sources    -- a stale one reports confidently and wrongly
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
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
# shellcheck source=tools/lib/distribution.sh
source "$HIGHWAY_ROOT/tools/lib/distribution.sh"
fail=0

CATALOG="$HIGHWAY_ROOT/catalog/index.json"
ADAPTER_MANIFEST="$HIGHWAY_ROOT/tools/.adapter-manifest"
DIST_MANIFEST="$HIGHWAY_ROOT/tools/.distribution-manifest"

# Every adapter path a skill is expected to have, derived from the skill id.
adapter_paths() {
	local id="$1"
	printf '%s\n' \
		".github/skills/$id" \
		".claude/skills/$id" \
		".cursor/rules/$id.mdc"
}

# The file each adapter path resolves to. Two of the three are directories holding a SKILL.md.
adapter_files() {
	local id="$1"
	printf '%s\n' \
		".github/skills/$id/SKILL.md" \
		".claude/skills/$id/SKILL.md" \
		".cursor/rules/$id.mdc"
}

skill_exists() {
	[[ -f "$HIGHWAY_ROOT/skills/$1/SKILL.md" ]]
}

catalog_ids() {
	grep -o '"id": "[^"]*"' "$CATALOG" 2>/dev/null | sed 's/.*"id": "//;s/"$//'
}

# ---------------------------------------------------------------------------
# D4.5 -- every skill present has its generated artifacts.
# ---------------------------------------------------------------------------
skill_count=0
for skill_dir in "$HIGHWAY_ROOT"/skills/*/; do
	[[ -f "$skill_dir/SKILL.md" ]] || continue
	skill_id="$(basename "$skill_dir")"
	skill_count=$((skill_count + 1))

	if ! catalog_ids | grep -qx "$skill_id"; then
		echo "FAIL: skill '$skill_id' has no entry in the catalog"
		fail=1
	fi

	while IFS= read -r rel; do
		if [[ ! -f "$REPO_ROOT/$rel" ]]; then
			echo "FAIL: skill '$skill_id' has no adapter at $rel"
			fail=1
		fi
	done < <(adapter_files "$skill_id")

	while IFS= read -r adapter; do
		if [[ "$(dist_classify "$adapter")" != "include" ]]; then
			echo "FAIL: skill '$skill_id' would not reach users; $adapter is not included by the distribution manifest"
			fail=1
		fi
	done < <(adapter_paths "$skill_id")

	# Without a manifest row the generator has no hash to compare against, so a hand-edited
	# adapter for this skill would be silently overwritten instead of refused.
	while IFS= read -r rel; do
		if ! awk 'NF {print $1}' "$ADAPTER_MANIFEST" | grep -qxF "$rel"; then
			echo "FAIL: skill '$skill_id' has no adapter manifest row for $rel"
			fail=1
		fi
	done < <(adapter_files "$skill_id")
done

# A loop that iterates nothing passes silently, which is the failure this whole check is about.
if [[ "$skill_count" -eq 0 ]]; then
	echo "FAIL: no skills were found under .highway/skills/; the check matched nothing"
	fail=1
fi

# ---------------------------------------------------------------------------
# D4.6 -- no generated artifact names a skill that is gone.
#
# Adapter directories are not scanned wholesale: the agent trees also hold skills this repository
# does not generate, and flagging those as orphans would be wrong. The manifests record what the
# generator produced, so they are the authority on which adapters are ours.
# ---------------------------------------------------------------------------
while IFS= read -r id; do
	[[ -n "$id" ]] || continue
	if ! skill_exists "$id"; then
		echo "FAIL: catalog entry '$id' names a skill with no directory under skills/"
		fail=1
	fi
done < <(catalog_ids)

while IFS= read -r row_id; do
	[[ -n "$row_id" ]] || continue
	if ! skill_exists "$row_id"; then
		echo "FAIL: adapter manifest row names skill '$row_id', which has no directory under skills/"
		fail=1
	fi
done < <(awk 'NF {print $2}' "$ADAPTER_MANIFEST" | sort -u)

while IFS= read -r path; do
	[[ -n "$path" ]] || continue
	case "$path" in
		.github/skills/*) row_id="${path#.github/skills/}" ;;
		.claude/skills/*) row_id="${path#.claude/skills/}" ;;
		.cursor/rules/*.mdc) row_id="${path#.cursor/rules/}"; row_id="${row_id%.mdc}" ;;
		*) continue ;;
	esac
	row_id="${row_id%%/*}"
	if ! skill_exists "$row_id"; then
		echo "FAIL: distribution manifest row $path names a skill with no directory under skills/"
		fail=1
	fi
done < <(awk 'NF && $1 == "include" {print $2}' "$DIST_MANIFEST")

# Every adapter file the manifest claims must still be on disk, or a skill is half-removed.
while IFS= read -r rel; do
	[[ -n "$rel" ]] || continue
	case "$rel" in
		.github/*|.claude/*|.cursor/*) ;;
		*) continue ;;  # fixture agent trees are not declared agent trees
	esac
	if [[ ! -f "$REPO_ROOT/$rel" ]]; then
		echo "FAIL: adapter manifest names $rel, which is not on disk"
		fail=1
	fi
done < <(awk 'NF {print $1}' "$ADAPTER_MANIFEST")

# ---------------------------------------------------------------------------
# D4.7 -- the generated artifacts match what the current sources would produce.
#
# Regeneration happens inside a copy of the framework tree, never in place: the generators
# resolve every path from their own location, so a copy is self-contained. Checking currency by
# regenerating the real tree and restoring afterwards would leave the repository modified
# whenever this check exited between those two steps.
# ---------------------------------------------------------------------------
CURRENCY_TMP=""
cleanup() {
	if [[ -n "$CURRENCY_TMP" && -d "$CURRENCY_TMP" ]]; then
		rm -rf "$CURRENCY_TMP"
	fi
}
trap cleanup EXIT

# A recorded generation timestamp differs on every run; D4.2's Observable excepts it, and D4.7
# inherits that exception.
strip_timestamp() {
	grep -v 'generated_at' "$1" 2>/dev/null | grep -v '_Generated at:'
}

CURRENCY_TMP="$(mktemp -d)"
cp -R "$HIGHWAY_ROOT" "$CURRENCY_TMP/.highway"
(
	cd "$CURRENCY_TMP" || exit 1
	.highway/tools/generate-catalog.sh
	.highway/tools/generate-library-catalog.sh
	.highway/tools/generate-agent-adapters.sh
) >/dev/null 2>&1

for rel in catalog/index.json catalog/index.md catalog/library-index.json catalog/library-index.md; do
	if ! diff <(strip_timestamp "$HIGHWAY_ROOT/$rel") <(strip_timestamp "$CURRENCY_TMP/.highway/$rel") >/dev/null 2>&1; then
		echo "FAIL: .highway/$rel is stale; regenerating from current sources produces a different file"
		fail=1
	fi
done

for skill_dir in "$HIGHWAY_ROOT"/skills/*/; do
	[[ -f "$skill_dir/SKILL.md" ]] || continue
	skill_id="$(basename "$skill_dir")"
	while IFS= read -r rel; do
		[[ -f "$REPO_ROOT/$rel" ]] || continue
		if ! diff "$REPO_ROOT/$rel" "$CURRENCY_TMP/$rel" >/dev/null 2>&1; then
			echo "FAIL: $rel is stale; regenerating skill '$skill_id' produces a different adapter"
			fail=1
		fi
	done < <(adapter_files "$skill_id")
done

exit $fail
