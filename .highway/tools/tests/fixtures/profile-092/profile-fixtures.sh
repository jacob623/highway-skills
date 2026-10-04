#!/usr/bin/env bash
# Bash 3.2-compatible helpers for disposable retained Profile fixtures.
set -u
profile_fixture_copy_template() {
	local root="$1" output="$2"
	local here
	here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	mkdir -p "$root"
	# Superseded behavior: this helper copied profile-record.md, which was itself a valid Profile.
	# Feature 138 makes that file a skeleton, so copies use the retained empty fixture (D3.5).
	cp "$here/profile-record/empty.md" "$output"
}
profile_fixture_cleanup() {
	local root="$1"
	rm -rf "$root"
}
profile_fixture_hash() {
	shasum -a 256 "$1" | awk '{print $1}'
}
