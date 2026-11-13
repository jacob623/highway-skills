#!/usr/bin/env bash
# Tests the Agent Plugins build of the skills, highway-agent-plugin/ (Phase 16):
#
#   - the committed folder holds exactly the shipped set: plugin.json, skills/, README.md, LICENSE;
#   - each plugin skill is byte-identical to its source, and the README names every skill;
#   - no development path or repository path reaches the plugin;
#   - the committed folder passes framework/validate-plugin.sh and matches a fresh build;
#   - two builds are byte-identical, and the generator refuses a folder it did not produce and
#     writes nothing when a skill is invalid;
#   - --check names each stale, extra, and missing file;
#   - the validator fails on a seeded defect of each kind it checks;
#   - the distribution excludes the plugin.
#
# Seeded defects run in a copy of skills/, framework/, and the plugin under a temporary root, so
# the working tree is never written. The validator's symbolic-link check has no seeded case here:
# the Declared Toolchain has no utility that creates a link.
set -u
# Instrument class: executed-behavior
# Artifact classes: generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/distribution.sh
source "$HW_LIB/distribution.sh"

GENERATE="$HW_FRAMEWORK/generate-agent-plugin.sh"
VALIDATE="$HW_FRAMEWORK/validate-plugin.sh"
PLUGIN_NAME="$(basename "$HW_PLUGIN")"
PLUGIN_SKILLS="$(hw_rel "$HW_PLUGIN_SKILLS")"
SKILLS_REL="${HW_PLUGIN_SKILLS#"$HW_PLUGIN"/}"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

fail=0
problem() {
	echo "FAIL: $*"
	fail=1
}

for tool in "$GENERATE" "$VALIDATE"; do
	[[ -f "$tool" ]] || problem "$(hw_rel "$tool") does not exist"
done
if [[ ! -d "$HW_PLUGIN" ]]; then
	problem "$PLUGIN_NAME/ does not exist; run $(hw_rel "$GENERATE")"
	exit 1
fi

