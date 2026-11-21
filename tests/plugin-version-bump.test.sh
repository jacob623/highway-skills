#!/usr/bin/env bash
# Version-bump guard (feature 259): when covered plugin-build inputs differ from the main
# merge-base in the working tree + index, framework/plugin/plugin.json version must be a strictly
# greater MAJOR.MINOR.PATCH than the baseline. Version-only edits do not require a further bump.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"

PLUGIN_JSON_REL="framework/plugin/plugin.json"
PLUGIN_JSON="$HW_ROOT/$PLUGIN_JSON_REL"

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

resolve_baseline() {
	local base=""
	if git -C "$HW_ROOT" rev-parse --verify main >/dev/null 2>&1; then
		base="$(git -C "$HW_ROOT" merge-base HEAD main 2>/dev/null || true)"
	fi
	if [[ -z "$base" ]] && git -C "$HW_ROOT" rev-parse --verify origin/main >/dev/null 2>&1; then
		base="$(git -C "$HW_ROOT" merge-base HEAD origin/main 2>/dev/null || true)"
	fi
	[[ -n "$base" ]] || fail "cannot establish comparison baseline (merge-base with main or origin/main)"
	printf '%s' "$base"
}

# Prints covered path relative names that differ vs baseline (tracked changes + untracked under cover).
covered_changed_paths() {
	local base="$1"
	{
		git -C "$HW_ROOT" diff --name-only "$base" -- skills framework/plugin 2>/dev/null || true
		git -C "$HW_ROOT" diff --name-only --cached "$base" -- skills framework/plugin 2>/dev/null || true
		git -C "$HW_ROOT" ls-files --others --exclude-standard -- skills framework/plugin 2>/dev/null || true
	} | sed '/^$/d' | LC_ALL=C sort -u
}

read_version_at() {
	local ref="$1"
	git -C "$HW_ROOT" show "$ref:$PLUGIN_JSON_REL" 2>/dev/null \
		| python3 -c 'import json,sys; print(json.load(sys.stdin)["version"])' 2>/dev/null \
		|| fail "cannot read plugin version at $ref:$PLUGIN_JSON_REL"
}

read_version_file() {
	local path="$1"
	[[ -f "$path" ]] || fail "missing $path"
	python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$path" 2>/dev/null \
		|| fail "cannot read plugin version from $path"
}

# Returns 0 if current plugin.json equals baseline except for the version field.
version_only_change() {
	local base="$1"
	python3 - "$HW_ROOT" "$base" "$PLUGIN_JSON_REL" <<'PY'
import json, subprocess, sys
root, base, rel = sys.argv[1:4]
try:
    baseline = json.loads(subprocess.check_output(
        ["git", "-C", root, "show", f"{base}:{rel}"], text=True))
except Exception:
    sys.exit(1)
with open(f"{root}/{rel}", encoding="utf-8") as f:
    current = json.load(f)
baseline["version"] = current.get("version")
sys.exit(0 if baseline == current else 1)
PY
}

semver_cmp() {
	# stdout: gt | le | bad
	python3 - "$1" "$2" <<'PY'
import re, sys
pat = re.compile(r"^(\d+)\.(\d+)\.(\d+)$")
def parse(s):
    m = pat.match(s)
    if not m:
        return None
    return tuple(int(x) for x in m.groups())
cur, base = parse(sys.argv[1]), parse(sys.argv[2])
if cur is None or base is None:
    print("bad")
    sys.exit(0)
print("gt" if cur > base else "le")
PY
}

base="$(resolve_baseline)"
changed="$(covered_changed_paths "$base")"

if [[ -z "$changed" ]]; then
	echo "OK: no covered plugin-build input changes vs baseline"
	echo "PASS: plugin-version-bump"
	exit 0
fi

only_plugin_json=1
while IFS= read -r p; do
	[[ -z "$p" ]] && continue
	if [[ "$p" != "$PLUGIN_JSON_REL" ]]; then
		only_plugin_json=0
		break
	fi
done <<<"$changed"

if (( only_plugin_json == 1 )) && version_only_change "$base"; then
	echo "OK: version-only change; no further bump required"
	echo "PASS: plugin-version-bump"
	exit 0
fi

baseline_ver="$(read_version_at "$base")"
current_ver="$(read_version_file "$PLUGIN_JSON")"
cmp="$(semver_cmp "$current_ver" "$baseline_ver")"

if [[ "$cmp" == "bad" ]]; then
	fail "plugin version must be MAJOR.MINOR.PATCH (current='$current_ver' baseline='$baseline_ver'); bump required when covered inputs changed"
fi
if [[ "$cmp" != "gt" ]]; then
	fail "covered plugin-build inputs changed vs baseline but version '$current_ver' is not greater than baseline '$baseline_ver'; bump framework/plugin/plugin.json then regenerate"
fi

echo "OK: plugin version $current_ver is greater than baseline $baseline_ver"
echo "PASS: plugin-version-bump"
exit 0
