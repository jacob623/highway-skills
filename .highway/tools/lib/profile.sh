#!/usr/bin/env bash
# Shared helpers for the deterministic Markdown Profile contract.
set -u

profile_path() { printf '%s\n' '.highway/library/knowledge/profile.md'; }
profile_domain_keys() { printf '%s\n' identity vision competitive_path guiding_principles highway_role; }
profile_domain_heading() {
	case "$1" in
		identity) printf '%s\n' '## Who We Are' ;;
		vision) printf '%s\n' "## Where We're Going" ;;
		competitive_path) printf '%s\n' '## How We Plan to Get There' ;;
		guiding_principles) printf '%s\n' '## What Guides Our Decisions' ;;
		highway_role) printf '%s\n' '## How Highway Helps' ;;
		*) return 1 ;;
	esac
}
profile_valid_state() {
	case "$1" in not_discussed|discussed|bounded) return 0 ;; *) return 1 ;; esac
}
profile_frontmatter() {
	awk 'BEGIN { in_frontmatter = 0 } NR == 1 && $0 == "---" { in_frontmatter = 1; next } in_frontmatter && $0 == "---" { exit } in_frontmatter { print }' "$1"
}
profile_body() {
	awk 'BEGIN { in_frontmatter = 0; closed = 0 } NR == 1 && $0 == "---" { in_frontmatter = 1; next } in_frontmatter && $0 == "---" { in_frontmatter = 0; closed = 1; next } closed { print }' "$1"
}
profile_metadata_field() {
	profile_frontmatter "$1" | awk -v field="$2" '$0 ~ "^" field ":[[:space:]]*" { sub("^[^:]*:[[:space:]]*", ""); print; exit }'
}
profile_domain_state() {
	profile_frontmatter "$1" | awk -v domain="$2" '$0 ~ "^[[:space:]]+" domain ":[[:space:]]*" { sub("^[^:]*:[[:space:]]*", ""); print; exit }'
}
profile_domain_has_evidence() {
	local profile_file="$1" heading="$2"
	awk -v heading="$heading" '
		$0 == heading { in_section = 1; next }
		in_section && $0 ~ /^##[[:space:]]/ { exit(found ? 0 : 1) }
		in_section && $0 !~ /^[[:space:]]*$/ { found = 1 }
		END { if (in_section) exit(found ? 0 : 1); exit 1 }
	' "$profile_file"
}
profile_next_version() {
	local version="$1" operation="$2" major minor patch
	IFS='.' read -r major minor patch <<EOF
$version
EOF
	case "$operation" in
		add|update|remove) patch=$((patch + 1)) ;;
		reset) minor=$((minor + 1)); patch=0 ;;
		schema-breaking) major=$((major + 1)); minor=0; patch=0 ;;
		*) return 1 ;;
	esac
	printf '%s.%s.%s\n' "$major" "$minor" "$patch"
}
