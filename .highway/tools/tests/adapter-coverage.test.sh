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
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact
# Seeded failure probe: --probe <class> seeds a defect and observes detection; --probe <class>
# --neutralise runs the identical path unseeded and requires a clean pass. See the Feature 041
# probe-mode contract.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
# shellcheck source=tools/lib/distribution.sh
source "$HIGHWAY_ROOT/tools/lib/distribution.sh"
fail=0

CATALOG="$HIGHWAY_ROOT/catalog/index.json"
ADAPTER_MANIFEST="$HIGHWAY_ROOT/tools/.adapter-manifest"
DIST_MANIFEST="$HIGHWAY_ROOT/tools/.distribution-manifest"

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document generated-artifact "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

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

# All D4.5/D4.6 correspondence checks for one skill: catalog entry, adapter files, distribution
# inclusion, and adapter manifest rows. Echoes FAIL lines and returns non-zero if any problem is
# found. Shared by normal mode's per-skill loop and probe mode's seeded single-skill check.
check_skill_correspondence() {
	local skill_id="$1" ok=0
	if ! catalog_ids | grep -qx "$skill_id"; then
		echo "FAIL: skill '$skill_id' has no entry in the catalog"
		ok=1
	fi

	while IFS= read -r rel; do
		if [[ ! -f "$REPO_ROOT/$rel" ]]; then
			echo "FAIL: skill '$skill_id' has no adapter at $rel"
			ok=1
		fi
	done < <(adapter_files "$skill_id")

	while IFS= read -r adapter; do
		if [[ "$(dist_classify "$adapter")" != "include" ]]; then
			echo "FAIL: skill '$skill_id' would not reach users; $adapter is not included by the distribution manifest"
			ok=1
		fi
	done < <(adapter_paths "$skill_id")

	while IFS= read -r rel; do
		if ! awk 'NF {print $1}' "$ADAPTER_MANIFEST" | grep -qxF "$rel"; then
			echo "FAIL: skill '$skill_id' has no adapter manifest row for $rel"
			ok=1
		fi
	done < <(adapter_files "$skill_id")

	return $ok
}

# A recorded generation timestamp differs on every run; D4.2's Observable excepts it, and D4.7
# inherits that exception.
strip_timestamp() {
	grep -v 'generated_at' "$1" 2>/dev/null | grep -v '_Generated at:'
}

# Every adapter of one skill matches what regenerating from current sources would produce.
# Echoes FAIL lines and returns non-zero if any adapter is stale. Shared by normal mode's per-skill
# loop (against the real, once-built currency tree) and probe mode's seeded single-skill check.
skill_currency_ok() {
	local skill_id="$1" currency_root="$2" ok=0
	while IFS= read -r rel; do
		[[ -f "$REPO_ROOT/$rel" ]] || continue
		if ! diff "$REPO_ROOT/$rel" "$currency_root/$rel" >/dev/null 2>&1; then
			echo "FAIL: $rel is stale; regenerating skill '$skill_id' produces a different adapter"
			ok=1
		fi
	done < <(adapter_files "$skill_id")
	return $ok
}

# --- Probe mode: a dedicated CLI path for the D3.7 harness, separate from the full scan below ---
if [[ -n "$probe_class" ]]; then
	SKILL_ID="highway-inquiry"
	case "$probe_class" in
		generated-artifact)
			backup_dir="$(mktemp -d)"
			cp "$CATALOG" "$backup_dir/catalog.json"
			cp "$ADAPTER_MANIFEST" "$backup_dir/adapter-manifest"
			cp "$DIST_MANIFEST" "$backup_dir/dist-manifest"
			GH_FILE="$REPO_ROOT/.github/skills/$SKILL_ID/SKILL.md"
			cp "$GH_FILE" "$backup_dir/gh-skill.md"
			restore_probe() {
				cp "$backup_dir/catalog.json" "$CATALOG"
				cp "$backup_dir/adapter-manifest" "$ADAPTER_MANIFEST"
				cp "$backup_dir/dist-manifest" "$DIST_MANIFEST"
				cp "$backup_dir/gh-skill.md" "$GH_FILE"
				rm -rf "$backup_dir"
			}
			trap restore_probe EXIT
			if [[ "$neutralise" -eq 0 ]]; then
				grep -v "\"id\": \"$SKILL_ID\"" "$CATALOG" >"$CATALOG.probe-$$" && mv "$CATALOG.probe-$$" "$CATALOG"
				rm -f "$GH_FILE"
				grep -vF ".github/skills/$SKILL_ID/SKILL.md" "$ADAPTER_MANIFEST" >"$ADAPTER_MANIFEST.probe-$$" && mv "$ADAPTER_MANIFEST.probe-$$" "$ADAPTER_MANIFEST"
				grep -vF ".github/skills/$SKILL_ID" "$DIST_MANIFEST" >"$DIST_MANIFEST.probe-$$" && mv "$DIST_MANIFEST.probe-$$" "$DIST_MANIFEST"
			fi
			if check_skill_correspondence "$SKILL_ID" >/dev/null 2>&1; then
				exit 0
			else
				exit 1
			fi
			;;
		source-document)
			SRC_FILE="$HIGHWAY_ROOT/skills/$SKILL_ID/SKILL.md"
			SRC_BACKUP="$(mktemp)"
			cp "$SRC_FILE" "$SRC_BACKUP"
			currency_tmp=""
			restore_probe() {
				cp "$SRC_BACKUP" "$SRC_FILE"
				rm -f "$SRC_BACKUP"
				[[ -n "$currency_tmp" && -d "$currency_tmp" ]] && rm -rf "$currency_tmp"
			}
			trap restore_probe EXIT
			if [[ "$neutralise" -eq 0 ]]; then
				sed -i.bak "s/^description: .*/description: probe-perturbed-$$ description/" "$SRC_FILE" && rm -f "$SRC_FILE.bak"
			fi
			currency_tmp="$(mktemp -d)"
			cp -R "$HIGHWAY_ROOT" "$currency_tmp/.highway"
			(
				cd "$currency_tmp" || exit 1
				.highway/tools/generate-catalog.sh
				.highway/tools/generate-library-catalog.sh
				.highway/tools/generate-agent-adapters.sh
			) >/dev/null 2>&1
			if skill_currency_ok "$SKILL_ID" "$currency_tmp" >/dev/null 2>&1; then
				exit 0
			else
				exit 1
			fi
			;;
	esac
fi

# ---------------------------------------------------------------------------
# D4.5 -- every skill present has its generated artifacts.
# ---------------------------------------------------------------------------
skill_count=0
for skill_dir in "$HIGHWAY_ROOT"/skills/*/; do
	[[ -f "$skill_dir/SKILL.md" ]] || continue
	skill_id="$(basename "$skill_dir")"
	skill_count=$((skill_count + 1))

	# Without a manifest row the generator has no hash to compare against, so a hand-edited
	# adapter for this skill would be silently overwritten instead of refused.
	check_skill_correspondence "$skill_id" || fail=1
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
	skill_currency_ok "$skill_id" "$CURRENCY_TMP" || fail=1
done

exit $fail
