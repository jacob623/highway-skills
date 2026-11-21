#!/usr/bin/env bash
# Builds highway-agent-plugin/, the Agent Plugins 1.0.0 plugin of the skills (Phase 16), or checks
# that the committed folder matches a fresh build.
#
# The plugin holds plugin.json, README.md, LICENSE, and assets/, copied from framework/plugin/;
# skills/<id>/ for each skill under skills/, with every file except dotfiles; and one manifest per
# agent format (.claude-plugin/, .codex-plugin/, .cursor-plugin/, .antigravity-plugin/, and
# gemini-extension.json), rendered by lib/plugin-manifest.sh from plugin.json, which holds the
# shared fields, and listing.json, which holds the fields only one agent reads. The generator owns
# the folder whole: a build replaces it, and refuses when the folder exists but its plugin.json is
# missing or does not name highway. Files are copied with cp in LC_ALL=C order, manifests are
# rendered in a fixed key order, and nothing in the output depends on time or the host, so two
# builds from unchanged sources are byte-identical.
#
# Usage:
#   framework/generate-agent-plugin.sh            build highway-agent-plugin/
#   framework/generate-agent-plugin.sh --check    compare highway-agent-plugin/ with a fresh build
#
# Both modes first check listing.json and print one "ERROR: [LISTING] <agent>.<field>: <problem>"
# line per finding, such as a shared field it repeats; then they exit 1 with nothing written.
# Build exit 0: the plugin was written. Exit 1: the listing file or a skill failed validation, or
# the target was not produced by this generator; nothing was written.
# Check exit 0: no difference. Exit 1: one "DRIFT<TAB><differs|missing|extra><TAB><path>" line per
# difference, sorted, then the command that rebuilds the plugin. Check mode writes only under
# ${TMPDIR:-/tmp}.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/paths.sh
source "$SCRIPT_DIR/lib/paths.sh"
# shellcheck source=lib/plugin-manifest.sh
source "$HW_LIB/plugin-manifest.sh"

mode="build"
case "${1:-}" in
	"") ;;
	--check) mode="check" ;;
	*)
		echo "Usage: framework/generate-agent-plugin.sh [--check]" >&2
		exit 2
		;;
esac

PLUGIN_NAME="$(basename "$HW_PLUGIN")"
SKILLS_REL="${HW_PLUGIN_SKILLS#"$HW_PLUGIN"/}"
SHIPPED_FILES=(plugin.json README.md LICENSE)
SHIPPED_FOLDERS=(assets)
LISTING="$HW_PLUGIN_SOURCE/listing.json"

# Prints every file in a folder, relative to it, in a fixed order. Dotfiles are not skill content.
skill_files() {
	(cd "$1" && find . -type f ! -name '.*' | sed 's|^\./||' | LC_ALL=C sort)
}

# Prints every entry that is not a folder, relative to the folder, in a fixed order.
tree_files() {
	(cd "$1" && find . ! -type d | sed 's|^\./||' | LC_ALL=C sort)
}

