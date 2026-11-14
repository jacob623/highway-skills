#!/usr/bin/env bash
# Every skill reads only its own folder. Each bundled file is named in its SKILL.md by a relative
# path one level deep, and exists; no skill or bundled file names a path outside the skill; setup
# writes only seeded files; and the repository has no Highway root folder ($TOKEN below), nor any
# script, test, harness file, manifest, or live document naming one, except a code product's own
# records.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: each check runs against a temporary copy seeded with its defect and must
# report it.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# Assembled so this file does not name the folder it forbids.
TOKEN=".""highway"
# Assembled because shipped-tree-independence.test.sh scans this file for development-folder tokens.
DEV_CONSTITUTION=".""specify/memory/constitution.md"
# A code product's records keep the folder name inside the product (code/<folder>/.highway/).
CODE_PRODUCT='code\\?/|product|metadata\.md|features\\?/'
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
fail=0

# check_skill <skill dir>: prints one problem per line.
check_skill() {
	local dir="$1" skill="$1/SKILL.md" name rel f
	name="$(basename "$dir")"
	while IFS= read -r rel; do
		[[ -n "$rel" ]] || continue
		case "$rel" in
		*/*/*) echo "$name: $rel is more than one level deep" ;;
		esac
		[[ -f "$dir/$rel" ]] || echo "$name: $rel is named but does not exist"
	done < <(grep -oE '(^|[^A-Za-z0-9_./-])(references|assets|scripts)/[A-Za-z0-9_.-]+(/[A-Za-z0-9_.-]+)*' "$skill" \
		| sed -E 's#^[^a-z]##; s#\.+$##' | LC_ALL=C sort -u)
	for f in "$dir"/references/* "$dir"/assets/* "$dir"/scripts/*; do
		[[ -e "$f" ]] || continue
		rel="$(basename "$(dirname "$f")")/$(basename "$f")"
		if [[ -d "$f" ]]; then
			echo "$name: $rel is a folder; bundled files sit one level deep"
		elif ! grep -qF "$rel" "$skill"; then
			echo "$name: $rel is bundled but not named in SKILL.md"
		fi
	done
	for f in "$skill" "$dir"/references/* "$dir"/assets/*.md; do
		[[ -f "$f" ]] || continue
		rel="${f#"$dir"/}"
		grep -nE '\.\./|skills/highway-|(^|[^A-Za-z0-9_.-])(framework|tests|harness)/' "$f" \
			| sed "s#^#$name: $rel:#; s#\$# -- names a path outside the skill#"
		grep -nF "$TOKEN" "$f" | grep -vE "$CODE_PRODUCT" \
			| sed "s#^#$name: $rel:#; s#\$# -- names $TOKEN outside a code product#"
	done
}

# check_setup <setup dir>: setup writes only seeded files.
check_setup() {
	local skill="$1/SKILL.md" seeded rel
	grep -qF 'Setup writes no file other than the seeded files.' "$skill" \
		|| echo "highway-setup: the seeded-only sentence is missing"
	seeded="$(hw_seeded | cut -f1)"
	while IFS= read -r rel; do
		[[ -n "$rel" ]] || continue
		printf '%s\n' "$seeded" | grep -qx "${rel#assets/}" \
			|| echo "highway-setup: $rel is named but is not a seeded file"
	done < <(grep -oE 'assets/[A-Za-z0-9_.-]+' "$skill" | sed -E 's#\.+$##' | LC_ALL=C sort -u)
}

# strip_history <file>: the file without its Sync Impact Report comment, which records history.
strip_history() {
	awk '/^<!--/ { skip = 1 } !skip { print } skip && /-->/ { skip = 0 }' "$1"
}

# check_root <root>: no folder, and no live file naming one outside a code product.
check_root() {
	local root="$1" f
	[[ ! -e "$root/$TOKEN" ]] || echo "$TOKEN/ exists at the repository root"
	while IFS= read -r f; do
		case "$f" in
		*/constitution.md) strip_history "$root/$f" ;;
		*) cat "$root/$f" ;;
		esac | grep -nF "$TOKEN" | grep -vE "$CODE_PRODUCT" | sed "s#^#$f:#"
	done < <(cd "$root" && find framework tests harness README.md "$DEV_CONSTITUTION" \
		\( -name node_modules -o -name .git \) -prune -o -type f -print 2>/dev/null | LC_ALL=C sort)
}

