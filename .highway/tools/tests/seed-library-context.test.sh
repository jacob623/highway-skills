#!/usr/bin/env bash
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must fail when the copy tool is absent or a mapping is wrong.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SEED_TOOL="$HIGHWAY_ROOT/tools/seed-library-context.sh"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/seed-library-context.XXXXXX")"
fail=0

cleanup() {
	rm -rf "$TMP_ROOT"
}
trap cleanup EXIT

fail_test() {
	echo "FAIL: $1"
	fail=1
}

mkdir -p "$TMP_ROOT/.highway/library/knowledge"
for name in highway-identity.md highway-platform-objectives.md highway-vision.md; do
	printf 'seed:%s\n' "$name" >"$TMP_ROOT/$name"
done
printf 'keep me\n' >"$TMP_ROOT/.highway/library/knowledge/unrelated.md"

if [[ ! -x "$SEED_TOOL" ]]; then
	fail_test "copy tool is missing or not executable: $SEED_TOOL"
else
	if ! HIGHWAY_ROOT="$TMP_ROOT" "$SEED_TOOL" >/dev/null 2>&1; then
		fail_test "complete source set should copy successfully"
	fi
	for name in highway-identity.md highway-platform-objectives.md highway-vision.md; do
		if [[ ! -f "$TMP_ROOT/.highway/library/knowledge/$name" ]]; then
			fail_test "destination missing: $name"
		elif ! cmp -s "$TMP_ROOT/$name" "$TMP_ROOT/.highway/library/knowledge/$name"; then
			fail_test "destination differs from source: $name"
		fi
	done
	if ! cmp -s "$TMP_ROOT/.highway/library/knowledge/unrelated.md" <(printf 'keep me\n'); then
		fail_test "unrelated knowledge file changed"
	fi

	rm "$TMP_ROOT/highway-vision.md"
	rm "$TMP_ROOT/.highway/library/knowledge/highway-vision.md"
	if HIGHWAY_ROOT="$TMP_ROOT" "$SEED_TOOL" >/dev/null 2>&1; then
		fail_test "missing source should fail"
	fi
	if [[ -e "$TMP_ROOT/.highway/library/knowledge/highway-vision.md" ]]; then
		fail_test "missing source should not leave a new destination"
	fi
	printf 'seed:highway-vision.md\n' >"$TMP_ROOT/highway-vision.md"
	printf 'stale\n' >"$TMP_ROOT/.highway/library/knowledge/highway-identity.md"
	if ! HIGHWAY_ROOT="$TMP_ROOT" "$SEED_TOOL" >/dev/null 2>&1; then
		fail_test "conflicting destination should converge successfully"
	elif ! cmp -s "$TMP_ROOT/highway-identity.md" "$TMP_ROOT/.highway/library/knowledge/highway-identity.md"; then
		fail_test "conflicting destination was not replaced with source bytes"
	fi
fi

exit "$fail"