source_skills() {
	local dir
	for dir in "$HW_SKILLS"/*/; do
		[[ -f "$dir/SKILL.md" ]] && basename "$dir"
	done | LC_ALL=C sort
}

# --- The shipped set ---------------------------------------------------------------------------
entries="$(cd "$HW_PLUGIN" && find . -mindepth 1 -maxdepth 1 | sed 's|^\./||' | LC_ALL=C sort | tr '\n' ' ')"
[[ "$entries" == "LICENSE README.md plugin.json skills " ]] \
	|| problem "$PLUGIN_NAME/ holds '$entries'; expected exactly LICENSE, README.md, plugin.json, skills"

plugin_skills="$(cd "$HW_PLUGIN_SKILLS" 2>/dev/null && find . -mindepth 1 -maxdepth 1 | sed 's|^\./||' | LC_ALL=C sort)"
[[ "$plugin_skills" == "$(source_skills)" ]] \
	|| problem "$PLUGIN_SKILLS/ does not hold exactly the skills under skills/"

while IFS= read -r id; do
	if ! diff -r -x '.*' "$HW_SKILLS/$id" "$HW_PLUGIN_SKILLS/$id" >/dev/null 2>&1; then
		problem "$PLUGIN_SKILLS/$id differs from skills/$id"
	fi
	grep -qF "\`$id\`" "$HW_PLUGIN_SOURCE/README.md" \
		|| problem "$(hw_rel "$HW_PLUGIN_SOURCE")/README.md does not name the skill $id"
done < <(source_skills)

for file in plugin.json README.md LICENSE; do
	diff -q "$HW_PLUGIN_SOURCE/$file" "$HW_PLUGIN/$file" >/dev/null 2>&1 \
		|| problem "$PLUGIN_NAME/$file is not a copy of $(hw_rel "$HW_PLUGIN_SOURCE")/$file"
done

# Assembled so this file does not hold the tokens shipped-tree-independence.test.sh scans for.
leaks="$(grep -rlF -e "."'specify/' -e 'spec''s/' -e "$HW_ROOT" "$HW_PLUGIN" 2>/dev/null)"
[[ -z "$leaks" ]] || problem "a development or repository path reaches the plugin: $leaks"

# --- The committed plugin validates and is current --------------------------------------------
if ! out="$(bash "$VALIDATE" "$HW_PLUGIN" 2>&1)"; then
	problem "$PLUGIN_NAME/ fails validate-plugin.sh:"
	printf '%s\n' "$out" | grep '^ERROR:' | sed 's/^/  /'
fi
if ! out="$(bash "$GENERATE" --check 2>&1)"; then
	problem "$PLUGIN_NAME/ differs from a fresh build:"
	printf '%s\n' "$out" | grep '^DRIFT' | sed 's/^/  /'
fi

# --- The distribution excludes the plugin -----------------------------------------------------
for rel in "$PLUGIN_NAME" "$PLUGIN_SKILLS/highway-help/SKILL.md"; do
	[[ "$(dist_classify "$rel")" == "exclude" ]] || problem "the distribution manifest does not exclude $rel"
done

# --- A copy of the repository for building and seeding ----------------------------------------
repo="$tmp_root/repo"
mkdir -p "$repo"
cp -R "$HW_SKILLS" "$(hw_at "$repo" "$HW_SKILLS")"
cp -R "$HW_FRAMEWORK" "$(hw_at "$repo" "$HW_FRAMEWORK")"
cp -R "$HW_PLUGIN" "$(hw_at "$repo" "$HW_PLUGIN")"
copy_generate="$(hw_at "$repo" "$GENERATE")"
copy_plugin="$(hw_at "$repo" "$HW_PLUGIN")"
copy_skills="$(hw_at "$repo" "$HW_SKILLS")"
pristine="$tmp_root/pristine"
cp -R "$HW_PLUGIN" "$pristine"

restore_copy() {
	rm -rf "$copy_plugin" "$copy_skills"
	cp -R "$HW_SKILLS" "$copy_skills"
	cp -R "$pristine" "$copy_plugin"
}

# Two builds from unchanged sources are byte-identical, and both match the committed plugin.
if bash "$copy_generate" >/dev/null 2>&1; then
	cp -R "$copy_plugin" "$tmp_root/first"
	bash "$copy_generate" >/dev/null 2>&1 || problem "the second build failed"
	diff -r "$tmp_root/first" "$copy_plugin" >/dev/null 2>&1 || problem "two builds from unchanged sources differ"
	diff -r "$HW_PLUGIN" "$copy_plugin" >/dev/null 2>&1 || problem "a fresh build differs from the committed $PLUGIN_NAME/"
else
	problem "building the plugin from unchanged sources failed"
fi
restore_copy

# The generator refuses a folder it did not produce, and leaves it as it was.
rm -rf "$copy_plugin"
mkdir -p "$copy_plugin"
printf 'not a plugin\n' >"$copy_plugin/notes.md"
if out="$(bash "$copy_generate" 2>&1)"; then
	problem "the generator overwrote a folder it did not produce"
elif [[ "$out" != *"'$PLUGIN_NAME'"* ]]; then
	problem "the generator's refusal does not name $PLUGIN_NAME: $out"
fi
[[ -f "$copy_plugin/notes.md" && ! -e "$copy_plugin/plugin.json" ]] || problem "the refused folder was changed"
restore_copy

# An invalid skill stops the build before anything is written.
sed 's/^name: highway-help$/name: highway-helpx/' "$HW_SKILLS/highway-help/SKILL.md" >"$copy_skills/highway-help/SKILL.md"
printf 'stale\n' >>"$copy_plugin/LICENSE"
if bash "$copy_generate" >/dev/null 2>&1; then
	problem "the generator built the plugin with an invalid skill"
fi
[[ "$(tail -n 1 "$copy_plugin/LICENSE")" == "stale" ]] || problem "the generator wrote the plugin although a skill was invalid"
restore_copy

# --check names each kind of drift.
# Usage: expect_drift <label> <kind> <path>
expect_drift() {
	local label="$1" kind="$2" path="$3" out
	if out="$(bash "$copy_generate" --check 2>&1)"; then
		problem "--check passed with $label"
	elif ! printf '%s\n' "$out" | grep -qxF "$(printf 'DRIFT\t%s\t%s' "$kind" "$path")"; then
		problem "--check did not report '$kind $path' for $label: $(printf '%s' "$out" | tr '\n' '|')"
	fi
	restore_copy
}
printf '\nchanged\n' >>"$copy_skills/highway-help/SKILL.md"
expect_drift "a skill changed without a rebuild" differs skills/highway-help/SKILL.md
printf 'extra\n' >"$copy_plugin/NOTES.md"
expect_drift "an extra top-level file" extra NOTES.md
printf 'extra\n' >"$copy_plugin/$SKILLS_REL/highway-help/notes.md"
expect_drift "an extra file inside a skill" extra skills/highway-help/notes.md
rm -f "$copy_plugin/LICENSE"
expect_drift "a missing file" missing LICENSE
rm -rf "$copy_plugin"
expect_drift "no plugin folder" missing .

# --- The validator fails on a seeded defect of each kind it checks ----------------------------
# Usage: expect_invalid <label> <pattern>   (seed the copy at $case_dir first)
case_dir=""
new_case() {
	case_dir="$tmp_root/case-$1"
	rm -rf "$case_dir"
	cp -R "$HW_PLUGIN" "$case_dir"
}
expect_invalid() {
	local label="$1" pattern="$2" out
	if out="$(bash "$VALIDATE" "$case_dir" 2>&1)"; then
		problem "validate-plugin.sh passed a plugin with $label"
	elif ! printf '%s\n' "$out" | grep -q -- "$pattern"; then
		problem "validate-plugin.sh did not report $label with '$pattern': $(printf '%s' "$out" | grep '^ERROR' | tr '\n' '|')"
	fi
}
manifest_with() {
	sed "$1" "$HW_PLUGIN/plugin.json" >"$case_dir/plugin.json"
}

new_case no-name
manifest_with '/"name":/d'
expect_invalid "no name" '^ERROR: \[MANIFEST\] name:'

new_case schema
manifest_with 's|schemas/1\.0\.0/|schemas/9.9.9/|'
expect_invalid "an unsupported \$schema" '^ERROR: \[MANIFEST\] \$schema:'

new_case unknown
manifest_with 's|^{$|{ "homepageUrl": "https://example.com",|'
expect_invalid "an unknown field" '^ERROR: \[MANIFEST\] homepageUrl:'

new_case repeated
manifest_with 's|^{$|{ "name": "other",|'
expect_invalid "a repeated key" '^ERROR: \[MANIFEST\] plugin.json:.*repeated'

new_case not-json
printf '{ "name": "highway",\n' >"$case_dir/plugin.json"
expect_invalid "a manifest that is not JSON" '^ERROR: \[MANIFEST\] plugin.json:'

new_case bad-name
manifest_with 's|"name": "highway"|"name": "Highway--Skills"|'
expect_invalid "a name outside the name constraints" '^ERROR: \[MANIFEST\] name:'

new_case version-type
manifest_with 's|"version": "0.1.0"|"version": 1|'
expect_invalid "a version that is not a string" '^ERROR: \[MANIFEST\] version:'

new_case author
manifest_with 's|^{$|{ "author": { "nick": "x" },|'
expect_invalid "an author field outside name, email, and url" '^ERROR: \[MANIFEST\] author'

new_case keywords
manifest_with 's|^{$|{ "keywords": [1],|'
expect_invalid "keywords that are not strings" '^ERROR: \[MANIFEST\] keywords:'

new_case extensions
manifest_with 's|^{$|{ "extensions": { "com.example": 1 },|'
expect_invalid "an extension that is not an object" '^ERROR: \[MANIFEST\] extensions'

new_case no-manifest
rm -f "$case_dir/plugin.json"
expect_invalid "no plugin.json" '^ERROR: \[MANIFEST\] plugin.json:'

new_case skills-file
rm -rf "$case_dir/$SKILLS_REL"
printf 'not a folder\n' >"$case_dir/$SKILLS_REL"
expect_invalid "a skills entry that is not a folder" '^ERROR: \[LAYOUT\] skills:'

new_case mcp-folder
mkdir -p "$case_dir/mcp.json"
expect_invalid "an mcp.json that is not a file" '^ERROR: \[LAYOUT\] mcp.json:'

new_case no-skill-file
mkdir -p "$case_dir/$SKILLS_REL/empty-skill"
printf 'no SKILL.md here\n' >"$case_dir/$SKILLS_REL/empty-skill/notes.md"
expect_invalid "a skill folder without SKILL.md" '^ERROR: \[LAYOUT\] skills/empty-skill:'

new_case invalid-skill
sed 's/^name: highway-help$/name: highway-helpx/' "$HW_PLUGIN_SKILLS/highway-help/SKILL.md" >"$case_dir/$SKILLS_REL/highway-help/SKILL.md"
expect_invalid "a skill that fails Agent Skills validation" '^ERROR: \[SKILL\] skills/highway-help:'

if [[ $fail -eq 0 ]]; then
	echo "OK: agent-plugin"
fi
exit $fail
