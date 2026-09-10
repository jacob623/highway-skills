#!/usr/bin/env bash
# Contract checks for the Feature 028 rename follow-up.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
AUDIT="$HIGHWAY_ROOT/tools/audit-objective-rename.sh"
ALLOWLIST="$HIGHWAY_ROOT/tools/.objective-rename-allowlist"
specs_dir="spec""s"
PLAN="$REPO_ROOT/$specs_dir/028-objectives-rename-cleanup/plan.md"
PROBE="$HIGHWAY_ROOT/catalog/objective-rename-probe-$$.md"
WORK="$(mktemp -d)"
fail=0

legacy_token="highway-""objective"
legacy_test="objectives-""management.test.sh"
allowlist_backup="$WORK/allowlist"
plan_backup="$WORK/plan"
cp "$ALLOWLIST" "$allowlist_backup"
cp "$PLAN" "$plan_backup"

cleanup() {
	if [[ -f "$allowlist_backup" ]]; then
		cp "$allowlist_backup" "$ALLOWLIST"
	fi
	if [[ -f "$plan_backup" ]]; then
		cp "$plan_backup" "$PLAN"
	fi
	rm -f "$PROBE"
	rm -rf "$WORK"
}
trap cleanup EXIT HUP INT TERM

pass() { echo "OK: $1"; }
fail_check() {
	echo "FAIL: $1" >&2
	fail=1
}

expect_failure() {
	local label="$1" expected="$2" output="$WORK/$3"
	if "$AUDIT" >"$output" 2>&1; then
		fail_check "$label did not fail"
	elif grep -Fq "$expected" "$output"; then
		pass "$label"
	else
		fail_check "$label failed without expected diagnostic: $expected"
		sed 's/^/    /' "$output" >&2
	fi
}

if [[ ! -x "$AUDIT" ]]; then
	fail_check "migration audit is missing or not executable: $AUDIT"
else
	pass "migration audit is executable"
fi
if [[ ! -f "$ALLOWLIST" ]]; then
	fail_check "migration allowlist is missing: $ALLOWLIST"
else
	pass "migration allowlist exists"
fi

if [[ "$fail" -eq 0 ]] && "$AUDIT" >"$WORK/clean.log" 2>&1; then
	pass "clean migration audit passes"
else
	fail_check "clean migration audit failed"
	if [[ -f "$WORK/clean.log" ]]; then
		sed 's/^/    /' "$WORK/clean.log" >&2
	fi
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi

# Policy failures must be explicit and must not widen the scan.
mv "$ALLOWLIST" "$ALLOWLIST.missing"
expect_failure "missing allowlist is rejected" "migration allowlist is missing" missing
mv "$ALLOWLIST.missing" "$ALLOWLIST"

printf '/absolute/path\n' >"$ALLOWLIST"
expect_failure "absolute allowlist path is rejected" "malformed migration allowlist entry" absolute

printf '../escape\n' >"$ALLOWLIST"
expect_failure "parent-traversal allowlist path is rejected" "malformed migration allowlist entry" traversal

printf 'duplicate/path\nduplicate/path\n' >"$ALLOWLIST"
expect_failure "duplicate allowlist entry is rejected" "duplicate migration allowlist entry" duplicate

printf '.highway/tools/prohibited\n' >"$ALLOWLIST"
expect_failure "non-empty allowlist is rejected" "migration allowlist must be empty" nonempty

printf '.highway/skills/highway-objectives\n' >"$ALLOWLIST"
expect_failure "prohibited allowlist path is rejected" "migration allowlist must be empty" prohibited

cp "$allowlist_backup" "$ALLOWLIST"

# Live-surface stale references must fail and name the injected file.
printf 'legacy reference: %s\n' "$legacy_token" >"$PROBE"
expect_failure "stale live reference is rejected" "stale singular objective references found" stale
rm -f "$PROBE"

# Provenance and traceability contradictions must fail independently.
printf '\nThe packaging generator regenerates the distribution manifest.\n' >>"$PLAN"
expect_failure "generated-manifest contradiction is rejected" "Feature 028 manifest provenance" provenance
cp "$plan_backup" "$PLAN"

printf '\nTemporary typo probe: %s\n' "$legacy_test" >>"$PLAN"
expect_failure "stale Feature 028 test path is rejected" "stale objective-management test path" traceability
cp "$plan_backup" "$PLAN"

if [[ -e "$PROBE" ]]; then
	fail_check "stale-reference probe was not cleaned up"
else
	pass "negative-test probe cleaned up"
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "OK: objective rename contract passes"