# Builds the shipped set into <dest>, which must not exist.
build_into() {
	local dest="$1" dir id file
	mkdir -p "$dest/$SKILLS_REL"
	for file in "${SHIPPED_FILES[@]}"; do
		cp "$HW_PLUGIN_SOURCE/$file" "$dest/$file"
	done
	for dir in "${SHIPPED_FOLDERS[@]}"; do
		while IFS= read -r file; do
			mkdir -p "$(dirname "$dest/$dir/$file")"
			cp "$HW_PLUGIN_SOURCE/$dir/$file" "$dest/$dir/$file"
		done < <(skill_files "$HW_PLUGIN_SOURCE/$dir")
	done
	pm_render "$HW_PLUGIN_SOURCE/plugin.json" "$LISTING" "$dest" || return 1
	write_marketplaces "$dest" || return 1
	for dir in "$HW_SKILLS"/*/; do
		dir="${dir%/}"
		[[ -f "$dir/SKILL.md" ]] || continue
		id="$(basename "$dir")"
		while IFS= read -r file; do
			mkdir -p "$(dirname "$dest/$SKILLS_REL/$id/$file")"
			cp "$dir/$file" "$dest/$SKILLS_REL/$id/$file"
		done < <(skill_files "$dir")
	done
}

# Writes the four host marketplace catalogs at the plugin root (contracts/marketplace-catalogs.md).
write_marketplaces() {
	local dest="$1"
	if ! command -v python3 >/dev/null 2>&1; then
		echo "ERROR: framework/generate-agent-plugin.sh needs python3 to write marketplace catalogs" >&2
		return 1
	fi
	python3 - "$dest" <<'PY'
import json, os, sys
dest = sys.argv[1]
catalog = {
    "name": "highway",
    "interface": {"displayName": "Highway"},
    "plugins": [
        {
            "name": "highway",
            "source": {"source": "local", "path": "./"},
            "policy": {"installation": "AVAILABLE", "authentication": "ON_INSTALL"},
            "category": "Developer Tools",
        }
    ],
}
text = json.dumps(catalog, indent=2, ensure_ascii=False) + "\n"
paths = [
    os.path.join(dest, ".cursor-plugin", "marketplace.json"),
    os.path.join(dest, ".claude-plugin", "marketplace.json"),
    os.path.join(dest, ".agents", "plugins", "marketplace.json"),
    os.path.join(dest, ".github", "plugin", "marketplace.json"),
]
for path in paths:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
PY
}

pm_listing_check "$HW_PLUGIN_SOURCE/plugin.json" "$LISTING"
case $? in
	0) ;;
	1) exit 1 ;;
	*)
		echo "ERROR: framework/generate-agent-plugin.sh needs python3 to render the agent manifests" >&2
		exit 1
		;;
esac

if [[ "$mode" == "check" ]]; then
	if [[ ! -d "$HW_PLUGIN" ]]; then
		printf 'DRIFT\tmissing\t.\n'
		echo "Run framework/generate-agent-plugin.sh to rebuild $PLUGIN_NAME/."
		exit 1
	fi
	work="$(mktemp -d "${TMPDIR:-/tmp}/agent-plugin-check.XXXXXX")"
	trap 'rm -rf "$work"' EXIT
	build_into "$work/$PLUGIN_NAME" || exit 1
	tree_files "$work/$PLUGIN_NAME" >"$work/expected"
	tree_files "$HW_PLUGIN" >"$work/actual"
	{
		comm -23 "$work/expected" "$work/actual" | sed 's/^/missing	/'
		comm -13 "$work/expected" "$work/actual" | sed 's/^/extra	/'
		comm -12 "$work/expected" "$work/actual" | while IFS= read -r file; do
			diff -q "$work/$PLUGIN_NAME/$file" "$HW_PLUGIN/$file" >/dev/null 2>&1 || printf 'differs\t%s\n' "$file"
		done
	} | LC_ALL=C sort -t "	" -k 2 | sed 's/^/DRIFT	/' >"$work/drift"
	if [[ -s "$work/drift" ]]; then
		cat "$work/drift"
		echo "Run framework/generate-agent-plugin.sh to rebuild $PLUGIN_NAME/."
		exit 1
	fi
	exit 0
fi

invalid_found=0
err="$(mktemp "${TMPDIR:-/tmp}/agent-plugin-validate.XXXXXX")"
for dir in "$HW_SKILLS"/*/; do
	dir="${dir%/}"
	if ! bash "$HW_FRAMEWORK/validate-skill.sh" "$dir" >/dev/null 2>"$err"; then
		echo "ERROR: skill '$(basename "$dir")' failed validation; plugin NOT regenerated:" >&2
		cat "$err" >&2
		invalid_found=1
	fi
done
rm -f "$err"
if [[ $invalid_found -ne 0 ]]; then
	exit 1
fi

if [[ -e "$HW_PLUGIN" ]] && ! grep -qE '^[[:space:]]*"name"[[:space:]]*:[[:space:]]*"highway"' "$HW_PLUGIN/plugin.json" 2>/dev/null; then
	echo "ERROR: '$PLUGIN_NAME' was not produced by framework/generate-agent-plugin.sh -- refusing to overwrite it. Move it aside if it is safe to regenerate." >&2
	exit 1
fi

staging="$(dirname "$HW_PLUGIN")/.$PLUGIN_NAME.build.$$"
trap 'rm -rf "$staging"' EXIT
rm -rf "$staging"
build_into "$staging" || exit 1
rm -rf "$HW_PLUGIN"
mv "$staging" "$HW_PLUGIN"

skill_count="$(find "$HW_PLUGIN_SKILLS" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
echo "OK: wrote $PLUGIN_NAME ($skill_count skill(s))"
exit 0
