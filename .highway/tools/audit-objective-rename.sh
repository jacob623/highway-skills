#!/usr/bin/env bash
# Enforces the zero-exception contract left by the highway-objectives rename.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
ALLOWLIST="$SCRIPT_DIR/.objective-rename-allowlist"
MANIFEST="$SCRIPT_DIR/.distribution-manifest"
PACKAGER="$SCRIPT_DIR/generate-distribution.sh"
FEATURE_028="$REPO_ROOT/specs/028-objectives-rename-cleanup/plan.md"
PLANNING_BOUNDARY="specs/029-migration-contract-enforcement/"
WORK="$(mktemp -d)"
fail=0

cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT HUP INT TERM

pass() { echo "PASS: $1"; }
failure() {
	echo "FAIL: $1" >&2
	fail=1
}

snapshot_path() {
	local path="$1" output="$2"
	if [[ -e "$path" ]]; then
		echo "present" >"$output"
		if [[ -f "$path" ]]; then
			shasum -a 256 "$path" >>"$output"
		else
			find "$path" -type f -print | sort | while IFS= read -r file; do
				shasum -a 256 "$file"
			done >>"$output"
		fi
	else
		echo "absent" >"$output"
	fi
}

check_snapshot() {
	local path="$1" before="$2" after="$WORK/after.$3"
	snapshot_path "$path" "$after"
	if diff -u "$before" "$after" >/dev/null 2>&1; then
		pass "user-owned path preserved: ${path#$REPO_ROOT/}"
	else
		failure "user-owned path changed: ${path#$REPO_ROOT/}"
		diff -u "$before" "$after" >&2 || true
	fi
}

check_provenance() {
	if [[ ! -f "$MANIFEST" ]]; then
		failure "distribution manifest is missing"
	else
		pass "distribution manifest exists"
	fi
	if grep -Fq 'What ships is read from .distribution-manifest' "$PACKAGER" && \
		! grep -Eq '(^|[[:space:]])(write|rewrite|generate|regenerate)[[:space:]]+[^#]*distribution-manifest' "$PACKAGER"; then
		pass "packaging consumes the maintained distribution manifest"
	else
		failure "packaging manifest provenance is contradictory"
	fi
	if [[ -f "$FEATURE_028" ]] && \
		grep -Fq 'maintained `.highway/tools/.distribution-manifest`' "$FEATURE_028" && \
		! grep -Eq 'regenerate(d|s)? (the )?(distribution )?manifest|manifests, and distribution metadata from canonical' "$FEATURE_028"; then
		pass "Feature 028 documents maintained distribution-manifest provenance"
	else
		failure "Feature 028 manifest provenance is missing or claims unsupported generation"
	fi
}

check_allowlist() {
	local line trimmed entry count=0
	if [[ ! -f "$ALLOWLIST" ]]; then
		failure "migration allowlist is missing"
		return
	fi
	while IFS= read -r line || [[ -n "$line" ]]; do
		trimmed="${line#${line%%[![:space:]]*}}"
		[[ -z "$trimmed" || "${trimmed:0:1}" == '#' ]] && continue
		entry="$trimmed"
		count=$((count + 1))
		if [[ "$entry" == /* || "$entry" == *$'\t'* || "$entry" == *'..'* || "$entry" != [A-Za-z0-9._/-]* ]]; then
			failure "malformed migration allowlist entry: $entry"
		fi
		if grep -Fxq "$entry" "$ALLOWLIST" && [[ "$(grep -Fxc "$entry" "$ALLOWLIST")" -gt 1 ]]; then
			failure "duplicate migration allowlist entry: $entry"
		fi
		failure "migration allowlist must be empty; found: $entry"
	done <"$ALLOWLIST"
	if [[ "$count" -eq 0 ]]; then
		pass "migration allowlist has zero entries"
	fi
}

scan_roots() {
	printf '%s\n' \
		"$HIGHWAY_ROOT" \
		"$REPO_ROOT/.github" \
		"$REPO_ROOT/.claude" \
		"$REPO_ROOT/.cursor" \
		"$REPO_ROOT/README.md" \
		"$REPO_ROOT/specs/028-objectives-rename-cleanup"
}

check_stale_references() {
	local singular_token singular_pattern stale_test stale_pattern
	singular_token="highway-""objective"
	singular_pattern='(^|[^[:alnum:]_-])'"$singular_token"'([^[:alnum:]_-]|$)|'"$singular_token"'/|'"$singular_token"'\.md'
	stale_test="objectives-""management.test.sh"
	stale_pattern="$stale_test"
	find "$HIGHWAY_ROOT" "$REPO_ROOT/.github" "$REPO_ROOT/.claude" "$REPO_ROOT/.cursor" "$REPO_ROOT/README.md" -type f -print 2>/dev/null | sort >"$WORK/files"
	grep -nHE "$singular_pattern|$stale_pattern" $(cat "$WORK/files") >"$WORK/hits" 2>/dev/null || true
	if [[ -s "$WORK/hits" ]]; then
		failure "stale singular objective references found"
		sed 's/^/    /' "$WORK/hits" >&2
	else
		pass "no stale singular objective references outside planning boundary"
	fi
}

check_traceability() {
	local old_path="objectives-""management.test.sh"
	if [[ ! -f "$REPO_ROOT/.highway/tools/tests/objective-management.test.sh" ]]; then
		failure "canonical objective-management test path is missing"
	elif grep -Fq "$old_path" "$FEATURE_028"; then
		failure "Feature 028 contains stale objective-management test path"
	else
		pass "Feature 028 objective-management test path resolves"
	fi
}

before_objectives="$WORK/objectives.before"
before_catalog="$WORK/catalog.before"
snapshot_path "$REPO_ROOT/library/objectives" "$before_objectives"
snapshot_path "$REPO_ROOT/library/governance/objectives.md" "$before_catalog"

check_provenance
check_allowlist
check_stale_references
check_traceability
check_snapshot "$REPO_ROOT/library/objectives" "$before_objectives" objectives
check_snapshot "$REPO_ROOT/library/governance/objectives.md" "$before_catalog" catalog

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: objective rename migration contract"