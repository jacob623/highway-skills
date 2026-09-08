#!/usr/bin/env bash
# Reads .highway/tools/.distribution-manifest, the single declaration of which repository paths
# enter the user-facing distribution (D1.6).
#
# Two callers share this library: generate-distribution.sh, which copies what is included, and
# shipped-tree-independence.test.sh, which scans distributed files for development-only
# references. Neither keeps its own copy of the path set.
#
# Classification is by longest matching prefix, so a directory record covers its descendants and
# a more specific record overrides it. A path matching no record is 'unclassified' and is a
# failure rather than a default, because a silently unclassified path is how a new directory
# would go unnoticed.

DIST_MANIFEST_DEFAULT="${DIST_MANIFEST_DEFAULT:-}"

dist_manifest_file() {
	if [[ -n "$DIST_MANIFEST_DEFAULT" ]]; then
		echo "$DIST_MANIFEST_DEFAULT"
		return 0
	fi
	local lib_dir
	lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	echo "$lib_dir/../.distribution-manifest"
}

# Emits "classification<TAB>source<TAB>destination" for every record, comments and blanks removed.
dist_records() {
	local manifest
	manifest="$(dist_manifest_file)"
	[[ -f "$manifest" ]] || return 1
	awk -F'\t' '
		/^[[:space:]]*#/ { next }
		/^[[:space:]]*$/ { next }
		NF >= 2 { print $1 "\t" $2 "\t" (NF >= 3 ? $3 : "-") }
	' "$manifest"
}

# include | exclude | unclassified, by longest matching prefix.
dist_classify() {
	local path="$1"
	dist_records | awk -F'\t' -v p="$path" '
		{
			src = $2
			# A record matches the path itself or anything beneath it.
			if (p == src || index(p, src "/") == 1) {
				if (length(src) > best_len) { best_len = length(src); best = $1 }
			}
		}
		END { print (best == "" ? "unclassified" : best) }
	'
}

dist_included_sources() {
	dist_records | awk -F'\t' '$1 == "include" { print $2 }'
}

# The path a source occupies in the distribution. Echoes the source when it lands unchanged.
dist_destination() {
	local source="$1"
	dist_records | awk -F'\t' -v s="$source" '
		$2 == s { print ($3 == "-" ? s : $3); found = 1; exit }
		END { if (!found) print s }
	'
}

# Repository paths matching no record. Walks top-level entries and descends only where a record
# distinguishes something beneath, so the walk stays proportional to the manifest.
dist_unclassified_paths() {
	local repo_root="$1"
	local entry rel
	for entry in "$repo_root"/* "$repo_root"/.[!.]*; do
		[[ -e "$entry" ]] || continue
		rel="${entry#"$repo_root"/}"
		[[ "$rel" == ".git" ]] && continue
		if [[ "$(dist_classify "$rel")" == "unclassified" ]]; then
			echo "$rel"
		fi
	done
}
