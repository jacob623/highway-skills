#!/usr/bin/env bash
# Shared shell functions to read the YAML frontmatter block and body of a SKILL.md file.
# No network dependency. Assumes a controlled, self-authored frontmatter shape (see
# skills/_authoring-standard.md) -- this is not a general-purpose YAML parser.

# Prints the raw frontmatter block (lines strictly between the first and second '---' lines).
# Usage: fm_block <file>
fm_block() {
	local file="$1"
	awk '
		/^---[[:space:]]*$/ { delim++; if (delim == 2) exit; next }
		delim == 1 { print }
	' "$file"
}

# Prints the body (everything after the closing '---' of the frontmatter block).
# Usage: fm_body <file>
fm_body() {
	local file="$1"
	awk '
		/^---[[:space:]]*$/ { delim++; next }
		delim >= 2 { print }
	' "$file"
}

# Strips a single layer of matching surrounding quotes (double or single) from a value.
_fm_unquote() {
	local v="$1"
	if [[ "$v" == \"*\" && "$v" == *\" ]]; then
		v="${v:1:${#v}-2}"
	elif [[ "$v" == \'*\' && "$v" == *\' ]]; then
		v="${v:1:${#v}-2}"
	fi
	printf '%s' "$v"
}

# Gets a top-level scalar frontmatter field (e.g. name, description, license, compatibility).
# Only matches lines with zero leading whitespace (top-level keys), so it never matches nested
# keys like metadata.version. Usage: fm_get <file> <key>
fm_get() {
	local file="$1" key="$2" line value
	line=$(fm_block "$file" | grep -E "^${key}:" | head -n1)
	[[ -z "$line" ]] && return 1
	value="${line#*:}"
	value="${value#"${value%%[![:space:]]*}"}" # trim leading whitespace
	value="${value%"${value##*[![:space:]]}"}" # trim trailing whitespace
	_fm_unquote "$value"
}

# Gets a scalar field nested one level under a given top-level parent key (e.g. metadata.version).
# Usage: fm_get_nested <file> <parent> <key>
fm_get_nested() {
	local file="$1" parent="$2" key="$3"
	fm_block "$file" | awk -v parent="$parent" -v key="$key" '
		BEGIN { in_parent = 0 }
		{
			# a new top-level key (zero indentation) ends the parent block
			if ($0 ~ /^[^[:space:]]/) {
				if ($0 ~ "^" parent ":") { in_parent = 1; next }
				else { in_parent = 0 }
			}
			if (in_parent && $0 ~ "^[[:space:]]+" key ":") {
				line = $0
				sub("^[[:space:]]+" key ":", "", line)
				gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
				print line
				exit
			}
		}
	' | { read -r value; _fm_unquote "$value"; }
}

# Prints each metadata.agent_exceptions entry as "agent|deviation" (one per line).
# Usage: fm_get_agent_exceptions <file>
fm_get_agent_exceptions() {
	local file="$1"
	fm_block "$file" | awk '
		BEGIN { in_parent = 0; in_list = 0; agent = ""; deviation = "" }
		function flush() {
			if (agent != "") print agent "|" deviation
			agent = ""; deviation = ""
		}
		{
			if ($0 ~ /^[^[:space:]]/) {
				if ($0 ~ /^metadata:/) { in_parent = 1; next }
				else { if (in_parent) flush(); in_parent = 0; in_list = 0 }
			}
			if (in_parent && $0 ~ /^[[:space:]]+agent_exceptions:/) { in_list = 1; next }
			if (in_parent && in_list) {
				if ($0 ~ /^[[:space:]]+-[[:space:]]*agent:/) {
					flush()
					line = $0; sub(/^[[:space:]]+-[[:space:]]*agent:/, "", line)
					gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
					agent = line
				} else if ($0 ~ /deviation:/) {
					line = $0; sub(/^[[:space:]]*deviation:/, "", line)
					gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
					deviation = line
				} else if ($0 !~ /^[[:space:]]/) {
					in_list = 0
				}
			}
		}
		END { flush() }
	' | while IFS='|' read -r a d; do
		a="$(printf '%s' "$a" | sed -e 's/^["'"'"']//' -e 's/["'"'"']$//')"
		d="$(printf '%s' "$d" | sed -e 's/^["'"'"']//' -e 's/["'"'"']$//')"
		[[ -n "$a" ]] && printf '%s|%s\n' "$a" "$d"
	done
}

# Prints each metadata.dependencies entry as "path|version" (one per line). Structurally
# mirrors fm_get_agent_exceptions above.
# Usage: fm_get_dependencies <file>
fm_get_dependencies() {
	local file="$1"
	fm_block "$file" | awk '
		BEGIN { in_parent = 0; in_list = 0; path = ""; version = "" }
		function flush() {
			if (path != "") print path "|" version
			path = ""; version = ""
		}
		{
			if ($0 ~ /^[^[:space:]]/) {
				if ($0 ~ /^metadata:/) { in_parent = 1; next }
				else { if (in_parent) flush(); in_parent = 0; in_list = 0 }
			}
			if (in_parent && $0 ~ /^[[:space:]]+dependencies:/) { in_list = 1; next }
			if (in_parent && in_list) {
				if ($0 ~ /^[[:space:]]+-[[:space:]]*path:/) {
					flush()
					line = $0; sub(/^[[:space:]]+-[[:space:]]*path:/, "", line)
					gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
					path = line
				} else if ($0 ~ /version:/) {
					line = $0; sub(/^[[:space:]]*version:/, "", line)
					gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
					version = line
				} else if ($0 !~ /^[[:space:]]/) {
					in_list = 0
				}
			}
		}
		END { flush() }
	' | while IFS='|' read -r p v; do
		p="$(printf '%s' "$p" | sed -e 's/^["'"'"']//' -e 's/["'"'"']$//')"
		v="$(printf '%s' "$v" | sed -e 's/^["'"'"']//' -e 's/["'"'"']$//')"
		[[ -n "$p" ]] && printf '%s|%s\n' "$p" "$v"
	done
}
