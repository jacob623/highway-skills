#!/usr/bin/env bash
# Shared deterministic assertions for governance behavior fixtures.

assert_file_unchanged() {
	local label="$1" before="$2" after="$3"
	if [[ "$before" != "$after" ]]; then
		echo "FAIL: $label changed bytes"
		return 1
	fi
}

assert_deterministic() {
	local label="$1" first="$2" second="$3"
	assert_file_unchanged "$label" "$first" "$second"
}

assert_status() {
	local label="$1" expected="$2" actual="$3"
	if [[ "$expected" != "$actual" ]]; then
		echo "FAIL: $label (expected '$expected', got '$actual')"
		return 1
	fi
}

assert_no_artifact() {
	local label="$1" path="$2"
	if [[ -e "$path" ]]; then
		echo "FAIL: $label created '$path'"
		return 1
	fi
}
