#!/usr/bin/env bash
# Verifies the profile path migration, schema preservation, and orphan audit.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
AUDIT="$HIGHWAY_ROOT/tools/audit-profile-migration.sh"
PROFILE="$HIGHWAY_ROOT/library/templates/output/profile.yaml"
OLD_PATH=".highway/""profile.yaml"
fail=0

if ! bash "$AUDIT" >/dev/null 2>&1; then
	echo "FAIL: clean migration audit rejected the current tree"
	fail=1
fi

if [[ ! -f "$PROFILE" ]] || grep -Eq '^---[[:space:]]*$' "$PROFILE"; then
	echo "FAIL: canonical profile is missing or contains frontmatter"
	fail=1
fi

probe="$HIGHWAY_ROOT/catalog/profile-migration-probe-$$.json"
printf '%s\n' "$OLD_PATH" >"$probe"
if bash "$AUDIT" >"$probe.audit" 2>&1; then
	echo "FAIL: audit accepted a former-path probe"
	fail=1
elif ! grep -Fq "$probe" "$probe.audit"; then
	echo "FAIL: audit did not identify the former-path probe"
	fail=1
fi
rm -f "$probe" "$probe.audit"

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: profile migration contract passes"
