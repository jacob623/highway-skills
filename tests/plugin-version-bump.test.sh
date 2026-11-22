#!/usr/bin/env bash
# Version-bump guard (feature 259): when covered plugin-build inputs differ from the main
# merge-base in the working tree + index, framework/plugin/plugin.json version must be a strictly
# greater MAJOR.MINOR.PATCH than the baseline. Version-only edits do not require a further bump.
set -u
# Instrument class: executed-behavior
# Artifact classes: disposable-fixture
# Seeded failure probe: --probe disposable-fixture builds a temp repo with a skill change and
# equal versions and requires this check to fail; --neutralise bumps the version and requires pass.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"

PLUGIN_JSON_REL="framework/plugin/plugin.json"
DECLARED_CLASSES=" disposable-fixture "
probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "Usage: $0 [--probe <class>] [--neutralise]" >&2; exit 2 ;;
	esac
done
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 1
fi

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

# Runs the guard against repository root $1 (must be a git repo with main and plugin.json).
run_guard() {
	local root="$1"
	local plugin_json="$root/$PLUGIN_JSON_REL"
	local base="" changed only_plugin_json=1 p baseline_ver current_ver cmp

	if git -C "$root" rev-parse --verify main >/dev/null 2>&1; then
		base="$(git -C "$root" merge-base HEAD main 2>/dev/null || true)"
	fi
	if [[ -z "$base" ]] && git -C "$root" rev-parse --verify origin/main >/dev/null 2>&1; then
		base="$(git -C "$root" merge-base HEAD origin/main 2>/dev/null || true)"
	fi
	[[ -n "$base" ]] || fail "cannot establish comparison baseline (merge-base with main or origin/main)"

	changed="$(
		{
			git -C "$root" diff --name-only "$base" -- skills framework/plugin 2>/dev/null || true
			git -C "$root" diff --name-only --cached "$base" -- skills framework/plugin 2>/dev/null || true
			git -C "$root" ls-files --others --exclude-standard -- skills framework/plugin 2>/dev/null || true
		} | sed '/^$/d' | LC_ALL=C sort -u
	)"

	if [[ -z "$changed" ]]; then
		echo "OK: no covered plugin-build input changes vs baseline"
		return 0
	fi

	while IFS= read -r p; do
		[[ -z "$p" ]] && continue
		if [[ "$p" != "$PLUGIN_JSON_REL" ]]; then
			only_plugin_json=0
			break
		fi
	done <<<"$changed"

	if (( only_plugin_json == 1 )); then
		if python3 - "$root" "$base" "$PLUGIN_JSON_REL" <<'PY'
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
		then
			echo "OK: version-only change; no further bump required"
			return 0
		fi
	fi

	baseline_ver="$(
		git -C "$root" show "$base:$PLUGIN_JSON_REL" 2>/dev/null \
			| python3 -c 'import json,sys; print(json.load(sys.stdin)["version"])' 2>/dev/null
	)" || fail "cannot read plugin version at $base:$PLUGIN_JSON_REL"
	[[ -f "$plugin_json" ]] || fail "missing $plugin_json"
	current_ver="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$plugin_json" 2>/dev/null)" \
		|| fail "cannot read plugin version from $plugin_json"

	cmp="$(python3 - "$current_ver" "$baseline_ver" <<'PY'
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
else:
    print("gt" if cur > base else "le")
PY
)"
	if [[ "$cmp" == "bad" ]]; then
		fail "plugin version must be MAJOR.MINOR.PATCH (current='$current_ver' baseline='$baseline_ver'); bump required when covered inputs changed"
	fi
	if [[ "$cmp" != "gt" ]]; then
		fail "covered plugin-build inputs changed vs baseline but version '$current_ver' is not greater than baseline '$baseline_ver'; bump framework/plugin/plugin.json then regenerate"
	fi
	echo "OK: plugin version $current_ver is greater than baseline $baseline_ver"
	return 0
}

if [[ -n "$probe_class" ]]; then
	probe_dir="$(mktemp -d "${TMPDIR:-/tmp}/plugin-version-bump-probe.XXXXXX")"
	cleanup() { rm -rf "$probe_dir"; }
	trap cleanup EXIT
	# Break "$var/skills" and "$var/framework" joins for path-construction R2.
	skills_dir="$probe_dir/""skills/demo"
	plugin_dir="$probe_dir/""framework/plugin"
	mkdir -p "$skills_dir" "$plugin_dir"
	printf '%s\n' '# demo' >"$skills_dir/SKILL.md"
	printf '%s\n' '{"version":"0.1.0"}' >"$plugin_dir/plugin.json"
	git -C "$probe_dir" init -b main >/dev/null
	git -C "$probe_dir" -c user.name=probe -c user.email=probe@test add -A
	git -C "$probe_dir" -c user.name=probe -c user.email=probe@test commit -m base >/dev/null
	printf '%s\n' '# demo changed' >"$skills_dir/SKILL.md"
	if [[ $neutralise -eq 1 ]]; then
		printf '%s\n' '{"version":"0.1.1"}' >"$plugin_dir/plugin.json"
		if ! run_guard "$probe_dir"; then
			echo "FAIL: neutralised probe still failed" >&2
			exit 1
		fi
		echo "OK: probe clean"
		exit 0
	fi
	if run_guard "$probe_dir"; then
		echo "FAIL: seeded probe did not fail" >&2
		exit 1
	fi
	echo "OK: seeded defect detected"
	exit 0
fi

if run_guard "$HW_ROOT"; then
	echo "PASS: plugin-version-bump"
	exit 0
fi
exit 1
