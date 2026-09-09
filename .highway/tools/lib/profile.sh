#!/usr/bin/env bash
# Shared helpers for the retained organizational profile. This is intentionally not a
# general-purpose YAML parser.

profile_frontmatter() {
	local file="$1"
	cat "$file"
}

profile_body() {
	local file="$1"
	cat "$file"
}

profile_top_level_keys() {
	local file="$1"
	profile_frontmatter "$file" | awk '
		/^[^[:space:]#][^:]*:/ {
			key = $0
			sub(/:.*/, "", key)
			gsub(/[[:space:]]+$/, "", key)
			print key
		}
	'
}

profile_metadata_field() {
	local file="$1" field="$2"
	profile_frontmatter "$file" | awk -v field="$field" '
		BEGIN { in_metadata = 0 }
		{
			if ($0 ~ /^[^[:space:]#][^:]*:/) {
				if ($0 ~ /^metadata:/) { in_metadata = 1; next }
				in_metadata = 0
			}
			if (in_metadata && $0 ~ "^[[:space:]]+" field ":") {
				line = $0
				sub("^[[:space:]]+" field ":", "", line)
				gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
				print line
				exit
			}
		}
	'
}

profile_key_rank() {
	case "$1" in
		metadata) echo 1 ;;
		organization) echo 2 ;;
		constraints) echo 3 ;;
		strategic_directions) echo 4 ;;
		preferences) echo 5 ;;
		business_context) echo 6 ;;
		architecture_principles) echo 7 ;;
		approved_technologies) echo 8 ;;
		prohibited_technologies) echo 9 ;;
		operating_model) echo 10 ;;
		vendor_strategy) echo 11 ;;
		*) echo 0 ;;
	esac
}

profile_next_version() {
	local version="$1" operation="$2"
	local major minor patch
	IFS='.' read -r major minor patch <<< "$version"
	case "$operation" in
		add|update|remove) patch=$((patch + 1)) ;;
		reset) minor=$((minor + 1)); patch=0 ;;
		schema-breaking) major=$((major + 1)); minor=0; patch=0 ;;
		*) return 1 ;;
	esac

	printf '%s.%s.%s\n' "$major" "$minor" "$patch"
}
