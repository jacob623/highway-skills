#!/usr/bin/env bash
# Each single-reader record template lives in the assets/ of the skill that creates the record, the
# skill names it there, and the skill validator checks every complete template in a skill's assets/.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, disposable-fixture
# Seeded failure probe: a copy of highway-request whose assets/request-record.md has no description
# fails validation and names that file, and two copies that differ in one asset get different cache keys.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/validation-cache.sh
source "$HW_LIB/validation-cache.sh"
VALIDATE_SKILL="$HW_FRAMEWORK/validate-skill.sh"
MANIFEST="$HW_FRAMEWORK/.distribution-manifest"
fail=0

report() {
	[[ -n "$1" ]] || return 0
	printf 'FAIL: %s\n' "$1"
	fail=1
}

OWNERS="codify-metadata highway-codify
codify-plan highway-codify
codify-record highway-codify
codify-tasks highway-codify
coding-standard highway-codify-config
control-record highway-controls
nfr-record highway-nfrs
objective-record highway-objectives
discovery-record highway-discovery
request-record highway-request
profile-record highway-profile"
MOVED="$(printf '%s\n' "$OWNERS" | cut -d' ' -f1 | paste -sd'|' -)"

# 1. Each template is in its owner's assets/, hw_template finds it there, and the owner names it.
while read -r name owner; do
	path="$(hw_template "$name")"
	if [[ "$path" != "$HW_SKILLS/$owner/assets/$name.md" ]]; then
		report "hw_template $name resolves to $path, not $owner's assets/"
	elif [[ ! -f "$path" ]]; then
		report "$owner has no assets/$name.md"
	fi
	grep -Fq "assets/$name.md" "$HW_SKILLS/$owner/SKILL.md" || report "$owner does not name assets/$name.md"
done <<EOF
$OWNERS
EOF

# 2. Only the three shared record templates remain in the shared folder.
remaining="$(cd "$HW_OUTPUT_TEMPLATES" && find . -type f | sed 's#^\./##' | LC_ALL=C sort | paste -sd' ' -)"
if [[ "$remaining" != "adr-record.md architecture-record.md implementation-record.md" ]]; then
	report "the shared template folder holds '$remaining'"
fi

# 3. No skill names a moved template, or the framework-tree knowledge folder, under .highway/.
while IFS= read -r hit; do
	report "$hit names a moved template under .highway/library/templates/"
done < <(grep -RlE "templates/output/($MOVED)[.]md" "$HW_SKILLS" --include=SKILL.md)
while IFS= read -r hit; do
	report "$hit names .highway/library/knowledge/"
done < <(grep -RlF '.highway/library/knowledge/' "$HW_SKILLS" --include=SKILL.md)

# 4. The distribution ships each moved template inside its skill, not under .highway/.
if grep -Eq "templates/output/($MOVED)[.]md" "$MANIFEST"; then
	report "the distribution manifest lists a moved template under .highway/"
fi

# 5. The skill validator checks complete templates in assets/ and skips skeletons.
probe_root="$(mktemp -d)"
trap 'rm -rf "$probe_root"' EXIT
request_template="$(hw_template request-record)"
asset_rel="${request_template#"$HW_SKILLS/highway-request/"}"
cp -R "$HW_SKILLS/highway-request" "$probe_root/highway-request"
if ! bash "$VALIDATE_SKILL" --no-cache "$probe_root/highway-request" >/dev/null 2>&1; then
	report "an unchanged copy of highway-request does not validate"
fi
sed '/^description:/d' "$request_template" >"$probe_root/highway-request/$asset_rel"
if out="$(bash "$VALIDATE_SKILL" --no-cache "$probe_root/highway-request" 2>&1)"; then
	report "probe: a template with no description in assets/ was not caught"
elif ! printf '%s\n' "$out" | grep -Fq "$asset_rel"; then
	report "probe: the failure does not name $asset_rel"
fi
if ! out="$(bash "$VALIDATE_SKILL" --no-cache "$HW_SETUP" 2>&1)"; then
	report "highway-setup does not validate"
elif printf '%s\n' "$out" | grep -Fq 'assets/'; then
	report "highway-setup's skeletons were checked as templates"
fi

# 6. The cache key covers assets/: same content anywhere gives one key, a changed asset another.
cp -R "$HW_SKILLS/highway-request" "$probe_root/same"
cp -R "$HW_SKILLS/highway-request" "$probe_root/changed"
printf '\n' >>"$probe_root/changed/$asset_rel"
key_same="$(vc_key "$probe_root/same/SKILL.md" "$HW_ROOT")"
key_source="$(vc_key "$HW_SKILLS/highway-request/SKILL.md" "$HW_ROOT")"
key_changed="$(vc_key "$probe_root/changed/SKILL.md" "$HW_ROOT")"
[[ "$key_same" == "$key_source" ]] || report "two identical copies of a skill get different cache keys"
[[ "$key_changed" != "$key_source" ]] || report "probe: a changed asset did not change the cache key"

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "OK: record templates live in their skills' assets/ and are validated there"
