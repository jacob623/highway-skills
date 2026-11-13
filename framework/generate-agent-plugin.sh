#!/usr/bin/env bash
# Builds highway-agent-plugin/, the Agent Plugins 1.0.0 plugin of the skills (Phase 16), or checks
# that the committed folder matches a fresh build.
#
# The plugin holds exactly plugin.json, README.md, and LICENSE, copied from framework/plugin/, and
# skills/<id>/ for each skill under skills/, with every file except dotfiles. The generator owns
# the folder whole: a build replaces it, and refuses when the folder exists but its plugin.json is
# missing or does not name highway. Files are copied with cp in LC_ALL=C order, and nothing in the
# output depends on time or the host, so two builds from unchanged sources are byte-identical.
#
# Usage:
#   framework/generate-agent-plugin.sh            build highway-agent-plugin/
#   framework/generate-agent-plugin.sh --check    compare highway-agent-plugin/ with a fresh build
#
# Build exit 0: the plugin was written. Exit 1: a skill failed validation or the target was not
# produced by this generator; nothing was written.
# Check exit 0: no difference. Exit 1: one "DRIFT<TAB><differs|missing|extra><TAB><path>" line per
# difference, sorted, then the command that rebuilds the plugin. Check mode writes only under
# ${TMPDIR:-/tmp}.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/paths.sh
source "$SCRIPT_DIR/lib/paths.sh"

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

if [[ "$mode" == "check" ]]; then
	if [[ ! -d "$HW_PLUGIN" ]]; then
		printf 'DRIFT\tmissing\t.\n'
		echo "Run framework/generate-agent-plugin.sh to rebuild $PLUGIN_NAME/."
		exit 1
	fi
	work="$(mktemp -d "${TMPDIR:-/tmp}/agent-plugin-check.XXXXXX")"
	trap 'rm -rf "$work"' EXIT
	build_into "$work/$PLUGIN_NAME"
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
build_into "$staging"
rm -rf "$HW_PLUGIN"
mv "$staging" "$HW_PLUGIN"

skill_count="$(find "$HW_PLUGIN_SKILLS" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
echo "OK: wrote $PLUGIN_NAME ($skill_count skill(s))"
exit 0
