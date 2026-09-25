#!/usr/bin/env bash
# Bash 3.2-compatible helpers for disposable retained Profile fixtures.
set -u
profile_fixture_copy_template() {
	local root="$1" output="$2"
	mkdir -p "$root"
	cp "$root/../../../../library/templates/output/profile-record.md" "$output"
}
profile_fixture_cleanup() {
	local root="$1"
	rm -rf "$root"
}
profile_fixture_hash() {
	shasum -a 256 "$1" | awk '{print $1}'
}
