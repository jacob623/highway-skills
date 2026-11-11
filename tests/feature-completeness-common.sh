#!/usr/bin/env bash
# Shared disposable-tree assertions for Feature 032 behavioral evidence.
set -u

fc_make_tree() {
	local fixture_root="$1"
	local tree_root="$2"
	mkdir -p "$tree_root/library/governance/controls" "$tree_root/library/governance/nfrs"
	if [[ -d "$fixture_root/controls" ]]; then
		cp "$fixture_root/controls"/*.md "$tree_root/library/governance/controls/"
	fi
	if [[ -d "$fixture_root/nfrs" ]]; then
		cp "$fixture_root/nfrs"/*.md "$tree_root/library/governance/nfrs/"
	fi
}

fc_field() {
	local file="$1"
	local field="$2"
	sed -n "s/^${field}:[[:space:]]*\[\(.*\)\]/\1/p" "$file" | head -n 1
}

fc_title() {
	sed -n 's/^title:[[:space:]]*//p' "$1" | head -n 1
}

fc_ids() {
	local value="$1"
	printf '%s\n' "$value" | tr ',' '\n' | sed 's/^ *//; s/ *$//' | sed '/^$/d'
}

fc_snapshot() {
	local root="$1"
	local output="$2"
	find "$root" -type f -print | sort | while IFS= read -r file; do
		printf '%s ' "${file#"$root"/}"
		shasum -a 256 "$file" | cut -d ' ' -f 1
	done >"$output"
}

fc_same_snapshot() {
	diff -u "$1" "$2" >/dev/null 2>&1
}

fc_require_clean() {
	local root="$1"
	if find "$root" -type f -name '*.probe' -o -name '*.tmp' | grep -q .; then
		echo "FAIL: temporary probe remains under $root"
		return 1
	fi
	return 0
}

fc_assert_field_contains() {
	local file="$1"
	local field="$2"
	local expected="$3"
	fc_field "$file" "$field" | grep -Fq "$expected"
}

fc_assert_field_equals() {
	local file="$1"
	local field="$2"
	local expected="$3"
	[[ "$(fc_field "$file" "$field")" == "$expected" ]]
}

fc_relationship_report() {
	local root="$1"
	for control in "$root/library/governance/controls"/*.md; do
		[[ -f "$control" ]] || continue
		local control_id="$(basename "$control" .md)"
		for nfr_id in $(fc_ids "$(fc_field "$control" nfrs)"); do
			local nfr="$root/library/governance/nfrs/$nfr_id.md"
			if ! printf '%s' "$nfr_id" | grep -Eq '^NFR[0-9]{6}$'; then
				printf '%s|%s|malformed\n' "$control_id" "$nfr_id"
			elif [[ ! -f "$nfr" ]]; then
				printf '%s|%s|orphaned\n' "$control_id" "$nfr_id"
			elif ! fc_assert_field_contains "$nfr" controls "$control_id"; then
				printf '%s|%s|asymmetric\n' "$control_id" "$nfr_id"
			else
				printf '%s|%s|valid\n' "$control_id" "$nfr_id"
			fi
		done
	done | sort
}

fc_unique_relationships() {
	local value="$1"
	fc_ids "$value" | sort -u | tr '\n' ',' | sed 's/,$//'
}
