#!/usr/bin/env bash
# Verifies the organizational profile has one canonical path and no former-path references.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
CANONICAL="$HIGHWAY_ROOT/library/templates/output/profile.yaml"
OLD_PATH=".highway/""profile.yaml"
fail=0

if [[ ! -f "$CANONICAL" ]]; then
	echo "FAIL: canonical profile is missing: $CANONICAL"
	fail=1
fi
if [[ -e "$HIGHWAY_ROOT/profile.yaml" ]]; then
	echo "FAIL: former profile path still exists: $HIGHWAY_ROOT/profile.yaml"
	fail=1
fi

for scan_root in \
	"$HIGHWAY_ROOT/skills" \
	"$HIGHWAY_ROOT/tools" \
	"$HIGHWAY_ROOT/catalog" \
	"$REPO_ROOT/.github" \
	"$REPO_ROOT/.claude" \
	"$REPO_ROOT/.cursor"; do
	[[ -d "$scan_root" ]] || continue
	while IFS= read -r file; do
		if grep -Fq "$OLD_PATH" "$file"; then
			echo "FAIL: former profile path referenced by $file"
			fail=1
		fi
	done < <(find "$scan_root" -type f -print)
done

manifest="$HIGHWAY_ROOT/tools/.distribution-manifest"
manifest_entry="include"$'\t'".highway/library/templates/output/profile.yaml"
canonical_count="$(grep -F -c "$manifest_entry" "$manifest" 2>/dev/null || true)"
if [[ "$canonical_count" -ne 1 ]]; then
	echo "FAIL: canonical profile must have exactly one distribution-manifest include (found $canonical_count)"
	fail=1
fi

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: profile migration is clean"