report() {
	local label="$1" out="$2"
	if [[ -n "$out" ]]; then
		printf '%s\n' "$out" | sed "s#^#FAIL: $label: #"
		fail=1
	fi
}

# --- The live tree ---
skill_count=0
for dir in "$HW_SKILLS"/*/; do
	[[ -f "$dir/SKILL.md" ]] || continue
	skill_count=$((skill_count + 1))
	report "skill" "$(check_skill "${dir%/}")"
done
[[ $skill_count -gt 0 ]] || report "skill" "no skills found under skills/"
report "setup" "$(check_setup "$HW_SETUP")"
report "repository" "$(check_root "$HW_ROOT")"

# --- Seeded probes: each check must report its defect ---
probe() {
	local label="$1" out="$2" expect="$3"
	if [[ "$out" != *"$expect"* ]]; then
		echo "FAIL: probe '$label' was not reported (expected '$expect'); got: ${out:-nothing}"
		fail=1
	fi
}
seed_skill() {
	rm -rf "$WORK/highway-help"
	cp -R "$HW_SKILLS/highway-help" "$WORK/highway-help"
	printf '%s\n' "$1" >>"$WORK/highway-help/SKILL.md"
}

seed_skill 'Read `references/deep/file.md`.'
probe "nested path" "$(check_skill "$WORK/highway-help")" "references/deep/file.md is more than one level deep"
seed_skill 'Read `references/absent.md`.'
probe "missing file" "$(check_skill "$WORK/highway-help")" "references/absent.md is named but does not exist"
seed_skill ''
printf 'x\n' >"$WORK/highway-help/assets/unnamed.md"
probe "unnamed file" "$(check_skill "$WORK/highway-help")" "assets/unnamed.md is bundled but not named"
seed_skill 'See `framework/README.md`.'
probe "outside path" "$(check_skill "$WORK/highway-help")" "names a path outside the skill"
seed_skill 'Read `../highway-setup/assets/storage.md`.'
probe "parent path" "$(check_skill "$WORK/highway-help")" "names a path outside the skill"
seed_skill "Write to \`$TOKEN/notes.md\`."
probe "folder token" "$(check_skill "$WORK/highway-help")" "names $TOKEN outside a code product"

rm -rf "$WORK/highway-setup"
cp -R "$HW_SETUP" "$WORK/highway-setup"
sed -i.bak 's/Setup writes no file other than the seeded files\.//' "$WORK/highway-setup/SKILL.md"
printf 'Copy `assets/unseeded.md`.\n' >>"$WORK/highway-setup/SKILL.md"
setup_out="$(check_setup "$WORK/highway-setup")"
probe "setup sentence" "$setup_out" "the seeded-only sentence is missing"
probe "setup copy" "$setup_out" "assets/unseeded.md is named but is not a seeded file"

mkdir -p "$WORK/root/$TOKEN" "$WORK/root/framework" "$WORK/root/tests"
printf 'Read %s/catalog/index.json.\n' "$TOKEN" >"$WORK/root/framework/tool.sh"
printf 'The product keeps code/x/%s/metadata.md.\n' "$TOKEN" >"$WORK/root/tests/ok.sh"
root_out="$(check_root "$WORK/root")"
probe "root folder" "$root_out" "$TOKEN/ exists at the repository root"
probe "live file" "$root_out" "framework/tool.sh:1:"
if [[ "$root_out" == *"tests/ok.sh"* ]]; then
	echo "FAIL: probe 'code product' -- a code product's record path was reported"
	fail=1
fi

[[ $fail -eq 0 ]] && echo "PASS: every skill reads only its own folder, and no $TOKEN/ remains"
exit $fail
