#!/usr/bin/env bash
# Shared helpers for the retained organizational profile. The profile uses the repository's
# controlled YAML-frontmatter shape; this is intentionally not a general-purpose YAML parser.

profile_frontmatter() {
	local file="$1"
	awk '
		/^---[[:space:]]*$/ { delim++; if (delim == 2) exit; next }
		delim == 1 { print }
	' "$file"
}

profile_body() {
	local file="$1"
	awk '
		/^---[[:space:]]*$/ { delim++; next }
		delim >= 2 { print }
	' "$file"
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
		constraints) echo 2 ;;
		strategic_directions) echo 3 ;;
		preferences) echo 4 ;;
		business_context) echo 5 ;;
		architecture_principles) echo 6 ;;
		approved_technologies) echo 7 ;;
		prohibited_technologies) echo 8 ;;
		operating_model) echo 9 ;;
		vendor_strategy) echo 10 ;;
		*) echo 0 ;;
	esac
}
