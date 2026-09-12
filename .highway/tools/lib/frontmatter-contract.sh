#!/usr/bin/env bash
# Reads .frontmatter-contract as data. Holds no key list, no requiredness, and no constraint
# text of its own -- everything is parsed at run time from the manifest, mirroring
# lib/constitution.sh's approach to the constitution (per feature 045, Decision 1).
#
# Manifest shape: TAB-delimited "scope<TAB>key<TAB>required<TAB>constraint" rows. Lines
# starting with # and blank lines are ignored. scope is "top" or "metadata"; required is
# "yes" or "no"; constraint is "-", "kebab-case", "length:MIN-MAX", "enum:v1,v2,...", or
# "semver".

: "${FRONTMATTER_CONTRACT_FILE:=}"

# Resolves the manifest path, preferring an explicit override. Anchored at the framework root.
# Usage: fc_file <highway_root>
fc_file() {
	local highway_root="$1"
	if [[ -n "$FRONTMATTER_CONTRACT_FILE" ]]; then
		printf '%s' "$FRONTMATTER_CONTRACT_FILE"
	else
		printf '%s' "$highway_root/tools/.frontmatter-contract"
	fi
}

# Prints each non-comment, non-blank manifest line, unmodified (still TAB-delimited).
# Usage: fc_rows <highway_root>
fc_rows() {
	local highway_root="$1" file
	file="$(fc_file "$highway_root")"
	[[ -f "$file" ]] || return 0
	awk -F'\t' '!/^#/ && NF > 0 { print }' "$file"
}

# Validates the manifest shape. Prints one "ERROR: [SCHEMA] ..." line per problem and returns 1
# if the manifest is malformed; prints nothing and returns 0 if it is well-formed. A malformed
# manifest is a hard failure -- callers must not silently fall back to treating it as empty.
# Usage: fc_validate_manifest <highway_root>
fc_validate_manifest() {
	local highway_root="$1" file ok=0
	file="$(fc_file "$highway_root")"
	if [[ ! -f "$file" ]]; then
		echo "ERROR: [SCHEMA] frontmatter contract manifest not found at '$file'"
		return 1
	fi
	while IFS=$'\t' read -r scope key required constraint; do
		if [[ "$scope" != "top" && "$scope" != "metadata" ]]; then
			echo "ERROR: [SCHEMA] frontmatter contract manifest: invalid scope '$scope' for key '$key' (must be 'top' or 'metadata')"
			ok=1
		fi
		if [[ "$required" != "yes" && "$required" != "no" ]]; then
			echo "ERROR: [SCHEMA] frontmatter contract manifest: invalid required flag '$required' for key '$key' (must be 'yes' or 'no')"
			ok=1
		fi
		if [[ ! "$constraint" =~ ^(-|kebab-case|semver|length:[0-9]+-[0-9]+|enum:.+)$ ]]; then
			echo "ERROR: [SCHEMA] frontmatter contract manifest: invalid constraint '$constraint' for key '$key'"
			ok=1
		fi
	done < <(fc_rows "$highway_root")

	local dup
	dup="$(fc_rows "$highway_root" | awk -F'\t' '{print $1"\t"$2}' | sort | uniq -d)"
	if [[ -n "$dup" ]]; then
		while IFS= read -r pair; do
			[[ -z "$pair" ]] && continue
			echo "ERROR: [SCHEMA] frontmatter contract manifest: duplicate entry for scope/key '$pair'"
			ok=1
		done <<< "$dup"
	fi
	return $ok
}

# Prints the declared key names for a scope (regardless of requiredness), one per line.
# Usage: fc_declared_keys <highway_root> <scope>
fc_declared_keys() {
	local highway_root="$1" scope="$2"
	fc_rows "$highway_root" | awk -F'\t' -v scope="$scope" '$1 == scope { print $2 }'
}

# Prints the required key names for a scope, one per line.
# Usage: fc_required_keys <highway_root> <scope>
fc_required_keys() {
	local highway_root="$1" scope="$2"
	fc_rows "$highway_root" | awk -F'\t' -v scope="$scope" '$1 == scope && $3 == "yes" { print $2 }'
}

# Prints the constraint token declared for a scope+key, or nothing if undeclared.
# Usage: fc_constraint <highway_root> <scope> <key>
fc_constraint() {
	local highway_root="$1" scope="$2" key="$3"
	fc_rows "$highway_root" | awk -F'\t' -v scope="$scope" -v key="$key" '$1 == scope && $2 == key { print $4; exit }'
}
