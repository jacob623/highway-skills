#!/usr/bin/env bash
# Bash 3.2-compatible helpers for Feature 093 disposable contract fixtures.
set -u

feature093_snapshot_tree() {
	local root="$1"
	local output="$2"
	find "$root" -type f -print | sort | while IFS= read -r file; do
		shasum "$file"
	done >"$output"
}

feature093_assert_snapshot_unchanged() {
	local before="$1"
	local root="$2"
	local after="$3"
	feature093_snapshot_tree "$root" "$after"
	cmp -s "$before" "$after"
}

feature093_require_text() {
	local file="$1"
	local text="$2"
	grep -Fq "$text" "$file"
}

feature093_forbid_text() {
	local file="$1"
	local text="$2"
	! grep -Fq "$text" "$file"
}

feature093_assert_order() {
	local file="$1"
	local first="$2"
	local second="$3"
	local first_line second_line
	first_line=$(grep -nF "$first" "$file" | head -n 1 | cut -d: -f1)
	second_line=$(grep -nF "$second" "$file" | head -n 1 | cut -d: -f1)
	[[ -n "$first_line" && -n "$second_line" && "$first_line" -lt "$second_line" ]]
}
